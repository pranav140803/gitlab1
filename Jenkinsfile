pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "pranavsal/k8-eks-workernode:eks"
        AWS_SERVER_IP = "13.60.198.3"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/pranav140803/gitlab1'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t DOCKER$'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    sh 'docker login -u pranav -p pranav'
                    sh 'docker push pranavsal/k8-eks-workernode'
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
