pipeline {
    agent any
    tools {
       maven 'maven3'
    }
    
    
    environment {
        DOCKER_TAG = getVersion()
    }
    
    stages { 
        stage('SCM') {
            steps {
                git branch: 'main', credentialsId: 'github-cred2', url: 'https://github.com/oxdead/dockeransiblejenkins.git'
            }
            
        }
        
        stage('Maven Build') {
             steps {
                sh 'mvn clean package'
            }   
        }
        
        stage('Docker Build') {
             steps {
                sh "docker build . -t oistri/hariapp:${DOCKER_TAG} "
            }   
        }
        
        stage('DockerHub Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPwd')]) {
                    sh 'docker login -u oistri -p ${dockerHubPwd}'
                }
                sh "docker push oistri/hariapp:${DOCKER_TAG} "
            }   
        }

        stage('Docker Deploy'){
            steps{
              ansiblePlaybook credentialsId: 'dev-server', disableHostKeyChecking: true, extras: '-e DOCKER_TAG="$DOCKER_TAG"', installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
            }
        }

    }
}

def getVersion() {
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
