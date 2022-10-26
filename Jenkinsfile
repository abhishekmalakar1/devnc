currentBuild.displayName = "multiBranch-job1-#"+currentBuild.number
pipeline{
    agent any
    stages{
        stage('build'){
            steps{
                cleanWs()
                echo 'building'
                
                
            }
        }
        stage('test'){
            steps{
                echo 'testing'
                
                
                }
            }
        }
        stage('deploy'){
            steps{
              echo 'deploying'
              
            }
        }
    }
}
