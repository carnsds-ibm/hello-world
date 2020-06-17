// Jenkinsfile for NodeJS Hello World - CI/CD
def templateName = 'hello-world-nodejs'

openshift.withCluster() {
  env.NAMESPACE = openshift.project()
  env.APP_NAME = "nodejs-hello-world"
  echo "Starting Pipeline for ${APP_NAME}..."
  env.BUILD = "${env.NAMESPACE}"
}

pipeline {
  agent any

  stages {
    stage('preamble') {
        steps {
            script {
                openshift.withCluster() {
                    openshift.withProject() {
                        echo "Using project: ${openshift.project()}"
                        echo "APPLICATION_NAME: ${params.APPLICATION_NAME}"
                    }
                }
            }
        }
    }
    // Run NPM unit tests
    stage('build') {
        steps {
          script {
          // Build container image using local Openshift cluster
          openshift.withCluster() {
            openshift.withProject() {
              timeout (time: 30, unit: 'SECONDS') {
                // run the build and wait for completion
                def build = openshift.selector("bc", "${APP_NAME}").startBuild("--from-dir=.")
                                    
                // print the build logs
                build.logs('-f')
              }
            }        
          }
        }
      }
    }

    stage('Promotion gate') {
      steps {
        script {
          input message: 'Promote application to Production?'
        }
      }
    }
    
		// Deploy to prod. 
    stage('npm run'){
        steps {
          sh """
          npm -v 
          npm start
          """
      }
    }
  }
}
