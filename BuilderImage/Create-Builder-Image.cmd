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
set CREATE_OPENSHIFT_PROJECT=true
set OPENSHIFT_PROJECT=

if /I "%CREATE_OPENSHIFT_PROJECT%" EQU "false" goto CreateRHSecret
oc new-project %OPENSHIFT_PROJECT%

:CreateRHSecret
REM Create the Red Hat Service Account Secret and link to the Project Service Accounts
set USE_RH_SECRET=true
REM Path to YAML
set RH_SERVICE_SECRET_YAML=
REM Secret Name in the file
set RH_SERVICE_SECRET=

if /I "%USE_RH_SECRET%" EQU "false" goto CreateGitSecret
oc create -f %RH_SERVICE_SECRET_YAML%
oc secret link sa/default secret/%RH_SERVICE_SECRET% --for=pull
oc secret link sa/builder secret/%RH_SERVICE_SECRET%

:CreateGitSecret
REM Create the GitHub or similar Git Repository Secret
REM Set Git Repo to false if you want to skip
set USE_GIT_REPO=true
set GIT_USER=
set GIT_PASSWORD=

if /I "%USE_GIT_REPO%" EQU "false" goto CreateMavenSecret
oc create secret generic git-repo-secret --from-literal=username=%GIT_USER% --from-literal=password=%GIT_PASSWORD% --type=kubernetes.io/basic-auth

:CreateMavenSecret
REM Create the Maven or similar Maven Repository Secret
REM Set Maven Repo to false if you want to skip
set USE_MAVEN_REPO=true
set MAVEN_USER=
set MAVEN_PASSWORD=

if /I "%USE_MAVEN_REPO%" EQU "false" goto CreateBuildConfig
oc create secret generic maven-repo-secret --from-literal=maven_username=%MAVEN_USER% --from-literal=maven_password=%MAVEN_PASSWORD%

REM Annotate the Maven Repository Secret with the Maven Repo URL
set MAVEN_REPO_URL=

oc annotate secret maven-repo-secret 'build.openshift.io/source-secret-match-uri-1=%MAVEN_REPO_URL%

REM Link the Maven Repository Secret to the Project Service Accounts
oc secret link sa/default secret/maven-repo-secret --for=pull
oc secret link sa/builder secret/maven-repo-secret
oc secret link sa/deployer secret/maven-repo-secret

:CreateBuildConfig
REM Create the Build Config for the Builder Image
set CREATE_BUILD_CONFIG=true
set BASE_BUILDER_IMAGE=registry.redhat.io/redhat-openjdk-18/openjdk18-openshift
set BUILDER_IMAGE_NAME=

if /I "%CREATE_BUILD_CONFIG%" EQU "false" goto StartBuild
oc new-build --strategy docker --binary --docker-image %BASE_BUILDER_IMAGE% --name %BUILDER_IMAGE_NAME%

:StartBuild
REM Start the Build of the Builder Image
oc start-build %BUILDER_IMAGE_NAME% --from-dir . --follow

REM Script finished
echo Create the Builder Image script has completed
echo.
pause










