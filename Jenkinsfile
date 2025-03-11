pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-nginx-image"
        AWS_SERVER_IP = "16.171.152.4"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/pranav140803/gitlab1'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t pranavsal/k8-eks-workernode:eks
 .'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    sh 'docker login -u pranav -p pranav'
                    sh 'docker push pranav/pranavsal/k8-eks-workernode:eks
'
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
