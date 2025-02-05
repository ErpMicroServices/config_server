FROM eclipse-temurin:20-jdk

LABEL authors="JimBarrows"
VOLUME /tmp

COPY build/libs/Configuration%20Server-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]


