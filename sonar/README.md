

#How to use the image

docker run -d --name sonar -p 9000:9000 -p 9092:9092 -v /opt/sonar/data:/opt/sonarqube/data -v /opt/sonar/plugins:/opt/sonarqube/extensions/plugins -v /opt/sonar/logs:/opt/sonarqube/logs -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD=sonar -e SONARQUBE_JDBC_URL="jdbc:mysql://10.100.1.20:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance"  topineeu/sonar

Where :

/opt/sonar/data:/opt/sonarqube/data      : sonar data stored 
/opt/sonar/plugins:/opt/sonarqube/extensions/plugins   : Plugins stored outside
/opt/sonar/logs:/opt/sonarqube/logs : logs


Set the database config using the envs SONARQUBE_JDBC_*
