pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'sit'], description: 'Choose the environment')
    }

    environment {
        GIT_URL = 'https://github.com/himanshu2399/MobileBanking.git'
        GIT_BRANCH = 'main'
        TRIGGER_TOKEN = 'abc123'
        
        // Set folder paths dynamically based on environment selection
        SPARSE_CHECKOUT_PATH = "${params.ENVIRONMENT}-values/*"
        FOLDER_NAME = "${params.ENVIRONMENT}-values/"

        // Regex to trigger based on folder changes
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
            regexpFilterExpression: 'main\\s((.*"(${FOLDER_NAME})[^"]+?".))'
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
                echo "Running build for ${params.ENVIRONMENT} environment..."
            }
        }
    }
}
