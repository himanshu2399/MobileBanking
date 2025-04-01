pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'c73b6def-a6d6-470a-a790-99ae8825501b' 
        GIT_URL = 'https://github.com/himanshu2399/MobileBanking.git'
        GIT_BRANCH = 'main'
        DEV_FOLDER = 'dev-values'
        SIT_FOLDER = 'sit-values'
    }

    triggers {
        GenericTrigger(
            genericVariables: [
                [key: 'changed_files', value: '$.commits[*].modified[*]', expressionType: 'JSONPath'],
                [key: 'added_files', value: '$.commits[*].added[*]', expressionType: 'JSONPath'],
                [key: 'removed_files', value: '$.commits[*].removed[*]', expressionType: 'JSONPath'],
                [key: 'ref', value: '$.ref', expressionType: 'JSONPath']
            ],
            causeString: 'Triggered on branch $ref with changes in $changed_files, $added_files, $removed_files',
            token: 'abc123',
            printContributedVariables: true,
            printPostContent: true,
            regexpFilterText: '$ref $changed_files $added_files $removed_files',
            regexpFilterExpression: "main\\s.*(dev-values|sit-values)/.*"
        )
    }

    stages {
        stage('Determine Pipeline') {
            steps {
                script {
                    def changedFiles = "${env.changed_files} ${env.added_files} ${env.removed_files}" 
                    echo "Extracted changed files: ${changedFiles}"

                    def runDevPipeline = changedFiles.contains("${DEV_FOLDER}/")
                    def runSitPipeline = changedFiles.contains("${SIT_FOLDER}/")

                    if (!runDevPipeline && !runSitPipeline) {
                        echo "No relevant changes detected. Skipping pipeline execution."
                        currentBuild.result = 'NOT_BUILT'
                        return
                    }

                    if (runDevPipeline) {
                        echo "Triggering dev-pipeline..."
                        build job: 'dev-pipeline', parameters: [string(name: 'BRANCH', value: env.GIT_BRANCH)]
                    }

                    if (runSitPipeline) {
                        echo "Triggering sit-pipeline..."
                        build job: 'sit-pipeline', parameters: [string(name: 'BRANCH', value: env.GIT_BRANCH)]
                    }
                }
            }
        }
    }
}
