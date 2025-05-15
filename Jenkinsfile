pipeline {
    agent any

    environment {
        BRANCH_NAME = "${env.GIT_BRANCH ?: env.BRANCH_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Detect Changes') {
            steps {
                script {
                    def changedFiles = sh(script: "git diff --name-only origin/${env.BRANCH_NAME}~1 origin/${env.BRANCH_NAME}", returnStdout: true).trim().split('\n')

                    env.RUN_DEV = changedFiles.any { it.startsWith('dev-values/') }.toString()
                    env.RUN_SIT = changedFiles.any { it.startsWith('sit-values/') }.toString()
                    env.RUN_UAT = changedFiles.any { it.startsWith('uat-values/') }.toString()
                }
            }
        }

        stage('Run Dev Pipeline') {
            when {
                expression { env.RUN_DEV == 'true' }
            }
            steps {
                echo "Running dev pipeline logic"
                // Your dev deployment logic here
            }
        }

        stage('Run SIT Pipeline') {
            when {
                expression { env.RUN_SIT == 'true' }
            }
            steps {
                echo "Running sit pipeline logic"
                // Your sit deployment logic here
            }
        }

        stage('Run UAT Pipeline') {
            when {
                expression { env.RUN_UAT == 'true' }
            }
            steps {
                echo "Running uat pipeline logic"
                // Your uat deployment logic here
            }
        }
    }
}
