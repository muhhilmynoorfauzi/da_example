pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    sh 'docker run --rm -v $PWD:/app -w /app cirrusci/flutter:stable flutter pub get'
                }
            }
        }

        stage('Build Flutter Web') {
            steps {
                script {
                    sh 'docker run --rm -v $PWD:/app -w /app cirrusci/flutter:stable flutter build web'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${TAG} .'
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
                    // Jalankan container baru
                    sh "docker run -d -p 8080:80 --name ${IMAGE_NAME} ${IMAGE_NAME}:${TAG}"
                }
            }
        }
    }
    environment {
        IMAGE_NAME = 'flutter-web-app'
        TAG = "${env.GIT_COMMIT}" // Menggunakan commit hash sebagai tag
    }
}