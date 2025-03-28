pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Detect Folder Changes') {
            steps {
                script {
                    // Get list of changed files
                    def changedFiles = sh(script: "git diff --name-only HEAD~1 HEAD", returnStdout: true).trim().split("\n")
                    echo "Changed Files: ${changedFiles}"

                    // Flags to control job triggers
                    def triggerDev = changedFiles.any { it.startsWith('dev-values/') }
                    def triggerSit = changedFiles.any { it.startsWith('sit-values/') }
                    def triggerUat = changedFiles.any { it.startsWith('uat-values/') }

                    // Trigger respective jobs only once
                    if (triggerDev) {
                        echo "Triggering Dev Pipeline..."
                        build job: 'dev-pipeline'
                    }
                    if (triggerSit) {
                        echo "Triggering SIT Pipeline..."
                        build job: 'sit-pipeline'
                    }
                    if (triggerUat) {
                        echo "Triggering UAT Pipeline..."
                        build job: 'uat-pipeline'
                    }

                    // If no folder change detected
                    if (!triggerDev && !triggerSit && !triggerUat) {
                        echo "No folder-specific changes detected. No pipeline triggered."
                    }
                }
            }
        }
    }
}
