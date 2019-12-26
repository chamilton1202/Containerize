#!/bin/bash
### Debug the Builder Image

### Set the Launch Path
LaunchPath=$(pwd)

### Set the OpenShift Project
OPENSHIFT_PROJECT=

### Set the Builder Image
BUILDER_IMAGE_NAME=

if [[ -z "${OPENSHIFT_PROJECT}" ] && [ -z "${BUILDER_IMAGE_NAME}" ]]; then
    oc run -i -t builder --image=docker-registry.default.svc:5000/${OPENSHIFT_PROJECT}/${BUILDER_IMAGE_NAME} --command -- bash
fi

### Script finished
echo "Debug the Builder Image script has completed"
echo "Remember to remove the debugging pods after - oc delete dc/builder"
echo.
pause
