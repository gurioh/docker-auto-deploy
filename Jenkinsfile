def app

parameters {
        string(name : 'VERSION', defaultValue : 'latest', description : '')
}

node {
    def nexus = "10.99.87.210:5000"
    def nexusCredential = "nexus"

//     stage('Checkout Source') {

//         git url:'https://github.com/guriOH/docker-auto-deploy.git', branch:'main', credentialsId:'bitbucket'
//         withMaven(
//             maven: 'maven 3.8.3', // (1)
//             mavenLocalRepo: '.repository', // (2)
//         ) {
//           // Run the maven build
//           sh "mvn clean verify"
//         }
//     }
    
    stage('Ready') {
      sh "echo 'Ready to build'"
      git url:'https://git.osci.kr/scm/pd/playce-roro-v2.git', branch:'henry'
      withMaven(
          maven: 'maven 3.8.3',
          mavenLocalRepo: '.repository',
      ){
        // Run the maven build
        sh "mvn clean verify"
      }
      mvnHome = tool 'maven 3.8.3'
    }
    
    // mvn 빌드로 jar파일을 생성하는 stage
    stage('Build'){  
        sh "echo 'Build Spring Boot Jar'"
        sh "${mvnHome}/bin/mvn clean package"
    }
    
    
    //dockerfile기반 빌드하는 stage ,git소스 root에 dockerfile이 있어야한다
    stage('Build image'){   
        app = docker.build("build-test/dockertest:${params.VERSION}")
    }
    
    stage("Push image") {
        
         docker.withRegistry("http://$nexus") {
             def customImage = docker.build("build-test/dockertest:${params.VERSION}")
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
        
    stage("Update deploy file"){
            sh '''
                echo "test" > test.yaml
            '''
            sh "ls -al"
//             git url:'https://github.com/guriOH/docker-auto-deploy.git', branch:'main'
//             git add test.yml
//             git commit -m "Add yaml"
            sh "echo ${params.VERSION}"
            sh "sed -i s/VERSION/${params.VERSION}/g hello.yaml"
            sh "cat hello.yaml"
        
//        sh "sed -i s/VERSION/${params.VERSION}/g hello.yaml"
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
