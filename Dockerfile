FROM eclipse-temurin:17-jdk-jammy as BUILD
RUN addgroup buildgroup; adduser  --ingroup buildgroup --disabled-password builduser
USER builduser

WORKDIR /opt/api

COPY .mvn/ .mvn
COPY mvnw pom.xml ./

RUN ./mvnw dependency:resolve

COPY src ./src

RUN ./mvnw package -DskipTests
# ---

FROM eclipse-temurin:17-jre-jammy
RUN addgroup rungroup; adduser  --ingroup rungroup --disabled-password runuser
USER runuser

WORKDIR /opt/api

EXPOSE 8080 

COPY --from=BUILD /opt/api/target/spring-petclinic-2.7.0-SNAPSHOT.jar /opt/api/

ENTRYPOINT ["java", "-jar", "/opt/api/spring-petclinic-2.7.0-SNAPSHOT.jar" ]

