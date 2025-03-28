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
                    def changeFiles = sh(script: "git diff --name-only HEAD~1 HEAD", returnStdout: true).trim()
                    echo "Changed files: ${changeFiles}"  
                    
                    if (changedFiles.any { it.startsWith('sit-values/') }) {
                        build job: 'sit-pipeline'
                    } else if (changedFiles.any { it.startsWith('uat-values/') }) {
                        build job: 'uat-pipeline'
                    } else if (changedFiles.any { it.startsWith('dev-values/') }) {
                        build job: 'dev-values1'
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
    


    

   
