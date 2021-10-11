pipeline {

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git url:'https://github.com/guriOH/docker-auto-deploy.git', branch:'main'
      }
    }
    
      stage("Build image") {
            steps {
                script {
                    myapp = docker.build("build-test:${env.BUILD_ID}")
                }
            }
        }
    
//       stage("Push image") {
//             steps {
//                 script {
//                     docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
//                             myapp.push("latest")
//                             myapp.push("${env.BUILD_ID}")
//                     }
//                 }
//             }
//         }

    
    stage('Deploy App') {
      steps {
        script {
          kubernetesDeploy(configs: "hello.yml", kubeconfigId: "mykubeconfig")
        }
      }
    }

  }

}
