@echo off
title Create the Builder Image
cls

REM Set the Launch Path
set LaunchPath=%~dp0
set LaunchPath=%LaunchPath:~0,-1%

REM Login to the OpenShift Cluster
REM Set login to false if you want to skip
set USE_OPENSHIFT_LOGIN=true
set OPENSHIFT_USER=
set OPENSHIFT_URL=

if /I "%USE_OPENSHIFT_LOGIN%" EQU "false" goto OpenShiftProject
oc login -u %OPENSHIFT_USER% %OPENSHIFT_URL%

:OpenShiftProject
REM Create the OpenShift Project
set OPENSHIFT_PROJECT=

oc new-project %OPENSHIFT_PROJECT%

REM Create the Red Hat Service Account Secret and link to the Project Service Accounts
REM Path to YAML
set RH_SERVICE_SECRET_YAML=
REM Secret Name in the file
set RH_SERVICE_SECRET=

oc create -f %RH_SERVICE_SECRET_YAML%
oc secret link sa/default secret/%RH_SERVICE_SECRET% --for=pull
oc secret link sa/builder secret/%RH_SERVICE_SECRET%

REM Create the GitHub or similar Git Repository Secret
REM Set Git Repo to false if you want to skip
set USE_GIT_REPO=true
set GIT_USER=
set GIT_PASSWORD=

oc create secret generic git-repo-secret --from-literal=username=%GIT_USER% --from-literal=password=%GIT_PASSWORD% --type=kubernetes.io/basic-auth

REM Create the Maven or similar Maven Repository Secret
REM Set Maven Repo to false if you want to skip
set USE_MAVEN_REPO=true
set MAVEN_USER=
set MAVEN_PASSWORD=

oc create secret generic maven-repo-secret --from-literal=maven_username=%MAVEN_USER% --from-literal=maven_password=%MAVEN_PASSWORD%

REM Annotate the Maven Repository Secret with the Maven Repo URL
set MAVEN_REPO_URL=

oc annotate secret maven-repo-secret 'build.openshift.io/source-secret-match-uri-1=%MAVEN_REPO_URL%

REM Link the Maven Repository Secret to the Project Service Accounts
oc secret link sa/default secret/maven-repo-secret --for=pull
oc secret link sa/builder secret/maven-repo-secret
oc secret link sa/deployer secret/maven-repo-secret

REM Create the Build Config for the Builder Image
set BASE_BUILDER_IMAGE=registry.redhat.io/redhat-openjdk-18/openjdk18-openshift
set BUILDER_IMAGE_NAME=

oc new-build --strategy docker --binary --docker-image %BASE_BUILDER_IMAGE% --name %BUILDER_IMAGE_NAME%

REM Start the Build of the Builder Image
oc start-build %BUILDER_IMAGE_NAME% --from-dir . --follow

REM Script finished
echo Create the Builder Image script has completed
echo.
pause










