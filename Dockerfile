FROM openjdk:11 as build

ARG APP_NAME=transformer
ARG COMPILATION_DIR=/usr/src/${APP_NAME}

RUN mkdir ${COMPILATION_DIR}

WORKDIR ${COMPILATION_DIR}
COPY . ${COMPILATION_DIR}

RUN ./mvnw install -DskipTests


FROM fabric8/java-alpine-openjdk11-jre

ARG APP_NAME=transformer
ARG COMPILATION_DIR=/usr/src/${APP_NAME}
ARG EXECUTABLE_ARTIFACT=${COMPILATION_DIR}/target/format-transformer-gateway-0.0.1-SNAPSHOT.jar
ARG ARTIFACT_TARGET=/opt/${APP_NAME}

RUN mkdir ${ARTIFACT_TARGET}

WORKDIR ${ARTIFACT_TARGET}
COPY --from=0 ${EXECUTABLE_ARTIFACT} .

EXPOSE 8080

CMD ["java", "-jar", "/opt/transformer/format-transformer-gateway-0.0.1-SNAPSHOT.jar", "--spring.profiles.active=${SPRING_PROFILE_NAME}"]