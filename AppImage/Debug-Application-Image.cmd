@echo off
title Debug the Application Image
cls

REM Set the Launch Path
set LaunchPath=%~dp0
set LaunchPath=%LaunchPath:~0,-1%

REM Set the OpenShift Project
set OPENSHIFT_PROJECT=

REM Set the Application Image
set APPLICATION_IMAGE_NAME=

oc run -i -t application --image=docker-registry.default.svc:5000/%OPENSHIFT_PROJECT%/%APPLICATION_IMAGE_NAME% --command -- bash

REM Script finished
echo Debug the Application Image script has completed
echo Remember to remove the debugging pods after - oc delete dc/application
echo.
pause
