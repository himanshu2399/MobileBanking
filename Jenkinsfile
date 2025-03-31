pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'c73b6def-a6d6-470a-a790-99ae8825501b'
        GIT_URL = 'https://github.com/himanshu2399/MobileBanking.git'
        GIT_BRANCH = 'main'
        TRIGGER_TOKEN = 'abc123'
        SPARSE_CHECKOUT_PATH = 'dev-values/*'
        FOLDER_NAME = 'dev-values'
        REGEX_FILTER_EXPRESSION = "${GIT_BRANCH}\\s((.*\"(${FOLDER_NAME}/)[^\"]+?\").))"
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
            regexpFilterExpression: 'main\\s((.*"(dev-values/)[^"]+?".))'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: "*/${env.GIT_BRANCH}"]],
                    userRemoteConfigs: [[credentialsId: env.GIT_CREDENTIALS, url: env.GIT_URL]],
                    extensions: [[$class: 'SparseCheckoutPaths', sparseCheckoutPaths: [[path: env.SPARSE_CHECKOUT_PATH]]]]
                ])
            }
        }

        stage('Build') {
            steps {
                echo 'This is running the build.....'
                // Add your build steps here
                // For example, you can run a shell command or execute a build script
               
            }
        }
    }
}
