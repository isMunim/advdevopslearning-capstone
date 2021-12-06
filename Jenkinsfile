pipeline {
    agent any 
    environment {
        registryCredential = 'dockerhub'
        imageName = 'ismunim/nodejs-frontend'
        dockerImage = ''
        }
    stages {
        stage('Setting Up') {
             agent {
                docker { 
                    image 'node:14-alpine'
                    args '-e HOME=/tmp -e NPM_CONFIG_PREFIX=/tmp/.npm'
                    reuseNode true
                }
            }
            steps {
                //Not needed since using gitscm
                //echo 'Retrieve source from github. run npm install and npm test'
                //git branch: 'jenkins-testing',
                //    url: 'https://github.com/isMunim/AdvDevOpsLearning-Frontend.git'
                //echo 'checking if that worked'
                //sh 'ls -a'
                //sh 'npm install'
                //sh 'npm test'
                checkout scm
                sh 'ls -a'
                sh 'npm install'
                sh 'npm test'
            }
        }
        stage('Building image') {
            steps{
                script {
                    echo 'build the image' 
                    dockerImage = docker.build imageName
                }
            }
            }
        stage('Push Image') {
            steps{
                script {
                    echo 'push the image to docker hub' 
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push("$BUILD_NUMBER")
                    }
                    
                }
            }
        }     
         stage('deploy to k8s') {
             agent {
                docker { 
                    image 'google/cloud-sdk:latest'
                    args '-e HOME=/tmp'
                    reuseNode true
                        }
                    }
            steps {
                echo 'connecting to the GKE cluster'
                sh 'gcloud container clusters get-credentials nodejs-cluster --zone us-central1-a --project helpful-passage-334302'
                // Setting namespace context. Not needed if your node app is running in default ns.
                sh 'kubectl config set-context --current --namespace=nodejs'
                echo 'set image to update the container'
                // Changing the iage the gke deployment
                sh 'kubectl set image deployment/node-frontend-deployment node-frontend=$imageName:$BUILD_NUMBER'
            }
        }     
        stage('Remove local docker image') {
            steps{
                // removing the stale images
                sh "docker rmi $imageName:latest"
                sh "docker rmi $imageName:$BUILD_NUMBER"
            }
        }
    }
}