pipeline {
    agent any
    triggers {
        githubPush()
    }

    environment {
        IMAGE_NAME = "saimanasg/static-site"
        TAG = "latest"
        DOCKER_CREDENTIALS_ID = "CloudJenkinsDockerHubPAT"
    }

    stages {
        stage('Check If PR Merge') {
            steps {
                script {
                    def commitMessage = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
                    def branch = env.BRANCH_NAME

                    if (branch == "main" && commitMessage.contains("Merge pull request")) {
                        echo "PR merged into main. Proceeding with the pipeline."
                    } else {
                        echo "This is not a merge commit into main. Skipping pipeline execution."
                        currentBuild.result = 'ABORTED'
                        error("Pipeline aborted: Not a merge commit into main.")
                    }
                }
            }
        }

        stage('Set up Buildx') {
            steps {
                script {
                    sh 'docker run --rm --privileged multiarch/qemu-user-static --reset -p yes'
                    sh 'docker buildx create --use --name multiarch_builder || true'
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo '${DOCKER_PASSWORD}' | docker login -u '${DOCKER_USERNAME}' --password-stdin"
                    }
                }
            }
        }

        stage('Build and Push Multi-Arch Docker Image') {
            steps {
                script {
                    sh """
                        docker buildx build --platform linux/amd64,linux/arm64,windows/amd64,linux/ppc64le \\
                        -t ${IMAGE_NAME}:${TAG} . --push
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Docker Image pushed successfully: ${IMAGE_NAME}:${TAG}"
        }
        failure {
            echo "Build failed!"
        }
    }
}
