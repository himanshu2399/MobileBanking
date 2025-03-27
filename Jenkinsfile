pipeline {
    agent any
    environment {
        BRANCH = "${params.ref}".substring("${params.ref}".lastIndexOf("/") + 1)
        FOLDER = "${params.path}".substring(0, "${params.path}".indexOf('/'))
        CHANGED_FILES = sh(script: "git diff-tree --no-commit-id --name-only -r $GIT_COMMIT", returnStdout: true).trim()

    }
    stages {
        stage('Build') {
            steps {
                echo "Building on the branch {$BRANCH}"
                echo "Building on the Folder {$FOLDER}"
                echo "Building on the Changed files {$CHANGED_FILES}"

            }
        }
    }
}
