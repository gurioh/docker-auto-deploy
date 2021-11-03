def app

node {
    def nexus = "10.99.87.210:5000"
    def nexusCredential = "nexus"

    stage('Checkout Source') {

        git url:'https://github.com/guriOH/docker-auto-deploy.git', branch:'main'
        withMaven(
            maven: 'maven 3.8.3', // (1)
            mavenLocalRepo: '.repository', // (2)
        ) {
          // Run the maven build
          sh "mvn clean verify"
        }
    }
    
    stage('Ready') {
      sh "echo 'Ready to build'"
      mvnHome = tool 'maven 3.8.3'
    }
    
    // mvn 빌드로 jar파일을 생성하는 stage
    stage('Build'){  
        sh "echo 'Build Spring Boot Jar'"
        sh "${mvnHome}/bin/mvn clean package"
    }
    
    
    //dockerfile기반 빌드하는 stage ,git소스 root에 dockerfile이 있어야한다
    stage('Build image'){   
        app = docker.build("build-test/dockertest")
    }
    
    stage("Push image") {
        
         docker.withRegistry("http://$nexus") {
             def customImage = docker.build("build-test/dockertest:latest")
             customImage.push()
         }
            
      
//         steps {
//             script {
//                 docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
//                         myapp.push("latest")
//                         myapp.push("${env.BUILD_ID}")
//                 }
//             }
//         }
    }

    
    // kubernetes에 배포하는 stage, 배포할 yaml파일(필자의 경우 test.yaml)은 jenkinsfile과 마찬가지로 git소스 root에 위치시킨다.
    stage('Kubernetes deploy') {
        kubernetesDeploy configs: "hello.yaml", kubeconfigId: 'kubeconfig'
//         sh "kubectl --kubeconfig=/u01/kube-config.yaml rollout restart deployment/test-deployment"
    }

    stage('Complete') {
        sh "echo 'The end'"
    }

}
