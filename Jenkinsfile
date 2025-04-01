pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'c73b6def-a6d6-470a-a790-99ae8825501b'
        GIT_URL = 'https://github.com/himanshu2399/MobileBanking.git'
        GIT_BRANCH = 'main'
        TRIGGER_TOKEN = 'abc123'
        FOLDERS = 'dev-values sit-values'  // Space-separated list of folders
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    def folderList = env.FOLDERS.split(' ')
                    folderList.each { folder ->
                        checkout([$class: 'GitSCM',
                            branches: [[name: "*/${env.GIT_BRANCH}"]],
                            userRemoteConfigs: [[credentialsId: env.GIT_CREDENTIALS, url: env.GIT_URL]],
                            extensions: [[$class: 'SparseCheckoutPaths', sparseCheckoutPaths: [[path: "${folder}/*"]]]]
                        ])
                    }
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    def folderList = env.FOLDERS.split(' ')
                    folderList.each { folder ->
                        echo "Building for folder: ${folder}"
                        // Add build steps specific to each folder here
                    }
                }
            }
        }
    }
}
