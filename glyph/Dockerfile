# Build off CentOS 7
FROM centos:centos7

# Add the Glyptodon Enterprise repository
COPY glyptodon.repo /etc/yum.repos.d/

# Install Guacamole and Tomcat
RUN    yum install -y                            \
        gettext                                  \
        glyptodon-guacamole                      \
        glyptodon-guacamole-auth-jdbc-mysql      \
        tomcat                                   \
    && yum clean all                             \
    && rm /etc/yum.repos.d/glyptodon.repo

# Add Tomcat service user to the "guacamole" group
RUN usermod -aG guacamole tomcat

# Deploy the Guacamole web application under Tomcat
RUN ln -s /usr/share/guacamole/guacamole.war /var/lib/tomcat/webapps/ROOT.war

# Add template guacamole.properties which will be populated with environment
# variables during startup by the entrypoint script
COPY guacamole.properties.docker /etc/guacamole/
COPY mysql-connector-java-8.0.19.jar /usr/share/java/mysql-connector-java.jar

RUN ls -al /etc/guacamole/lib/

# Tomcat will be accessed via port 8080
EXPOSE 8080

# Use Guacamole entrypoint
ENTRYPOINT [ "/usr/share/guacamole/entrypoint-guacamole.sh" ]