#!/bin/bash
### Create the Builder Image

### Set the Launch Path
set LaunchPath=$(pwd)

### Login to the OpenShift Cluster
### Set login to false if you want to skip
USE_OPENSHIFT_LOGIN=true
OPENSHIFT_USER=
OPENSHIFT_URL=

if [ "${USE_OPENSHIFT_LOGIN}" = "true" ]; then
    oc login -u ${OPENSHIFT_USER} ${OPENSHIFT_URL}
fi

### Create the OpenShift Project
CREATE_OPENSHIFT_PROJECT=true
OPENSHIFT_PROJECT=

if [ "${CREATE_OPENSHIFT_PROJECT}" = "true" ]; then
    oc new-project ${OPENSHIFT_PROJECT}
fi

### Create the Red Hat Service Account Secret and link to the Project Service Accounts
USE_RH_SECRET=true
### Path to YAML
RH_SERVICE_SECRET_YAML=
### Secret Name in the file
RH_SERVICE_SECRET=

if [ "${USE_RH_SECRET}" = "true" ]; then
    oc create -f ${RH_SERVICE_SECRET_YAML}
    oc secret link sa/default secret/${RH_SERVICE_SECRET} --for=pull
    oc secret link sa/builder secret/${RH_SERVICE_SECRET}
fi

### Create the GitHub or similar Git Repository Secret
### Set Git Repo to false if you want to skip
USE_GIT_REPO=true
GIT_USER=
GIT_PASSWORD=

if [ "${USE_GIT_REPO}" = "true" ]; then
    oc create secret generic git-repo-secret --from-literal=username=${GIT_USER} --from-literal=password=${GIT_PASSWORD} --type=kubernetes.io/basic-auth
fi

### Create the Maven or similar Maven Repository Secret
### Set Maven Repo to false if you want to skip
USE_MAVEN_REPO=true
MAVEN_USER=
MAVEN_PASSWORD=

if [ "${USE_MAVEN_REPO}" = "true" ]; then
    oc create secret generic maven-repo-secret --from-literal=maven_username=${MAVEN_USER} --from-literal=maven_password=${MAVEN_PASSWORD}
fi

### Annotate the Maven Repository Secret with the Maven Repo URL
MAVEN_REPO_URL=

if [ -n "${MAVEN_REPO_URL}" ]; then
    oc annotate secret maven-repo-secret 'build.openshift.io/source-secret-match-uri-1=${MAVEN_REPO_URL}'
fi

if [ "${USE_MAVEN_REPO}" = "true" ]; then
    ### Link the Maven Repository Secret to the Project Service Accounts
    oc secret link sa/default secret/maven-repo-secret --for=pull
    oc secret link sa/builder secret/maven-repo-secret
    oc secret link sa/deployer secret/maven-repo-secret
fi

### Create the Build Config for the Builder Image
CREATE_BUILD_CONFIG=true
BASE_BUILDER_IMAGE=registry.redhat.io/redhat-openjdk-18/openjdk18-openshift
BUILDER_IMAGE_NAME=

if [ "${CREATE_BUILD_CONFIG}" = "true" ]; then
    oc new-build --strategy docker --binary --docker-image ${BASE_BUILDER_IMAGE} --name ${BUILDER_IMAGE_NAME}
fi

### Start the Build of the Builder Image
oc start-build ${BUILDER_IMAGE_NAME} --from-dir . --follow

### Script finished
echo "Create the Builder Image script has completed"
echo.
pause










