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

                    // Run only required pipelines
                    def jobsToRun = []
                    if (triggerDev) {
                        jobsToRun << 'dev-values1'
                    }
                    if (triggerSit) {
                        jobsToRun << 'sit-pipeline'
                    }
                    if (triggerUat) {
                        jobsToRun << 'uat-pipeline'
                    }

                    if (jobsToRun.size() > 0) {
                        echo "Triggering jobs: ${jobsToRun}"
                        jobsToRun.each { jobName ->
                            build job: jobName, wait: true // Ensures execution completes
                        }
                    } else {
                        echo "No relevant changes detected. Skipping job triggers."
                    }
                }
            }
        }
    }
}
