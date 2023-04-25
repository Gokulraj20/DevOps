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
                script{
                    // retrieve sonar values using curl
                    def apiUrl = "https://sonarqubeurl:9000/api/measures/component"
                    def projectkey = "myproj-key"
                    def metrics = "coverage"

                    def response = sh(
                        script: "curl -s -u <sonarqube_username>:<sonarqube_password> '${apiUrl}?component=${prokectkey}&metrics=${metrics}'"
                        returnStdout: true
                    )
                    // parse the response to extract values
                    def json = readJson(text: response)
                    def coverage = json.component.measures.find {it.metric == "coverage }"?.value}

                    // using the extracted values
                    if (coverage < 80.0) {
                        // Notify
                        emailext (
                            subject: "code coverage failure",
                            body: "sonarqube code coverage is less than threshold ${coverage}%",
                            to: "emailid"
                        )


                        // abort pipeline
                        error(" sonar code coverage is less than threshold ${coverage}%")
                    }
                
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
            emailext body: 'The Build was successfully completed',
                subject: 'Build successful',
                to: 'emaiid'     // replace email id
        }
        failure{
            emailext body: 'The Build failed',
                subject: 'Build failure',
                to: 'emaiid'    // replace email id
        }
    }

}
