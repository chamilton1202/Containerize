#!/bin/bash
### Debug the Application Image

### Set the Launch Path
LaunchPath=$(pwd)

### Set the OpenShift Project
OPENSHIFT_PROJECT=

### Set the Application Image
APPLICATION_IMAGE_NAME=

if [[ -z "${OPENSHIFT_PROJECT}" ] && [ -z "${APPLICATION_IMAGE_NAME}" ]]; then
    oc run -i -t application --image=docker-registry.default.svc:5000/${OPENSHIFT_PROJECT}/${APPLICATION_IMAGE_NAME} --command -- bash
fi

### Script finished
echo "Debug the Application Image script has completed"
echo "Remember to remove the debugging pods after - oc delete dc/application"
echo.
pause
