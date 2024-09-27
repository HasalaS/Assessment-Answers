To chedule Lambda function

    Go to Amazon EventBridge.
    Create a new rule:
        Name: Security-Alert
        Rule Type: Schedule
        Expression: cron(0 0 * * ? *) (Runs every day at 00:00 UTC)
    
    Target: Select the Lambda function created above.