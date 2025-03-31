pipeline {
    agent any

    environment {
        GIT_URL = 'https://github.com/himanshu2399/MobileBanking.git'
        GIT_BRANCH = 'main'
        TRIGGER_TOKEN = 'abc123'
        GIT_CREDENTIALS = 'c73b6def-a6d6-470a-a790-99ae8825501b'
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
            regexpFilterExpression: 'main\\s((.*"(dev-values/|qa-values/)[^"]+?".))'
        )
    }

    stages {
        stage('Detect Changes') {
            steps {
                script {
                    // Extract changed files from webhook
                    def changes = env.changed_files.tokenize(',')
                    def affectedFolders = []

                    // Check if any files are changed in dev-values or qa-values
                    if (changes.find { it.startsWith('dev-values/') }) {
                        affectedFolders.add('dev-values/')
                    }
                    if (changes.find { it.startsWith('qa-values/') }) {
                        affectedFolders.add('sit-values/')
                    }

                    // Store affected folders in an environment variable
                    env.AFFECTED_FOLDERS = affectedFolders.join(',')
                }
            }
        }

        stage('Run Pipelines in Parallel') {
            when {
                expression { env.AFFECTED_FOLDERS != '' }
            }
            steps {
                script {
                    def tasks = [:]
                    def folders = env.AFFECTED_FOLDERS.tokenize(',')

                    for (folder in folders) {
                        tasks[folder] = {
                            stage("Processing ${folder}") {
                                checkout([$class: 'GitSCM',
                                    branches: [[name: "*/${env.GIT_BRANCH}"]],
                                    userRemoteConfigs: [[credentialsId: env.GIT_CREDENTIALS, url: env.GIT_URL]],
                                    extensions: [[$class: 'SparseCheckoutPaths', sparseCheckoutPaths: [[path: "${folder}*"]]]]
                                ])

                                echo "Building for folder: ${folder}"
                            }
                        }
                    }

                    parallel tasks
                }
            }
        }
    }
}
