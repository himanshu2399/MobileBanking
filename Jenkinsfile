pipeline {
    agent any

    environment {
        CHANGED_FILES = "${env.changed_files}"
    }

    stages {
        stage('Debugging') {
            steps {
                script {
                    echo "Received changed files: ${CHANGED_FILES}"
                }
            }
        }

        stage('Trigger Check') {
            steps {
                script {
                    def changedFiles = CHANGED_FILES.tokenize(",")
                    def regex = ~/^dev-values\/.+/

                    echo "Checking files against regex: ${regex}"

                    def triggerJob = changedFiles.any { it ==~ regex }

                    if (triggerJob) {
                        echo "Job triggered!"
                    } else {
                        echo "No matching files found. Job will not proceed."
                        currentBuild.result = 'NOT_BUILT'
                        error("Stopping build as no matching files were found.")
                    }
                }
            }
        }
    }
}
