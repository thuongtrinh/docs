#!/bin/bash
mkdir -p /etc/secrets/
echo "echo starting app" > /etc/secrets/start_app
for file in /etc/secrets/*
do
	. "$file"
done

export ROOT_DIR=/app
export APP_HOME=${ROOT_DIR}/app.jar
export AGENT_HOME=${ROOT_DIR}/agent.jar
export JAVA_OPTS="$JAVA_OPTS -XX:MaxRAMPercentage=60.0 -javaagent:$AGENT_HOME -Dapplicationinsights.sampling.percentage=100"
eval "java $JAVA_OPTS -jar $APP_HOME --spring.profiles.active=$SPRING_PROFILE"
