@echo off
title Debug the Builder Image
cls

REM Set the Launch Path
set LaunchPath=%~dp0
set LaunchPath=%LaunchPath:~0,-1%

REM Set the OpenShift Project
set OPENSHIFT_PROJECT=

REM Set the Builder Image
set BUILDER_IMAGE_NAME=

oc run -i -t builder --image=docker-registry.default.svc:5000/%OPENSHIFT_PROJECT%/%BUILDER_IMAGE_NAME% --command -- bash

REM Script finished
echo Debug the Builder Image script has completed
echo Remember to remove the debugging pods after - oc delete dc/builder
echo.
pause
