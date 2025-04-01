pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'c73b6def-a6d6-470a-a790-99ae8825501b'
        GIT_URL = 'https://github.com/himanshu2399/MobileBanking.git'
        GIT_BRANCH = 'main'
        TRIGGER_TOKEN = 'abc123'
        DEV_FOLDER = 'dev-values'
        SIT_FOLDER = 'sit-values'
    }

    triggers {
        GenericTrigger(
            genericVariables: [
                [key: 'changed_files', value: '$.commits[*].["modified","added","removed"][*]', expressionType: 'JSONPath'],
                [key: 'ref', value: '$.ref', expressionType: 'JSONPath']
            ],
            causeString: 'Triggered on $ref $changed_files',
            token: 'abc123',
            printContributedVariables: true,
            printPostContent: true,
            regexpFilterText: '$ref $changed_files',
            regexpFilterExpression: "${GIT_BRANCH}\\s((.*\"(${DEV_FOLDER}|${SIT_FOLDER})/)[^\"]+?\".))"
        )
    }

    stages {
        stage('Determine Pipeline') {
            steps {
                script {
                    def changedFiles = env.changed_files
                    def runDevPipeline = changedFiles.contains("${DEV_FOLDER}/")
                    def runSitPipeline = changedFiles.contains("${SIT_FOLDER}/")

                    if (!runDevPipeline && !runSitPipeline) {
                        echo "No relevant changes detected. Skipping pipeline execution."
                        currentBuild.result = 'NOT_BUILT'
                        return
                    }

                    if (runDevPipeline) {
                        build job: 'dev-pipeline', parameters: [string(name: 'BRANCH', value: env.GIT_BRANCH)]
                    }

                    if (runSitPipeline) {
                        build job: 'sit-pipeline', parameters: [string(name: 'BRANCH', value: env.GIT_BRANCH)]
                    }
                }
            }
        }
    }
}
