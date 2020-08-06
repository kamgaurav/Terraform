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
   	
    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }
    stages {
        stage('Compile stage') {
            steps {
                bat "terraform init -input=false" 
        }
    }

         stage('testing stage') {
             steps {
                bat "terraform plan -input=false"
        }
    }

          stage('deployment stage') {
              steps {
                bat "terraform apply -input=false"
        }
    }

  }

}

