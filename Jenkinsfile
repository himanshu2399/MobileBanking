pipeline {
    agent any

    environment {
        RUN_DEV = 'false'
        RUN_SIT = 'false'
        RUN_UAT = 'false'
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
                    def baseBranch = "origin/main"
                    bat "git fetch origin main"
                    def changedFiles = bat(
                        script: "git diff --name-only ${baseBranch}...HEAD > changed_files.txt",
                        returnStatus: true
                    )

                    def content = readFile('changed_files.txt').trim().split("\n")
                    echo "Changed files:\n${content.join('\n')}"

                    env.RUN_DEV = content.any { it.startsWith('dev-values/') }.toString()
                    env.RUN_SIT = content.any { it.startsWith('sit-values/') }.toString()
                    env.RUN_UAT = content.any { it.startsWith('uat-values/') }.toString()
                }
            }
        }

        stage('Run Dev Pipeline') {
            when {
                expression { env.RUN_DEV == 'true' }
            }
            steps {
                echo "Running Dev pipeline logic"
                bat 'echo Deploying dev...'
                // bat 'kubectl apply -f dev-values/'
            }
        }

        stage('Run SIT Pipeline') {
            when {
                expression { env.RUN_SIT == 'true' }
            }
            steps {
                echo "Running SIT pipeline logic"
                bat 'echo Deploying SIT...'
            }
        }

        stage('Run UAT Pipeline') {
            when {
                expression { env.RUN_UAT == 'true' }
            }
            steps {
                echo "Running UAT pipeline logic"
                bat 'echo Deploying UAT...'
            }
        }
    }
}
