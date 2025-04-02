pipeline {
    agent any

    environment {
        CHANGED_FILES = "${env.changed_files}"
    }

    stages {
        stage('Trigger Check') {
            steps {
                script {
                    def changedFiles = CHANGED_FILES.tokenize(",")
                    def regex = ~/dev-values\/.+/

                    def triggerJob = changedFiles.any { it ==~ regex }

                    if (triggerJob) {
                        echo "Job triggered as matching files were found!"
                    } else {
                        echo "No matching files found. Job will not proceed."
                        currentBuild.result = 'NOT_BUILT'
                        error("Stopping build as no matching files were found.")
                    }
                }
            }
        }

        stage('Build and Deploy') {
            when {
                expression { currentBuild.result != 'NOT_BUILT' }
            }
            steps {
                echo "Proceeding with the pipeline execution..."
                // Add your build or deployment steps here
            }
        }
    }
}
