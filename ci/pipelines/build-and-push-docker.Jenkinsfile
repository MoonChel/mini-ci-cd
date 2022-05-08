String codeArtifactToken
String version
String shortCommit

pipeline {
    agent any
    options {
        timeout(time: 60, unit: 'MINUTES')
    }
    environment {
        GITHUB_CREDS = credentials('adverity-github-credentials')
        GITHUB_TOKEN = "${env.GITHUB_CREDS_PSW}"

        // ARTIFACTORY_CREDS_USR
        // ARTIFACTORY_CREDS_PSW
        ARTIFACTORY_CREDS = credentials('jfrog')
        REGISTRY_BACKEND = "minicicd.jfrog.io"
    }
    stages {
        stage('Get SHA and Version') {
          steps {
            script {
                version = shout('cat version')
              }
           }
        }
        stage('Publish image') {
            environment {
                TAG="${env.ENV=="prod" ? env.VERSION : 'develop' }"
                FULL_IMAGE_NAME= "${ARTIFACTORY_DOCKER_REGISTRY}/${IMAGE_NAME}/datatap:${TAG}"
            }
            stages{
                stage ('Build and push'){
                    steps {
                        script{
                            sh """
                                echo $ARTIFACTORY_CREDS_PSW | docker login -u $ARTIFACTORY_CREDS_USR --password-stdin $REGISTRY_BACKEND
                            """
                            artifactorydockerLogin()
                            buildBaseImages()
                            buildReleaseImage()
                            pushImageToArtifactory()
                        }
                    }
                }
            }
        }
    }
}


void artifactorydockerLogin() {
    sh """
        docker login -u ${ARTIFACTORY_CREDS_USR} -p ${ARTIFACTORY_CREDS_PSW} adverity.jfrog.io
    """
}
void buildBaseImages() {
    sh """
        docker pull python:3.8.13-buster
        docker pull python:3.8.13-slim-buster
        docker pull docker/dockerfile:1.3.1
        docker pull docker/dockerfile-copy:v0.1.9
        docker pull node:${NODE_VERSION}-buster-slim
        docker pull nginx:latest

        docker build \
        -t datatap-frontend:latest \
        --secret id=ADVERITY_CODEARTIFACT_AUTH_TOKEN \
        --build-arg USER_ID=1000 \
        --build-arg GROUP_ID=1000 \
        --build-arg BUILDKIT_INLINE_CACHE=1 \
        --progress=plain \
        --cache-from adverity.jfrog.io/layers/datatap/frontend:cache \
        -f docker/frontend/Dockerfile \
        .
    """
}
void buildReleaseImage() {
    sh """
        docker build \
        -t ${FULL_IMAGE_NAME} \
        -f docker/Dockerfile \
        --build-arg BUILDKIT_INLINE_CACHE=1 \
        --cache-from ${FULL_IMAGE_NAME} \
        .

        docker build \
        -t ${FULL_FRONTEND_IMAGE_NAME} \
        -f docker/nginx/Dockerfile --target nginx \
        --build-arg DATATAP_IMAGE=${FULL_IMAGE_NAME} \
        --build-arg BUILDKIT_INLINE_CACHE=1 \
        .
    """
}
void pushImageToArtifactory() {
    sh """
        docker push ${FULL_IMAGE_NAME}
        docker push ${FULL_FRONTEND_IMAGE_NAME}
    """
}

