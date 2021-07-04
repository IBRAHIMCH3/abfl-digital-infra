pipeline {
agent any

  environment {
    TF_WORKSPACEN = "${params.servername}_WS" /// Sets the Terraform Workspace
    TF_IN_AUTOMATION = 'true'
    TF_LOG = 'TRACE'
    TF_LOG_PATH = '/tmp/TF.log'
    SERVER_NAME = "${params.servername}"

  }
  stages {
//
    stage('Check-Out') {
     steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'variables']], userRemoteConfigs: [[credentialsId: 'Github', url: 'https://github.com/IBRAHIMCH3/abfl-digital-infra.git']]])
        sh '''
        ls -la variables
        if [ ! -d ${SERVER_NAME}_Dir ]; then
            echo "Folder doesnt exist. Creating folder!"
            mkdir ${SERVER_NAME}_Dir
		else
			echo "Folder exists !!"
        fi
        mv ec2/* ${SERVER_NAME}_Dir
        mv variables/.terraform.lock.hcl variables/*.tf variables/${SERVER_NAME}.tfvars ${SERVER_NAME}_Dir
        ls -lart ${SERVER_NAME}_Dir
        '''
     }
    }
//
    stage('Terraform Init') {

      steps {
                echo 'Initiating workspace creation!!'
		sh '''
		cd ${SERVER_NAME}_Dir

		terraform init -input=true -reconfigure -backend-config "key=global/ec2/${SERVER_NAME}.tfstate"
                /usr/local/bin/terraform workspace new ${TF_WORKSPACEN} || true
		/usr/local/bin/terraform workspace list
		'''
                echo 'Workspace creation successful!!'
      }
    }


    stage('Terraform Plan') {
     when {
       expression { params.action == 'apply' } 
       }
      steps {
		sh '''
		cd ${SERVER_NAME}_Dir
		/usr/local/bin/terraform plan -input=false -out=tfplan --var-file ${SERVER_NAME}.tfvars
		/usr/local/bin/terraform show -no-color tfplan > tfplan.txt
		'''
      }
    }
     stage('Approval') {
         when {
                not {
                    equals expected: true, actual: params.autoApprove
              }
            }

            steps {
                script {
                   sh "cd ${SERVER_NAME}_Dir"
                    def plan = readFile "${SERVER_NAME}_Dir/tfplan.txt"
                    input message: "Do you want to apply the plan?",
                        parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }
    stage('Terraform Apply') {
     when {
       expression { params.action == 'apply' } 
       }
      steps {
        input 'Apply Plan'
		sh '''
		cd ${SERVER_NAME}_Dir
		/usr/local/bin/terraform apply -input=false tfplan
		'''
      }
    }

    stage('Terraform Destroy') {
     when {
       expression { params.action == 'destroy' } 
       }
      steps {
        input 'Destroy Plan'
		sh '''
		cd ${SERVER_NAME}_Dir
        /usr/local/bin/terraform destroy -auto-approve --var-file ${SERVER_NAME}.tfvars
		'''
      }
    }
////
  }
    post {
        always {
            archiveArtifacts artifacts: "${SERVER_NAME}_Dir/tfplan.txt"
        }
  }
}