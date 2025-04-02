pipeline {
    agent any

    stages {
        stage('Check for Changes') {
            steps {
                script {
                    def changedFilesDev = sh(script: 'git diff --name-only HEAD~1 HEAD -- dev-values', returnStdout: true).trim()
                    def changedFilesSit = sh(script: 'git diff --name-only HEAD~1 HEAD -- sit-values', returnStdout: true).trim()

                    env.TRIGGER_DEV = !changedFilesDev.isEmpty()
                    env.TRIGGER_SIT = !changedFilesSit.isEmpty()

                    echo "Changes in dev-values: ${env.TRIGGER_DEV}"
                    echo "Changes in sit-values: ${env.TRIGGER_SIT}"
                }
            }
        }

        stage('Trigger Dev Pipeline') {
            when {
                environment name: 'TRIGGER_DEV', value: 'true'
            }
            steps {
                echo 'Changes detected in dev-values. Triggering dev-pipeline...'
                // Replace with the actual trigger command or Jenkins job name
                build job: 'dev-pipeline'
            }
        }

        stage('Trigger Sit Pipeline') {
            when {
                environment name: 'TRIGGER_SIT', value: 'true'
            }
            steps {
                echo 'Changes detected in sit-values. Triggering sit-pipeline...'
                // Replace with the actual trigger command or Jenkins job name
                build job: 'sit-pipeline'
            }
        }
    }
}
