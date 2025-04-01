pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'your-credentials-id'
        GIT_URL = 'your-gitlab-repo-url'
        GIT_BRANCH = 'your-branch-name'
        TRIGGER_TOKEN = 'abc123'
        FOLDERS = 'dev-values sit-values'  // Space-separated list of folders
    }

    triggers {
        GenericTrigger(
            genericVariables: [
                [key: 'changed_files', value: '$.commits[*].["modified","added","removed"][*]', expressionType: 'JSONPath'],
                [key: 'ref', value: '$.ref', expressionType: 'JSONPath', regexpFilter: '^(refs/heads/|refs/remotes/origin/)']
            ],
            causeString: 'Triggered on $ref $changed_files',
            token: 'abc123',
            printContributedVariables: true,
            printPostContent: true,
            regexpFilterText: '$ref $changed_files',
            regexpFilterExpression: "${GIT_BRANCH}\\s((.*\"(${FOLDERS.replaceAll(' ', '|')}/)[^\"]+?\").))"
        )
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
