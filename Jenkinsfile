def awsCredentials = [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS']]

pipeline {
    agent {
        node {
            label 'master'
        }
    }

stages {
    stage('Terraform Init') {
      steps {
        bat "${env.TERRAFORM_HOME}/terraform init -input=false"
      }
    }
    stage('Terraform Plan') {
      steps {
        bat "${env.TERRAFORM_HOME}/terraform plan -input=false"
      }
    }
    stage('Terraform Apply') {
      steps {
        input 'Apply Plan'
        bat "${env.TERRAFORM_HOME}/terraform apply -input=false"
      }
    }
  }

}