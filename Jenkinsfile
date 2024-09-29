pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    docker.image('cirrusci/flutter:latest').inside {
                        sh 'flutter pub get'
                    }
                }
            }
        }

        stage('Build Flutter Web') {
            steps {
                script {
                    docker.image('cirrusci/flutter:latest').inside {
                        sh 'flutter build web'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'pwd'
                sh "docker build -t ${IMAGE_NAME}:${TAG} ."
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh """
                    if [ \$(docker ps -q -f name=${IMAGE_NAME}) ]; then
                        docker stop ${IMAGE_NAME}
                        docker rm ${IMAGE_NAME}
                    fi
                    """
                    // Run the new container
                    sh "docker run -d -p 3000:3000 --name ${IMAGE_NAME} ${IMAGE_NAME}:${TAG}"
                }
            }
        }
    }
    environment {
        IMAGE_NAME = 'flutter-web-app'
        TAG = "${env.GIT_COMMIT}" // Menggunakan commit hash sebagai tag
    }
}
