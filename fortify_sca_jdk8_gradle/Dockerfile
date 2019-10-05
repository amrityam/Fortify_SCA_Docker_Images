FROM openjdk:8

ENV GRADLE_VERSION 4.5.1

RUN apt-get update && apt-get -y install unzip wget curl

COPY ./jdk8_gradle /DockerFortify/
ADD ./Fortify /pkg
ADD ./Fortify/fortify.license /licence/
RUN tar -xvzf /pkg/*.tar.gz -C /pkg/
RUN echo "fortify_license_path=/licence/fortify.license">/pkg/Fortify_SCA_and_Apps_19.1.0_linux_x64.run.options
RUN /pkg/Fortify_SCA_and_Apps_19.1.0_linux_x64.run --mode unattended
RUN rm -r /pkg/

# Install Gradle
RUN wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && unzip -qq gradle-${GRADLE_VERSION}-bin.zip -d /opt && rm gradle-${GRADLE_VERSION}-bin.zip
	
# Export environment variables	
ENV GRADLE_HOME /opt/gradle-${GRADLE_VERSION}
ENV PATH ${PATH}:${GRADLE_HOME}/bin	

ARG GID=990
ARG UID=994
RUN groupadd --gid ${GID} go \
  && useradd --uid ${UID} --gid go --shell /sbin/nologin --create-home go
  
RUN ["chmod", "+x", "/DockerFortify/startScan.sh"]

RUN chmod -R 777 /opt/Fortify/Fortify_SCA_and_Apps_19.1.0
  
USER go
WORKDIR /opt/Fortify/Fortify_SCA_and_Apps_19.1.0/plugins/maven/
ENTRYPOINT ["/DockerFortify/startScan.sh"]