currentBuild.displayName = "ansible-main-job-#"+currentBuild.number
pipeline{
    agent any
    parameters{
       // choice(name: 'ENV', choices: ['UAT', 'DEV', 'TEST', 'PPT'], description: '')
        booleanParam(name: 'healthCheck', defaultValue: false, description: '')
        booleanParam(name: 'httpdInstall', defaultValue: false, description: '')
    }
    stages{
        stage('clean WS'){
            steps{
                cleanWs()
                
            }
        }
        stage('HC Play'){
            when{
                expression{
                    params.healthCheck == true
                }
            }
            steps{
                    // build job: 'pipeline-job-1', parameters: [choice(name: 'version', value: "${params.version}"), string(name: 'expName', value: "${params.expName}")]
                script {
                    // def job = build job: 'pipeline-job-1', parameters: [[$class: 'StringParameterValue', name: 'expName', value: "${params.expName}"], [$class: 'ChoiceParameterValue', name: 'version', value: "${params.version}"]]
                    build job: 'health-check-job', parameters: [
                        booleanParam(name: 'healthCheck', value: "${params.healthCheck}")]
                }
            }
        }
        stage('httpd Play'){
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
            }    
        }
        stage('copy artifacts'){
            steps{
                copyArtifacts fingerprintArtifacts: true, projectName: 'health-check-job'
                copyArtifacts fingerprintArtifacts: true, projectName: 'httpd-install-job'
                archiveArtifacts artifacts: '*', followSymlinks: false, onlyIfSuccessful: true
            }
        }
    }
}
