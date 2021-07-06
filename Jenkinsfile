pipeline {
agent any

  environment {
    ABFL_TF_WORKSPACEN 		= "${params.Environment}_WS" /// Sets the Terraform Workspace
    ABFL_TF_IN_AUTOMATION 	= 'true'
    ABFL_TF_LOG 		    = 'TRACE'
    ABFL_TF_LOG_PATH 		= '/tmp/TF.log'
    ABFL_SERVER_NAME 		= "${params.Environment}"
    ABFL_TF_REGION 		    = "${params.region}"
    

  }
  stages {
	  
    stage('Check-Out') {
     steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'main']], userRemoteConfigs: [[credentialsId: 'Github', url: 'https://github.com/IBRAHIMCH3/abfl-digital-infra.git']]])
        sh '''
        ls -l main
        '''
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'variables']], userRemoteConfigs: [[credentialsId: 'Github', url: 'https://github.com/IBRAHIMCH3/abfl-digital-infra.git']]])
        sh '''
        ls -la variables
        if [ ! -d ${ABFL_SERVER_NAME}_Dir ]; then
            echo "Folder doesnt exist. Creating folder!"
            mkdir ${ABFL_SERVER_NAME}_Dir
		else
			echo "Folder exists !!"
        fi
        mv -i main/* ${ABFL_SERVER_NAME}_Dir
        mv -i variables/.terraform.lock.hcl variables/*.tf variables/config/${region}/${ABFL_SERVER_NAME}.tfvars ${ABFL_SERVER_NAME}_Dir
	mv -i config/${region} ${ABFL_SERVER_NAME}_Dir
        ls -lart ${ABFL_SERVER_NAME}_Dir
        '''
     }
    }

    stage('Terraform Init') {

      steps {
	        echo 'Initiating workspace creation!!'
		sh '''
		cd ${ABFL_SERVER_NAME}_Dir

		terraform init -input=true -reconfigure -backend-config "key=global/ec2/${ABFL_SERVER_NAME}.tfstate"
                /usr/bin/terraform workspace new ${ABFL_TF_WORKSPACEN} || true
		/usr/bin/terraform workspace list
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
		cd ${ABFL_SERVER_NAME}_Dir
		/usr/bin/terraform plan -input=false -out=tfplan --var-file ${ABFL_SERVER_NAME}.tfvars
		/usr/bin/terraform show -no-color tfplan > tfplan.txt
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
                   sh "cd ${ABFL_SERVER_NAME}_Dir"
                    def plan = readFile "${ABFL_SERVER_NAME}_Dir/tfplan.txt"
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
		cd ${ABFL_SERVER_NAME}_Dir
		/usr/bin/terraform apply -input=false tfplan
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
		cd ${ABFL_SERVER_NAME}_Dir
        /usr/bin/terraform destroy -auto-approve --var-file ${ABFL_SERVER_NAME}.tfvars
		'''
      }
    }
////
  }
    post {
        always {
            archiveArtifacts artifacts: "${ABFL_SERVER_NAME}_Dir/tfplan.txt"
        }
  }
}
