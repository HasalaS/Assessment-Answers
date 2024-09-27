import boto3
import json
import os
from datetime import datetime

ec2_client = boto3.client('ec2')
sns_client = boto3.client('sns')

sns_topic_arn = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    regions = [region['RegionName'] for region in ec2_client.describe_regions()['Regions']]
    security_group_issues = []

    for region in regions:
        regional_client = boto3.client('ec2', region_name=region)
        security_groups = regional_client.describe_security_groups()['SecurityGroups']

        for sg in security_groups:
            for permission in sg.get('IpPermissions', []):
                if permission['IpRanges'] and any(
                    ip_range.get('CidrIp') in ['0.0.0.0/0', '::/0'] and 
                    permission['FromPort'] not in [80, 443] for ip_range in permission['IpRanges']
                ):
                    issue = {
                        'Region': region,
                        'SecurityGroupName': sg['GroupName'],
                        'SecurityGroupId': sg['GroupId'],
                        'InboundRule': permission
                    }
                    security_group_issues.append(issue)

    if security_group_issues:
        send_notification(security_group_issues)

    return {
        'statusCode': 200,
        'body': json.dumps('Check completed')
    }

def send_notification(issues):
    message = "Security Groups with Open Inbound Rules:\n\n"
    for issue in issues:
        message += f"Region: {issue['Region']}\n"
        message += f"Security Group Name: {issue['SecurityGroupName']}\n"
        message += f"Security Group ID: {issue['SecurityGroupId']}\n"
        message += f"Inbound Rule: {issue['InboundRule']}\n\n"
    
    response = sns_client.publish(
        TopicArn=sns_topic_arn,
        Subject='Security Group Alert',
        Message=message
    )
    return response
