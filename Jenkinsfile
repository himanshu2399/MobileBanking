pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'c73b6def-a6d6-470a-a790-99ae8825501b'
        GIT_URL = 'https://github.com/himanshu2399/MobileBanking.git'
        GIT_BRANCH = 'main'
        MONITORED_FOLDERS = [
            'dev-values/'      : 'dev-pipeline',
            'sit-values/'     : 'sit-pipeline',
        ]
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
            regexpFilterExpression: 'master\\s((.*"(dev-values/|sit-values|)[^"]+?".)|(."[^/"]+".*))'
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
                }
            }
        }

        stage('Trigger Jobs for Changed Folders') {
            steps {
                script {
                    def changedFiles = env.changed_files.tokenize(',')
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
            }
        }
    }
}
