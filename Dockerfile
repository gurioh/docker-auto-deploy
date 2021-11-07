FROM openjdk:11
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
RUN echo $version
ENTRYPOINT ["java","-jar","/app.jar"]
