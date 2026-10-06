pipeline {

    agent any

    options {
        timestamps()
        skipDefaultCheckout(true)
    }

    environment {
        ARTIFACT = "target/payment-2.7.jar"
        DEPLOY_USER = credentials('payment-deploy-user')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "========================================"
                echo "BUILD"
                echo "========================================"

                bat "mvn clean package -DskipTests"

                echo "Generated artifact:"
                bat "dir target\\*.jar"
            }
        }

        stage('Test') {
            steps {
                echo "========================================"
                echo "TEST"
                echo "========================================"

                bat "mvn test"
            }

            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Archive') {
            steps {
                echo "========================================"
                echo "ARCHIVE"
                echo "========================================"

                archiveArtifacts artifacts: 'target/payment-2.7.jar',
                                 fingerprint: true
            }
        }

        stage('Approval') {
            when {
                branch 'main'
            }

            steps {
                script {

                    def approval = input(
                        message: 'Deploy payment application to PRODUCTION?',
                        ok: 'Deploy',
                        submitter: 'deployment-approvers'
                    )

                    echo "Production deployment approved by: ${approval}"
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }

            steps {
                echo "========================================"
                echo "DEPLOY"
                echo "========================================"

                withCredentials([
                    usernamePassword(
                        credentialsId: 'payment-deploy-credentials',
                        usernameVariable: 'DEPLOY_USERNAME',
                        passwordVariable: 'DEPLOY_PASSWORD'
                    )
                ]) {

                    bat '''
                        echo Deploying artifact:

                        echo %ARTIFACT%

                        deploy.bat
                    '''
                }
            }
        }
    }

    post {

        always {
            echo "========================================"
            echo "PIPELINE FINISHED"
            echo "========================================"

            echo "Cleaning workspace..."

            deleteDir()
        }

        success {
            echo "========================================"
            echo "SUCCESS"
            echo "========================================"

            echo "Payment application deployed successfully."
        }

        failure {
            echo "========================================"
            echo "FAILURE"
            echo "========================================"

            echo "Build, test or deployment failed."
        }

        aborted {
            echo "========================================"
            echo "ABORTED"
            echo "========================================"

            echo "Production deployment was rejected or aborted."
        }
    }
}
