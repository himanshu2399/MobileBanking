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
                    // Fetch changed files and convert to a list
                    def changedFiles = sh(script: "git diff --name-only HEAD~1 HEAD", returnStdout: true).trim().split("\n")
                    echo "Changed files: ${changedFiles}"

                    // Determine which job to trigger
                    def jobToTrigger = null

                    if (changedFiles.find { it.startsWith('sit-values/') }) {
                        jobToTrigger = 'sit-pipeline'
                    } else if (changedFiles.find { it.startsWith('uat-values/') }) {
                        jobToTrigger = 'uat-pipeline'
                    } else if (changedFiles.find { it.startsWith('dev-values/') }) {
                        jobToTrigger = 'dev-pipeline'
                    }

                    // Trigger only one job
                    if (jobToTrigger) {
                        echo "Triggering job: ${jobToTrigger}"
                        build job: jobToTrigger
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
