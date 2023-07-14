# Stage 1: Build stage
FROM openjdk:11 as base
WORKDIR /app
COPY . .
RUN chmod +x gradlew
RUN ./gradlew build

# Stage 2: Final stage
FROM tomcat:9
WORKDIR webapps
COPY --from=base /app/build/libs/sampleWeb-0.0.1-SNAPSHOT.war .
RUN rm -rf ROOT && mv sampleWeb-0.0.1-SNAPSHOT.war ROOT.war

# Set non-root user
RUN chown -R 1001:0 /usr/local/tomcat
USER 1001

# Expose the port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
