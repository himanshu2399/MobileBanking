pipeline {
    agent any
    stages {
        stage('Check Changes') {
            steps {
                script {
                    def devChanges = sh(
                        script: "git diff --name-only HEAD~1 HEAD | grep '^dev-values/' || true",
                        returnStatus: true
                    ) == 0
                    
                    def sitChanges = sh(
                        script: "git diff --name-only HEAD~1 HEAD | grep '^sit-values/' || true",
                        returnStatus: true
                    ) == 0

                    if (devChanges) {
                        build job: 'dev-pipeline'
                    }
                    
                    if (sitChanges) {
                        build job: 'sit-pipeline'
                    }

                    if (!devChanges && !sitChanges) {
                        echo "No relevant changes detected."
                    }
                }
            }
        }
    }
}
