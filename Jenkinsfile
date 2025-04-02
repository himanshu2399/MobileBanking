pipeline {
    agent any
    stages {
        stage('Check Changes') {
            steps {
                script {
                    // Check for changes in dev-values folder
                    def devChanges = sh(
                        script: "git diff --name-only HEAD~1 HEAD | grep '^dev-values/' || true",
                        returnStatus: true
                    ) == 0
                    
                    // Check for changes in sit-values folder
                    def sitChanges = sh(
                        script: "git diff --name-only HEAD~1 HEAD | grep '^sit-values/' || true",
                        returnStatus: true
                    ) == 0

                    // Trigger dev-pipeline if dev-values folder has changes
                    if (devChanges) {
                        echo "Changes detected in dev-values folder. Triggering dev-pipeline..."
                        build job: 'dev-pipeline'
                    }

                    // Trigger sit-pipeline if sit-values folder has changes
                    if (sitChanges) {
                        echo "Changes detected in sit-values folder. Triggering sit-pipeline..."
                        build job: 'sit-pipeline'
                    }

                    // No relevant changes detected
                    if (!devChanges && !sitChanges) {
                        echo "No relevant changes detected. No pipelines triggered."
                    }
                }
            }
        }
    }
}
