pipeline {
    agent any

    stages {
        stage('Check Execution') {
            steps {
                echo "Jenkinsfile is being executed!"
            }
        }

        stage('Check Folder Changes') {
            steps {
                script {
                    // Fetch changed files
                    def changedFiles = sh(script: "git diff --name-only HEAD~1 HEAD", returnStdout: true).trim().split("\n")
                    echo "Changed files: ${changedFiles}"

                    // Trigger only one pipeline (first match)
                    if (changedFiles.find { it.startsWith('sit-values/') }) {
                        echo "Triggering SIT pipeline..."
                        build job: 'sit-pipeline'
                    } else if (changedFiles.find { it.startsWith('uat-values/') }) {
                        echo "Triggering UAT pipeline..."
                        build job: 'uat-pipeline'
                    } else if (changedFiles.find { it.startsWith('dev-values/') }) {
                        echo "Triggering DEV pipeline..."
                        build job: 'dev-pipeline'
                    }
                }
            }
        }

        stage('Build') {
            steps {
                echo "Starting the build process..."
                // Add your build commands here
            }
        }
    }
}
