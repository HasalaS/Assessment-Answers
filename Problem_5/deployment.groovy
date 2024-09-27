pipeline {
    agent any
    
    environment {
        KUBERNETES_CREDENTIALS = 'kubeconfig'
    }

    stages {
        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig(credentialsId: KUBERNETES_CREDENTIALS) {
                    sh """
                        kubectl apply -f deployment.yaml
                    """
                }
            }
        }
    }
}
