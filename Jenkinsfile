pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'c73b6def-a6d6-470a-a790-99ae8825501b'
        GIT_URL = 'https://github.com/himanshu2399/MobileBanking.git'
        GIT_BRANCH = 'main'
        DEV_PIPELINE = 'dev-pipeline'
        SIT_PIPELINE = 'sit-pipeline'
        FOLDERS_TO_MONITOR = ['dev-folder', 'sit-folder']
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
            regexpFilterExpression: 'your-git-branch-name\\s((.*"(dev-folder/|sit-folder/)[^"]+?".))'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM',
                        branches: [[name: "*/${env.GIT_BRANCH}"]],
                        userRemoteConfigs: [[credentialsId: env.GIT_CREDENTIALS, url: env.GIT_URL]],
                        extensions: []
                    ])
                }
            }
        }

        stage('Detect Changes') {
            steps {
                script {
                    def changedFiles = env.changed_files.tokenize(',')
                    def triggeredJobs = []

                    if (changedFiles.find { it.startsWith('dev-folder/') }) {
                        triggeredJobs << env.DEV_PIPELINE
                    }
                    if (changedFiles.find { it.startsWith('sit-folder/') }) {
                        triggeredJobs << env.SIT_PIPELINE
                    }

                    if (triggeredJobs.isEmpty()) {
                        echo "No relevant folder changes detected. Skipping pipeline execution."
                        currentBuild.result = 'ABORTED'
                        return
                    }

                    echo "Triggering jobs: ${triggeredJobs}"
                    env.TRIGGERED_JOBS = triggeredJobs.join(',')
                }
            }
        }

        stage('Trigger Jobs') {
            when {
                expression { return env.TRIGGERED_JOBS != null && env.TRIGGERED_JOBS != '' }
            }
            parallel {
                stage('Trigger Dev Pipeline') {
                    when {
                        expression { return env.TRIGGERED_JOBS.contains(env.DEV_PIPELINE) }
                    }
                    steps {
                        script {
                            echo "Triggering ${env.DEV_PIPELINE}..."
                            build job: env.DEV_PIPELINE, wait: false
                        }
                    }
                }

                stage('Trigger SIT Pipeline') {
                    when {
                        expression { return env.TRIGGERED_JOBS.contains(env.SIT_PIPELINE) }
                    }
                    steps {
                        script {
                            echo "Triggering ${env.SIT_PIPELINE}..."
                            build job: env.SIT_PIPELINE, wait: false
                        }
                    }
                }
            }
        }
    }
}
