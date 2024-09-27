pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = 'aws-account-id.dkr.ecr.your-region.amazonaws.com/web-app'
        ECS_CLUSTER = 'web-ecs-cluster'
        ECS_SERVICE = 'web-app'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/HasalaS/designsfrontier-asses.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $ECR_REPO:$IMAGE_TAG .'
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                    '''
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh 'docker push $ECR_REPO:$IMAGE_TAG'
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image successfully pushed to ECR.'
        }
        failure {
            echo 'Build failed.'
        }
    }
}
