pipeline {
    agent any
    stages {
        stage('Check Changes') {
            steps {
                script {
                    def devChanges = false
                    def sitChanges = false
                    
                    // Check for changes in dev-values folder
                    devChanges = sh(
                        script: "git diff --name-only HEAD~1 HEAD | grep '^dev-values/' || true",
                        returnStatus: true
                    ) == 0
                    
                    // Check for changes in sit-values folder
                    sitChanges = sh(
                        script: "git diff --name-only HEAD~1 HEAD | grep '^sit-values/' || true",
                        returnStatus: true
                    ) == 0

                    // Trigger dev-pipeline if dev-values folder has changes
                    if (devChanges) {
                        build job: 'dev-pipeline'
                    }

                    // Trigger sit-pipeline if sit-values folder has changes
                    if (sitChanges) {
                        build job: 'sit-pipeline'
                    }

                    // No changes detected
                    if (!devChanges && !sitChanges) {
                        echo "No relevant changes detected. No pipelines triggered."
                    }
                }
            }
        }
    }
}
