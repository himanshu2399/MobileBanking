pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'c73b6def-a6d6-470a-a790-99ae8825501b'
        GIT_URL = 'https://github.com/himanshu2399/MobileBanking.git'
        GIT_BRANCH = 'main'
        TRIGGER_TOKEN = 'abc123'
        FOLDERS_TO_MONITOR = ['dev-values/', 'sit-values/'] // Define folders for separate jobs
        REGEX_FILTER_EXPRESSION = "${GIT_BRANCH}\\s((.*\"(dev-values/|sit-values/)[^\"]+?\").))"
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
            regexpFilterExpression: 'main\\s((.*"(dev-values/|sit-values/)[^"]+?".))'
        )
    }

    stages {
        stage('Detect Changes') {
            steps {
                script {
                    def changedFiles = env.changed_files.tokenize(',') // Convert string to list
                    def triggeredJobs = []

                    FOLDERS_TO_MONITOR.each { folder ->
                        if (changedFiles.find { it.startsWith(folder + '/') }) {
                            if (folder == 'dev-values/') {
                                triggeredJobs << 'dev-pipeline'
                            } else if (folder == 'sit-values/') {
                                triggeredJobs << 'sit-pipeline'
                            }
                        }
                    }

                    if (triggeredJobs) {
                        triggeredJobs.each { job ->
                            build job: job, wait: false
                        }
                    }
                }
            }
        }

        stage('Checkout') {
            steps {
                script {
                    def sparsePaths = FOLDERS_TO_MONITOR.collect { [path: it + "/*"] }
                    checkout([$class: 'GitSCM',
                        branches: [[name: "*/${env.GIT_BRANCH}"]],
                        userRemoteConfigs: [[credentialsId: env.GIT_CREDENTIALS, url: env.GIT_URL]],
                        extensions: [[$class: 'SparseCheckoutPaths', sparseCheckoutPaths: sparsePaths]]
                    ])
                }
            }
        }

        stage('Build') {
            steps {
                echo "Building changes for ${FOLDERS_TO_MONITOR.join(', ')}"
            }
        }
    }
}
