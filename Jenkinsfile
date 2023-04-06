//Jenkins pipeline for building Java Application
pipeline{
    agent any
    stages{

        stage('Checkout'){
            steps{
                git 'https://github.com/github_username/repo.git'  // checkout code from repo

                //git branch: 'master',
                //    credentialsId: 'github-credentials',
                //    url: 'https://github.com/github_username/repo.git'    
            }
        }
        stage('Build'){
            steps{
                sh 'mvn clean package'  // builds the java web app using maven
            }
        }
        stage('Test'){
            steps{
                sh 'mvn test'  // runs test for java applicaton  
            }  
        }
        stage('Sonarqube code coverage'){
            steps{
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar -Dsonar.projectkey=myproj-key -Dsonar.host.url=https://sonarqubeurl:9000 
                        -Dsonar.login=sonar-login-token'
                }
            }
        }  
        stage('Build Docker Image'){
            steps{
                sh 'docker build -t java-app .' // builds docker image for java app
            }
        }
        stage('Push Docker image to Dockerhub'){
            steps{
                withCredentials([string(credentialsId: 'dockerhub-credentials', variable: 'DOCKERHUB_CREDENTIALS')]){
                    sh 'docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW}' // login to dockerhub

                    sh 'docker tag java-app:latest <dockerhub-username>/java-app:latest'  // tag docker image with dockerhub username

                    sh 'docker push <dockerhub-username>/java-app:latest'  // push the docker image
                }
            }
        }
        stage('Deploy to a docker container'){
            steps{
                sh 'docker run -d -p 8080:8080 <dockerhub-username>/java-app:latest'   // deploy docker container for java app 
            }
        }
    }
    post{
        success{
            emailtext body: 'The Build was successfully completed',
                subject: 'Build successful',
                to: 'emaiid'     // replace email id
        }
        failure{
            emailtext body: 'The Build failed',
                subject: 'Build failure',
                to: 'emaiid'    // replace email id
        }
    }

    }
