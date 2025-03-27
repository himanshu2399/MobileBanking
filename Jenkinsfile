pipeline {
    agent any
    environment {
        CHANGED_FILES = sh(script: "git diff-tree --no-commit-id --name-only -r $GIT_COMMIT", returnStdout: true).trim()
    }
    stages {
        stage('Check Changes') {
            steps {
                script {
                    if (CHANGED_FILES.contains('sit-values/')) {
                        build job: 'Sit-values'
                    }
                    if (CHANGED_FILES.contains('uat-values/')) {
                        build job: 'uat-values'
                    }
                }
            }
        }
    }
}
