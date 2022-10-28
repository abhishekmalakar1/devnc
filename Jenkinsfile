currentBuild.displayName = "ansible-main-job-#"+currentBuild.number
pipeline{
    agent any
    parameters{
       // choice(name: 'ENV', choices: ['UAT', 'DEV', 'TEST', 'PPT'], description: '')
        booleanParam(name: 'healthCheck', defaultValue: false, description: '')
        booleanParam(name: 'httpdInstall', defaultValue: false, description: '')
    }
    stages{
        stage('CLEAN WS'){
            steps{
                cleanWs()
                
            }
        }
        stage('HC PLAY'){
            when{
                expression{
                    params.healthCheck == true
                }
            }
            steps{
                script {
                    build job: 'health-check-job', parameters: [
                        booleanParam(name: 'healthCheck', value: "${params.healthCheck}")]
                }
                copyArtifacts fingerprintArtifacts: true, projectName: 'health-check-job'
            }
        }
        stage('HTTPD PLAY'){
                when{
                expression{
                    params.httpdInstall == true
                }
            }
            steps{
                script {
                    build job: 'httpd-install-job', parameters: [
                        booleanParam(name: 'httpdInstall', value: "${params.httpdInstall}")]
                }
                copyArtifacts fingerprintArtifacts: true, projectName: 'httpd-install-job'
            }    
        }
        stage('COPY ARTIFACTS'){
            steps{
                 archiveArtifacts artifacts: "*", followSymlinks: false, onlyIfSuccessful: true 
            }
        }
    }
}
