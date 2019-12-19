# Containerize
The purpose of this repository is to aid in the containerization of applications as part of a migration project to a Kubernetes based platform such as OpenShift.  While the
focus of this repository has OpenShift concepts the same approach and conversion techniques could be used to create native k8s objects and resources.

## AppImage
This directory contains the items needed to build an Application Image from a Builder Image.  The Builder Image could be any Image from a vendor or a Custom Builder Image.
The details about building a Custom Builder Image are detailed below.

## BuilderImage
This section contains the items needed to build a Custom Builder Image off of an existing Builder Image or just creating one from scratch.  The Builder Image is designed to be used as a Base for any Application Images that need to be created.
