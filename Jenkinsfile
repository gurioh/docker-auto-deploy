pipeline {

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git url:'https://github.com/guriOH/docker-auto-deploy.git', branch:'main'
      }
    }
    
    stage('Ready') {
      sh "echo 'Ready to build'"
      mvnHome = tool 'Maven 3.6.0'
    }
    
    // mvn 빌드로 jar파일을 생성하는 stage
    stage('Build'){  
        sh "echo 'Build Spring Boot Jar'"
        sh "'${mvnHome}/bin/mvn' clean package"
    }
    
    
    //dockerfile기반 빌드하는 stage ,git소스 root에 dockerfile이 있어야한다
    stage('Build image'){   
        app = docker.build("cross9308/dockertest")
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

    
    // kubernetes에 배포하는 stage, 배포할 yaml파일(필자의 경우 test.yaml)은 jenkinsfile과 마찬가지로 git소스 root에 위치시킨다.
    // kubeconfigID에는 앞서 설정한 Kubernetes Credentials를 입력하고 'sh'는 쿠버네티스 클러스터에 원격으로 실행시킬 명령어를 기술한다.
    stage('Kubernetes deploy') {
        kubernetesDeploy configs: "hello.yaml", kubeconfigId: 'Kubeconfig'
        sh "/usr/local/bin/kubectl --kubeconfig=/u01/kube-config.yaml rollout restart deployment/test-deployment -n zuno"
    }

    stage('Complete') {
        sh "echo 'The end'"
    }

  }

}
