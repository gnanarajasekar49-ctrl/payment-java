pipeline {
    agent any

    options {
        timestamps()
        skipDefaultCheckout(true)
    }

    stages {

        stage('Checkout') {
            steps {
                echo "========================================"
                echo "CHECKOUT"
                echo "========================================"

                checkout scm

                bat 'dir'
            }
        }

        stage('Build') {
            steps {
                echo "========================================"
                echo "BUILD"
                echo "========================================"

                bat 'mvn clean package -DskipTests'

                bat 'dir target\\*.jar'
            }
        }

        stage('Test') {
            steps {
                echo "========================================"
                echo "TEST"
                echo "========================================"

                bat 'mvn test'
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
                input(
                    message: 'Deploy payment application to PRODUCTION?',
                    ok: 'Deploy'
                )
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

                bat 'call deploy.bat'
            }
        }
    }

    post {

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

