pipeline {
    agent any

    stages {
        // stage('Clone Repository') {
        //     steps {
        //         git 'https://github.com/your-repo/flutter-web-app.git'
        //     }
        // }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("flutter-web-app")
                }
            }
        }

        // stage('Run Docker Compose') {
        //     steps {
        //         script {
        //             dockerCompose = dockerComposeFile('docker-compose.yml')
        //             dockerCompose.up()
        //         }
        //     }
        // }

        // stage('Clean Up') {
        //     steps {
        //         script {
        //             dockerCompose.down()
        //         }
        //     }
        // }
    }
}
