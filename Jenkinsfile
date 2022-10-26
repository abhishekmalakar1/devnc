currentBuild.displayName = "declarative-pipeline-job1-#"+currentBuild.number
pipeline{
    agent any
    parameters{
        choice(name: 'ENV', choices: ['UAT', 'DEV', 'TEST', 'PPT'], description: '')
        choice(name: 'version', choices: ['1.1.0', '1.1.1', '1.1.2'], description: '')
        booleanParam(name: 'executeTest', defaultValue: true, description: '')
        string(name: 'expName', defaultValue: '', description: 'enter exporter name')
    }
    stages{
        stage('build'){
            steps{
                echo 'building the app'
            }
        }
        stage('test'){
            when{
                    expression{
                        params.executeTest == true
                    }
                }
            steps{
                echo 'testing the app'
            }
        }

        stage('deploy'){
            steps{
                echo "Deploying version ${params.version} to ${params.ENV} environment."
                echo 'deploying the app'
            }
        }
        
        stage('run play'){
            steps{
                script{
                    def playjob = build job: 'pipeline-job-1', parameters: [choice(name: 'version', value: "${params.version}"), string(name: 'expName', value: "${params.expName}")]
                }
            }
        }
        
        stage('copy artifacts'){
            steps{
                copyArtifacts filter: 'report*', fingerprintArtifacts: true, projectName: 'pipeline-job-1'
            }
        }
    }
}
