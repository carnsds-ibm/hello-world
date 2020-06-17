// Jenkinsfile for NodeJS Hello World - CI/CD
def templateName = 'hello-world-nodejs'

openshift.withCluster() {
  env.NAMESPACE = openshift.project()
  env.APP_NAME = "${JOB_NAME}".replaceAll(/-build.*/, '')
  echo "Starting Pipeline for ${APP_NAME}..."
  env.BUILD = "${env.NAMESPACE}"
}

pipeline {
  agent any

  node {
    env.NODEJS_HOME = "${tool 'Node 12.8.0'}"
    // on linux / mac
    env.PATH="${env.NODEJS_HOME}/bin:${env.PATH}"
    // on windows
    // env.PATH="${env.NODEJS_HOME};${env.PATH}"
    sh 'npm --version'
  }

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
    stage('npm test') {
        steps {
          sh """
          env
          npm -v 
          npm test
          """
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
