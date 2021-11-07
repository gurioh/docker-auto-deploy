# FROM openjdk:11
# ARG JAR_FILE=target/*.jar
# COPY ${JAR_FILE} app.jar
# RUN echo $version
# ENTRYPOINT ["java","-jar","/app.jar"]
FROM adoptopenjdk/openjdk11:jdk-11.0.10_9-alpine

#==========================================================
####### bash install ########
#==========================================================
RUN apk update
RUN apk add --no-cache bash

RUN apk add --no-cache git

RUN apk add --no-cache gradle

RUN apk add --no-cache wget

RUN apk add --no-cache maven

#==========================================================
####### Tomcat Env Setting ###########
#==========================================================

ENV TOMCAT_MAJOR 9
ENV TOMCAT_VERSION 9.0.54

ENV INSTALL_HOME /usr/local
ENV CATALINA_HOME /usr/local/apache-tomcat-${TOMCAT_VERSION}
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME/..

#==========================================================
###### Tomcat Download ##########
#==========================================================
RUN wget https://downloads.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
#copy ./docker/apache-tomcat-${TOMCAT_VERSION}.tar.gz $INSTALL_HOME

WORKDIR $INSTALL_HOME
RUN tar -xvzf apache-tomcat-${TOMCAT_VERSION}.tar.gz
RUN rm -rf $CATALINA_HOME/webapps/docs
RUN rm -rf $CATALINA_HOME/webapps/examples
RUN rm -rf $CATALINA_HOME/webapps/host-manager
RUN rm -rf $CATALINA_HOME/webapps/manager
RUN rm -rf $CATALINA_HOME/webapps/ROOT

#==========================================================
# Setting docker timezone
#==========================================================
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


#==========================================================
# Application 배치
# 이미 Maven Build 가 완료된 상태에 webapp를 docker image 에 copy
#==========================================================

#WORKDIR /usr/local/apache-tomcat-9.0.46/bin

#RUN git clone https://github.com/OpenSourceConsulting/playce-roro-v2.git
#WORKDIR /tmp/playce-roro
#RUN ./mvnw clean package

#RUN cp -fR /tmp/jpetstore-6/target/jpetstore /usr/local/apache-tomcat-9.0.46/webapps/

#copy ./jpetstore-6/target/jpetstore $CATALINA_HOME/webapps/

copy ./roro-web/target/roro-web.war  /usr/local/apache-tomcat-${TOMCAT_VERSION}/webapps/ROOT.war
copy ./docker/startup-entrypoint.sh  /usr/local/apache-tomcat-${TOMCAT_VERSION}

ENV WORKING_DIR ${CATALINA_HOME}/work

CMD ${CATALINA_HOME}/startup-entrypoint.sh
