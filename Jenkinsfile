pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'c73b6def-a6d6-470a-a790-99ae8825501b'
        GIT_URL = 'https://github.com/himanshu2399/MobileBanking.git'
        GIT_BRANCH = 'main'
        TRIGGER_TOKEN = 'abc123'
        SPARSE_CHECKOUT_PATH = 'dev-values/*'
        FOLDER_NAME = 'dev-values/'
        REGEX_FILTER_EXPRESSION = "${GIT_BRANCH}\\s((.*\"(${FOLDER_NAME}/)[^\"]+?\").))"
    }

    triggers {
        GenericTrigger(
            genericVariables: [
                [key: 'changed_files', value: '$.commits[*].["modified","added","removed"][*]', expressionType: 'JSONPath'],
                [key: 'ref', value: '$.ref', expressionType: 'JSONPath']
            ],
            causeString: 'Triggered on branch: $ref with changes: $changed_files',
            token: 'abc123',
            printContributedVariables: true,
            printPostContent: true,
            regexpFilterText: '$ref $changed_files',
            regexpFilterExpression: 'main\\s((.*"(dev-values/|sit-values|)[^"]+?".)|(."[^/"]+".*))'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM',
                        branches: [[name: "*/${env.GIT_BRANCH}"]],
                        userRemoteConfigs: [[credentialsId: env.GIT_CREDENTIALS, url: env.GIT_URL]]
                    ])
                    sh 'printenv'
                }
                checkout([$class: 'GitSCM',
                    branches: [[name: "*/${env.GIT_BRANCH}"]],
                    userRemoteConfigs: [[credentialsId: env.GIT_CREDENTIALS, url: env.GIT_URL]],
                    extensions: [[$class: 'SparseCheckoutPaths', sparseCheckoutPaths: [[path: env.SPARSE_CHECKOUT_PATH]]]]
                ])
            }
        }

        stage('Build') {
            steps {
                script {
                    def MONITORED_FOLDERS = [
                        'dev-values/*' : 'dev-pipeline',
                        'sit-values/*' : 'sit-pipeline'
                    ]

                    def changedFiles = env.changed_files ? env.changed_files.tokenize(',') : []
                    def triggeredJobs = []

                    for (file in changedFiles) {
                        MONITORED_FOLDERS.each { folder, jobName ->
                            if (file.startsWith(folder) && !triggeredJobs.contains(jobName)) {
                                echo "Triggering pipeline for folder: ${folder} -> Job: ${jobName}"
                                build job: jobName, wait: false
                                triggeredJobs.add(jobName)
                            }
                        }
                    }

                    if (triggeredJobs.isEmpty()) {
                        echo "No monitored folder changes detected. Aborting pipeline."
                        currentBuild.result = 'ABORTED'
                        return
                    }
                }
                echo 'Build is running...'
            }
        }
    }
}
