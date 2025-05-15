pipeline {
    agent {
        docker {
            image 'alpine/git' // lightweight image with Git and sh
            args '-u root:root' // optional: ensures root access for file ops if needed
        }
    }

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

                    // Fetch the base branch to compare against
                    sh "git fetch origin main"

                    // List changed files between this branch and main
                    def changedFiles = sh(
                        script: "git diff --name-only ${baseBranch}...HEAD",
                        returnStdout: true
                    ).trim().split('\n')

                    echo "Changed files:\n${changedFiles.join('\n')}"

                    env.RUN_DEV = changedFiles.any { it.startsWith('dev-values/') }.toString()
                    env.RUN_SIT = changedFiles.any { it.startsWith('sit-values/') }.toString()
                    env.RUN_UAT = changedFiles.any { it.startsWith('uat-values/') }.toString()

                    echo "Run Dev: ${env.RUN_DEV}, Run SIT: ${env.RUN_SIT}, Run UAT: ${env.RUN_UAT}"
                }
            }
        }

        stage('Run Dev Pipeline') {
            when {
                expression { Boolean.parseBoolean(env.RUN_DEV) }
            }
            steps {
                echo "Running dev pipeline logic"
            }
        }

        stage('Run SIT Pipeline') {
            when {
                expression { Boolean.parseBoolean(env.RUN_SIT) }
            }
            steps {
                echo "Running sit pipeline logic"
            }
        }

        stage('Run UAT Pipeline') {
            when {
                expression { Boolean.parseBoolean(env.RUN_UAT) }
            }
            steps {
                echo "Running uat pipeline logic"
            }
        }
    }
}
