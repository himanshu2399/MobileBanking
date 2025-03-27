pipeline {
    agent any
    parameters {
        string(name: 'changed_files', defaultValue: '', description: 'Files modified in the last commit')
    }
    stages {
        stage('Check Modified Files') {
            steps {
                script {
                    def changedFiles = params.changed_files.tokenize("\n")

                    if (changedFiles.any { it.startsWith("service-a/") }) {
                        echo "Changes detected in service-a, triggering ServiceA-Build..."
                        build job: 'ServiceA-Build'
                    }

                    if (changedFiles.any { it.startsWith("service-b/") }) {
                        echo "Changes detected in service-b, triggering ServiceB-Build..."
                        build job: 'ServiceB-Build'
                    }
                }
            }
        }
    }
}
