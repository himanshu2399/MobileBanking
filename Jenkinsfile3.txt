pipeline {
    agent any
    environment {
        CHANGED_FILES = "${changed_files}"
    }
    stages {
        stage('Identify Changes') {
            steps {
                script {
                    if (env.CHANGED_FILES.findAll { it.startsWith("dev-values/") }) {
                        env.ENVIRONMENT = "dev"
                    } else if (env.CHANGED_FILES.findAll { it.startsWith("sit-values/") }) {
                        env.ENVIRONMENT = "sit"
                    } else if (env.CHANGED_FILES.findAll { it.startsWith("uat-values/") }) {
                        env.ENVIRONMENT = "uat"
                    } else {
                        echo "No relevant changes detected. Skipping build."
                        currentBuild.result = 'ABORTED'
                        return
                    }
                }
            }
        }
        stage('Deploy') {
            when {
                not { equals expected: 'ABORTED', actual: currentBuild.result }
            }
            steps {
                script {
                    echo "Deploying to ${env.ENVIRONMENT} Environment..."
                    // Add deployment logic here
                }
            }
        }
    }
}
