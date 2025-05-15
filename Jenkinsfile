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

                    // Fetch main branch
                    bat "git fetch origin main"

                    // Get changed files using bat and write output to a file
                    bat "git diff --name-only ${baseBranch}...HEAD > changed_files.txt"

                    // Read file and split lines
                    def changedFilesRaw = readFile('changed_files.txt')
                    def changedFiles = changedFilesRaw.readLines()

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
                // Add dev steps here
            }
        }

        stage('Run SIT Pipeline') {
            when {
                expression { Boolean.parseBoolean(env.RUN_SIT) }
            }
            steps {
                echo "Running sit pipeline logic"
                // Add sit steps here
            }
        }

        stage('Run UAT Pipeline') {
            when {
                expression { Boolean.parseBoolean(env.RUN_UAT) }
            }
            steps {
                echo "Running uat pipeline logic"
                // Add uat steps here
            }
        }
    }
}
