def awsCredentials = [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS']]

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
