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
                echo "========================================"
                echo "CHECKOUT"
                echo "========================================"

                checkout scm

                bat '''
                    echo Repository files:
                    dir
                '''
            }
        }

        stage('Build') {
            steps {
                echo "========================================"
                echo "BUILD"
                echo "========================================"

                bat 'mvn clean package -DskipTests'

                echo "Generated JAR:"
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

                bat '''
                    echo Deploying exact artifact:
                    echo %WORKSPACE%\\target\\payment-2.7.jar

                    if not exist "target\\payment-2.7.jar" (
                        echo ERROR: JAR file not found!
                        exit /b 1
                    )

                    call deploy.bat
                '''
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

        cleanup {
            echo "========================================"
            echo "CLEANUP"
            echo "========================================"

            bat '''
                echo Cleaning workspace...
                if exist target rmdir /S /Q target
            '''
        }
    }
}

