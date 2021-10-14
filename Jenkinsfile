def app

node {

    stage('Checkout Source') {

        git url:'https://github.com/guriOH/docker-auto-deploy.git', branch:'main'
        withMaven(
            // Maven installation declared in the Jenkins "Global Tool Configuration"
            maven: 'maven 3.8.3', // (1)
            // Use `$WORKSPACE/.repository` for local repository folder to avoid shared repositories
            mavenLocalRepo: '.repository', // (2)
            // Maven settings.xml file defined with the Jenkins Config File Provider Plugin
            // We recommend to define Maven settings.xml globally at the folder level using
            // navigating to the folder configuration in the section "Pipeline Maven Configuration / Override global Maven configuration"
            // or globally to the entire master navigating to  "Manage Jenkins / Global Tools Configuration"
            //mavenSettingsConfig: 'my-maven-settings' // (3)
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
