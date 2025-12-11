mvn clean
yarn run webpack:build
mvn -Pprod package -Dmaven.test.skip=true