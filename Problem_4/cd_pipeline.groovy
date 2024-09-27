pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = 'aws-account-id.dkr.ecr.your-region.amazonaws.com/web-app'
        ECS_CLUSTER = 'web-ecs-cluster'
        ECS_SERVICE = 'web-app'
    }

    stages {

        stage('Login to ECR') {
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                    '''
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                script {
                    sh """
                    aws ecs update-service \
                        --cluster $ECS_CLUSTER \
                        --service $ECS_SERVICE \
                        --force-new-deployment \
                        --region $AWS_REGION \
                        --output json
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image successfully pushed to ECR.'
            cleanWs()
        }
        failure {
            echo 'Build failed.'
        }
    }
}
