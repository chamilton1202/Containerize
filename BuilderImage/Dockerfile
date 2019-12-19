FROM redhat-openjdk-18/openjdk18-openshift
# Current Image as of 12/18/2019 registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift/images/1.7-5.1575996300

#Switch to root
USER root

#Copy the Project specific Maven Settings
COPY s2i-settings.xml /home/jboss/.m2/settings.xml

#Switch back to Jboss user
USER 185