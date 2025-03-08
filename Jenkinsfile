pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-nginx-image"
        AWS_SERVER_IP = "<your-ec2-ip>"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/yourusername/yourrepo.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    sh 'docker login -u yourdockerhubusername -p yourpassword'
                    sh 'docker push yourdockerhubusername/$DOCKER_IMAGE'
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                script {
                    sh "docker run -d -p 80:80 --name my-nginx-container $DOCKER_IMAGE"
                }
            }
        }
    }
}
