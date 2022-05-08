String branchName;

pipeline {
    agent any
    options {
        timeout(time: 60, unit: 'MINUTES')
    }
    environment {
        // GITHUB_CREDS = credentials('github-credentials')
        // GITHUB_TOKEN = "${env.GITHUB_CREDS_PSW}"

        // ARTIFACTORY_CREDS_USR
        // ARTIFACTORY_CREDS_PSW
        ARTIFACTORY_CREDS = credentials('jfrog')
        REGISTRY_BACKEND = "minicicd.jfrog.io"
    }
    stages {
        stage('build and push image') {
            environment {
                FULL_IMAGE_NAME="${REGISTRY_BACKEND}/${IMAGE_NAME}:${GIT_BRANCH}"
            }
            stages{
                stage ('Build and push'){
                    steps {
                        script{
                            sh """
                                echo "${branchName}"
                            """

                            sh """
                                echo $ARTIFACTORY_CREDS_PSW | docker login -u $ARTIFACTORY_CREDS_USR --password-stdin $REGISTRY_BACKEND
                                docker build -t ${FULL_IMAGE_NAME} .
                                docker push -t ${FULL_IMAGE_NAME}
                            """
                        }
                    }
                }
            }
        }
    }
}