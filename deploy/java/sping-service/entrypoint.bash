#!/bin/bash
for file in /etc/secrets/*; do source "$file"; done && java -jar ${APP_HOME} --spring.profiles.active=${SPRING_PROFILE}
