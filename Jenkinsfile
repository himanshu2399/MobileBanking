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
                    // Fetch changed files as a list
                    def changedFiles = sh(script: "git diff --name-only HEAD~1 HEAD", returnStdout: true).trim().split("\n")
                    echo "Changed files: ${changedFiles}"

                    // Use a Set to ensure a job triggers only once
                    def jobsToTrigger = [] as Set

                    // Check changes and add jobs to the Set (avoids duplicate triggers)
                    if (changedFiles.find { it.startsWith('sit-values/') }) {
                        jobsToTrigger.add('sit-pipeline')
                    }
                    if (changedFiles.find { it.startsWith('uat-values/') }) {
                        jobsToTrigger.add('uat-pipeline')
                    }
                    if (changedFiles.find { it.startsWith('dev-values/') }) {
                        jobsToTrigger.add('dev-pipeline')
                    }

                    // Trigger each job only once
                    jobsToTrigger.each { job ->
                        echo "Triggering job: ${job}"
                        build job: job
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
