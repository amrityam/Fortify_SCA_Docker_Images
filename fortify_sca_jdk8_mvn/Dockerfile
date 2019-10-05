FROM maven:3.3.9-jdk-8
ADD $pwd/fortify_sca_jdk8_mvn/settings.xml /usr/share/maven/conf/settings.xml
COPY ./fortify_sca_jdk8_mvn /DockerFortify/
RUN apt-get install unzip
ADD ./Fortify /pkg
ADD ./Fortify/fortify.license /licence/
RUN tar -xvzf /pkg/*.tar.gz -C /pkg/
RUN echo "fortify_license_path=/licence/fortify.license">/pkg/Fortify_SCA_and_Apps_19.1.0_linux_x64.run.options
RUN /pkg/Fortify_SCA_and_Apps_19.1.0_linux_x64.run --mode unattended
RUN rm -r /pkg/

WORKDIR /opt/Fortify/Fortify_SCA_and_Apps_19.1.0/plugins/maven/
RUN ["chmod", "+x", "/DockerFortify/startScan.sh"]
ENTRYPOINT ["/DockerFortify/startScan.sh"]
