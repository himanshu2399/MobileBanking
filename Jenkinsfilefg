pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'c73b6def-a6d6-470a-a790-99ae8825501b'
        GIT_URL = 'https://github.com/himanshu2399/MobileBanking.git'
        GIT_BRANCH = 'main'
        TRIGGER_TOKEN = 'abc123'
        SPARSE_CHECKOUT_PATH = 'dev-values/* sit-values/*'
    }

    triggers {
        GenericTrigger(
            genericVariables: [
                [key: 'changed_files', value: '$.commits[*].modified[*]', expressionType: 'JSONPath'],
                [key: 'ref', value: '$.ref', expressionType: 'JSONPath']
            ],
            causeString: 'Triggered on $ref with changed files: $changed_files',
            token: 'abc123',
            printContributedVariables: true,
            printPostContent: true
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

        stage('Trigger Dependent Pipelines') {
            steps {
                script {
                    echo "Changed files received: ${env.changed_files}"

                    if (!env.changed_files || env.changed_files.trim() == "") {
                        echo "No changed files detected. Aborting pipeline."
                        currentBuild.result = 'ABORTED'
                        return
                    }

                    def changedFiles = env.changed_files.tokenize(',')
                    def triggeredJobs = []

                    def MONITORED_FOLDERS = [
                        'dev-values/' : 'dev-pipeline',
                        'sit-values/' : 'sit-pipeline'
                    ]

                    MONITORED_FOLDERS.each { folder, jobName ->
                        changedFiles.each { file ->
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
                    }
                }
            }
        }
    }
}
