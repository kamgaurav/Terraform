/*def awsCredentials = [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS']]
/*
stages {
    stage('Terraform Init') {
      steps {
        bat "terraform init -input=false"
      }
    }
    stage('Terraform Plan') {
      steps {
        bat "terraform plan -input=false"
      }
    }
    stage('Terraform Apply') {
      steps {
        input 'Apply Plan'
        bat "terraform apply -input=false"
      }
    }
}
*/



pipeline {

    agent any
   	
   stages {
        stage('Compile stage') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']])
                {
                  bat "terraform init -input=false" 
                }
            }
        }

        stage('testing stage') {
             steps {
               withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']])
                {
                  bat "terraform plan -input=false"
                }
              }
        }

        stage('deployment stage') {
              steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']])
                {
                  bat "terraform apply -input=false -auto-approve"
                }
              }
        }

  }

}

