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
                [key: 'changed_files', value: '$.commits[*].modified[*]', expressionType: 'JSONPath', defaultValue: '[]'],
                [key: 'added_files', value: '$.commits[*].added[*]', expressionType: 'JSONPath', defaultValue: '[]'],
                [key: 'removed_files', value: '$.commits[*].removed[*]', expressionType: 'JSONPath', defaultValue: '[]'],
                [key: 'ref', value: '$.ref', expressionType: 'JSONPath']
            ],
            causeString: 'Triggered on branch $ref with changes in $changed_files, $added_files, $removed_files',
            token: 'abc123',
            printContributedVariables: true,
            printPostContent: true,
            regexpFilterText: '$ref $changed_files $added_files $removed_files',
            regexpFilterExpression: "refs/heads/main\\s.*(dev-values|sit-values)/.*"
        )
    }

    stages {
        stage('Determine Pipeline') {
            steps {
                script {
                    // Debugging information
                    echo "Branch: ${env.ref}"
                    echo "Modified Files: ${env.changed_files}"
                    echo "Added Files: ${env.added_files}"
                    echo "Removed Files: ${env.removed_files}"

                    // Parse JSON strings into Groovy lists
                    def modifiedFiles = env.changed_files && env.changed_files != '[]' ? readJSON(text: env.changed_files) : []
                    def addedFiles = env.added_files && env.added_files != '[]' ? readJSON(text: env.added_files) : []
                    def removedFiles = env.removed_files && env.removed_files != '[]' ? readJSON(text: env.removed_files) : []

                    // Combine all changed files into a list
                    def allChangedFiles = modifiedFiles + addedFiles + removedFiles
                    echo "All Changed Files: ${allChangedFiles}"

                    // Check if any files in dev-values or sit-values changed
                    def runDevPipeline = allChangedFiles.any { it.startsWith("${DEV_FOLDER}/") }
                    def runSitPipeline = allChangedFiles.any { it.startsWith("${SIT_FOLDER}/") }

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
