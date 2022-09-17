FROM openjdk:11.0.10-jdk-slim
RUN apt update -y
RUN apt install libsodium-dev -y
EXPOSE 8080
USER 1001
COPY build/libs/*.jar /app.jar
CMD java -Duser.timezone=UTC -XX:+UseContainerSupport -XX:MaxRAMPercentage=75 -jar /app.jar
