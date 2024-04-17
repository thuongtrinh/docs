#ps -ef --sort=start_time | grep test-api | head -n 1 | awk '{print $2}' | xargs kill -9 || true
#sleep 5s
#nohup /u01/jdk1.8.0_241/bin/java -Xms256M -Xmx256M -XX:+UseG1GC -XX:+UseStringDeduplication -jar /u01/apps/test-api/test-api.jar --spring.profiles.active=uat --spring.config.additional-location=file:/application.yml,file:/application-uat.yml --logging.config=file:/logback-spring.xml --server.port=8180 > /dev/null 2>&1&
nohup java -jar /u01/apps/employee-api/employeemanager-0.0.1-SNAPSHOT.jar  --allowedOrigins=* --server.port=8180  > /dev/null 2>&1&

-Dspring.config.additional-location
--spring.config.additional-location
