#!/bin/bash
echo "Inside startScan.sh file............."
cp -r /source_code ./source_code

export PATH=$PATH:/opt/Fortify/Fortify_SCA_and_Apps_19.1.0/bin

echo "Fortify update started............."
fortifyupdate
echo "Fortify clean started............."
cd source_code && sourceanalyzer -b $prod_name gradle clean build -x test
sourceanalyzer -b $prod_name gradle --info assemble
echo "Fortify translation started............."
sourceanalyzer -b $prod_name -source 1.8 "/source_code" -exclude "/src/test/**/*.java:/src/integrationTest/**/*.java:/build"
echo "Fortify scan started............."
sourceanalyzer -b $prod_name -scan -format "fpr" -f  "/source_code/${sonar_fortify_ssc_appversion}.fpr"
echo "Fortify scan completed............."

#echo "Uploading Fortify scan result to SSC and Sonarqube............."
#gradle sonarqube -x test "-Dsonar.fortify.ssc.url=http://authToken:11111111-1111-1111-1111-111111111111@127.0.0.1:8080/ssc" -Dsonar.fortify.ssc.appversion=$sonar_fortify_ssc_appversion -Dsonar.fortify.ssc.uploadFPR="/source_code/${sonar_fortify_ssc_appversion}.fpr" -Dsonar.fortify.ssc.failOnArtifactStates=SCHED_PROCESSING,PROCESSING,REQUIRE_AUTH,ERROR_PROCESSING -Dsonar.fortify.ssc.processing.timeout=240 -Dsonar.projectKey=$sonar_projectKey -Dsonar.sources="/source_code" -Dsonar.projectBaseDir="/source_code" -Dsonar.exclusions=src/test/java/**/* -Dsonar.host.url=http://127.0.0.1:9000 $sonarExtParam
#echo "Fortify scan result uploaded successfully to SSC and Sonarqube............."

echo "Uploading FPR file to Fortify SSC through SCA command line started............."
SSC_APP_NAME=$(echo $sonar_fortify_ssc_appversion| cut -d':' -f 1)
SSC_APP_VERSION=$(echo $sonar_fortify_ssc_appversion| cut -d':' -f 2)
fortifyclient -url http://127.0.0.1:8080/ssc -authtoken 11111111-1111-1111-1111-111111111111 uploadFPR -file "/source_code/${sonar_fortify_ssc_appversion}.fpr" -project $SSC_APP_NAME -version $SSC_APP_VERSION
echo "Uploading FPR file to Fortify SSC through SCA command line completed............."

echo "Starting Black Duck scan............."
java -jar /DockerFortify/hub-detect-4.0.3.jar --blackduck.hub.url=https://blackducksoftware.com --blackduck.hub.api.token=abcdefghijklmnp --detect.source.path="/source_code" --detect.project.name="$blackduck_hub_project_name" --detect.project.version.name="$blackduck_hub_project_version" --logging.level.com.blackducksoftware.integration=DEBUG --detect.api.timeout=600000 --detect.project.codelocation.unmap=true --detect.force.success=true
echo "Black Duck scan completed............."
