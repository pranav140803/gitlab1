pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-north-1'  // Change to your preferred AWS region
        INSTANCE_TYPE = 't2.micro'
        AMI_ID = 'ami-0e35ddab05955cf57'  // Change to a valid Ubuntu AMI ID for your region
        KEY_NAME = 'ec2-mini'  // Replace with your AWS key pair name
        SECURITY_GROUP = 'sg-08e314109a71f8066'  // Replace with your security group ID
        SUBNET_ID = 'subnet-0a0396533673372e1'  // Replace with your subnet ID
        GITHUB_REPO = 'https://github.com/pranav140803/gitlab1.git'
    }

    stages {
        stage('Create EC2 Instance') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                        echo "Launching EC2 instance..."
                        def instanceId = sh(script: """
                            aws ec2 run-instances --image-id ${AMI_ID} --count 1 --instance-type ${INSTANCE_TYPE} \
                            --key-name ${KEY_NAME} --security-group-ids ${SECURITY_GROUP} --subnet-id ${SUBNET_ID} \
                            --query 'Instances[0].InstanceId' --output text
                        """, returnStdout: true).trim()

                        env.INSTANCE_ID = instanceId
                        echo "EC2 Instance ID: ${env.INSTANCE_ID}"

                        sleep(30)  // Wait for instance initialization

                        def publicIp = sh(script: """
                            aws ec2 describe-instances --instance-ids ${env.INSTANCE_ID} \
                            --query 'Reservations[0].Instances[0].PublicIpAddress' --output text
                        """, returnStdout: true).trim()

                        env.INSTANCE_IP = publicIp
                        echo "EC2 Public IP: ${env.INSTANCE_IP}"
                    }
                }
            }
        }

        stage('Install Docker on EC2') {
            steps {
                script {
                 withCredentials([sshUserPrivateKey(credentialsId: 'aws-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                      echo "Installing Docker Engine..."
                      sh """
                          ssh -o StrictHostKeyChecking=no -i $SSH_KEY ubuntu@${env.INSTANCE_IP} \
                          "sudo apt update && \
                          sudo apt install -y docker.io && \
                          sudo systemctl start docker && \
                          sudo systemctl enable docker"
                        """
             }
        }
    }
}


        stage('Clone Project from GitHub') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'aws-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                        echo "Cloning GitHub repo..."
                        sh """
                            ssh -i $SSH_KEY ubuntu@${env.INSTANCE_IP} \
                                "git clone ${GITHUB_REPO} website"
                        
                        """
                    }
                }
            }
        }

        stage('Build Docker Image and Run on Nginx server') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'aws-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                        echo "Building Docker image..."
                        sh """
                            ssh -i $SSH_KEY ubuntu@${env.INSTANCE_IP} \
                                "cd website
                                sudo docker build . -t my-nginx-site
                                sudo docker run -d -p 80:80 --name nginx-server my-nginx-site "
                        """
                    }
                }
            }
        }
    }
    post {
        success {
            echo "✅ Website deployed successfully at http://${env.INSTANCE_IP}"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
