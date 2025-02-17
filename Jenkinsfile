pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }
    stages {
        stage('Checkout SCM') {
            steps {
                echo 'Checking out SCM...'
                checkout scm
            }
        }
        stage('TF Init') {
            steps {
                echo 'Executing Terraform Init'
                sh 'terraform init'
            }
        }
        stage('TF Validate') {
            steps {
                echo 'Validating Terraform Code'
                sh 'terraform validate'
            }
        }
        stage('TF Plan') {
            steps {
                echo 'Executing Terraform Plan'
                sh 'terraform plan -out=tfplan'
            }
        }
        stage('TF Apply') {
            steps {
                echo 'Executing Terraform Apply'
                sh 'terraform apply tfplan'
            }
        }
        stage('Invoke Lambda') {
            steps {
                echo 'Invoking your AWS Lambda'
                script {
                    def result = sh(script: 'aws lambda invoke --function-name my_lambda_function --log-type Tail output.json', returnStdout: true).trim()
                    def decodedLog = sh(script: "echo ${result} | jq -r '.LogResult' | base64 --decode", returnStdout: true).trim()
                    echo "Lambda invocation result: ${decodedLog}"
                }
            }
        }
    }
    post {
        failure {
            mail to: 'your-email@example.com',
                 subject: "Pipeline failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                 body: "Something is wrong with ${env.JOB_NAME} - ${env.BUILD_NUMBER}. Please check the logs."
        }
    }
}
