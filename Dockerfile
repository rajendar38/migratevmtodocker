FROM mcr.microsoft.com/windows/servercore:ltsc2016

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]


COPY OpenJDK11U-jdk_x64_windows_11.0.7_10.zip c:\\OpenJDK11U-jdk_x64_windows_11.0.7_10.zip
COPY jboss-eap-7.2.zip c:\\jboss-eap-7.2.zip
COPY jboss_home.zip c:\\jboss_home.zip
COPY jbcs-jsvc-1.0.15.2-win6.x86_64.zip c:\\jbcs-jsvc-1.0.15.2-win6.x86_64.zip


RUN powershell Expand-Archive -Force c:\\OpenJDK11U-jdk_x64_windows_11.0.7_10.zip c:
RUN powershell Expand-Archive -Force c:\\jboss-eap-7.2.zip c:\\JBoss
RUN powershell Expand-Archive -Force c:\\jboss_home.zip c:
RUN powershell Expand-Archive -Force c:\\jbcs-jsvc-1.0.15.2-win6.x86_64.zip c:\\JBoss

RUN powershell Copy-Item -Path "C:\\jboss_home\\*" -Destination "c:\\JBoss\\jboss-eap-7.2" -Recurse -Force
RUN powershell mkdir scripts 
COPY create_config.ps1 c:\\scripts
COPY jc_run.bat c:\\JBoss\\jboss-eap-7.2



ENV JAVA_HOME "c:\openjdk-11.0.7_10"
ENV JBOSS_HOME "c:\JBoss\jboss-eap-7.2" 
ENV JAVA_OPTS "-Xmx2048m -XX:CompressedClassSpaceSize=256m"
ENV _JAVA_OPTIONS "-Xmx2048m -XX:CompressedClassSpaceSize=256m"



ENV path "C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Users\ContainerAdministrator\AppData\Local\Microsoft\WindowsApps;c:\openjdk-11.0.7_10\bin;c:\JBoss\jboss-eap-7.2\bin"
#RUN setx PATH "C:\jre1.8.0_45\bin;C:\jboss-eap-7.0\bin;%PATH%"
#RUN setx /M PATH "c:\jre1.8.0_45\bin;%PATH%"
#RUN NET USER testing "Password01!" /ADD
#RUN NET LOCALGROUP "Administrators" "testing" /ADD


CMD java -version
#CMD powershell c:\\scripts\\create_config.ps1
WORKDIR C:\\scripts
RUN .\create_config.ps1


EXPOSE 8080
EXPOSE 9990
CMD C:\JBoss\jboss-eap-7.2\bin\standalone.bat -b 0.0.0.0 -bmanagement 0.0.0.0



#for running the please use these commands
#docker build -t oraclejdk:8-windowsservercore  .
#docker run -p 8080:8080 oraclejdk:8-windowsservercore
#tomcat username =tomcat/tomcat or admin/admin

#docker run -p 8080:8080 -p 9990:9990 -it oraclejava:jboss standalone.bat -b 0.0.0.0 -bmanagement 0.0.0.0

#docker run --memory 4096m --cpus 2 -p 8080:8080 -p 9990:9990 -bind 0.0.0.0 -bmanagement 0.0.0.0 -it oraclejava:jboss
#docker run -p 8080:8080 -p 9990:9990 -it oraclejava:jboss C:\jboss-eap-7.0\bin\standalone.bat -b 0.0.0.0 -bmanagement 0.0.0.0
#jboss/@Oracle38
