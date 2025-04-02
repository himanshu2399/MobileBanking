pipeline {
    agent any

    triggers {
        github(secretId: 'c73b6def-a6d6-470a-a790-99ae8825501b',
               branchFilter: 'main', // Adjust your branch filter as needed
               fileFilter: 'dev-values/(.*)|sit-values/(.*)')
    }

    stages {
        stage('Determine Triggered Pipeline') {
            when {
                anyOf {
                    triggered 'github', filePattern: 'dev-values/(.*)'
                    triggered 'github', filePattern: 'sit-values/(.*)'
                }
            }
            steps {
                script {
                    if (currentBuild.rawBuild.getCauses().any { it instanceof hudson.triggers.SCMTrigger.SCMTriggerCause && it.getChangeLog().getAffectedFiles().any { it.getPath().startsWith('dev-values/') } }) {
                        env.TRIGGERED_FOLDER = 'dev-values'
                        echo "Changes detected in dev-values."
                    } else if (currentBuild.rawBuild.getCauses().any { it instanceof hudson.triggers.SCMTrigger.SCMTriggerCause && it.getChangeLog().getAffectedFiles().any { it.getPath().startsWith('sit-values/') } }) {
                        env.TRIGGERED_FOLDER = 'sit-values'
                        echo "Changes detected in sit-values."
                    } else {
                        echo "No relevant changes detected."
                        // Optionally, you could abort the build here if no relevant changes are found
                        // error("No relevant changes detected.")
                    }
                }
            }
        }

        stage('Trigger Dev Pipeline') {
            when {
                environment name: 'TRIGGERED_FOLDER', value: 'dev-values'
            }
            steps {
                echo 'Triggering dev-pipeline...'
                build job: 'dev-pipeline'
            }
        }

        stage('Trigger Sit Pipeline') {
            when {
                environment name: 'TRIGGERED_FOLDER', value: 'sit-values'
            }
            steps {
                echo 'Triggering sit-pipeline...'
                build job: 'sit-pipeline'
            }
        }
    }
}
