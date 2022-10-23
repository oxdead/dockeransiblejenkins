FROM tomcat:9.0-jdk8-corretto-al2
# Take the war and copy to webapps of tomcat
COPY target/*.war /usr/local/tomcat/webapps/dockeransible.war
