currentBuild.displayName = "ansible-main-job-#"+currentBuild.number
pipeline{
    agent any
    parameters{
       // choice(name: 'ENV', choices: ['UAT', 'DEV', 'TEST', 'PPT'], description: '')
        booleanParam(name: 'healthCheck', defaultValue: true, description: '')
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
                echo "install-httpd-playbook si running"
            }    
        }
    }
}
