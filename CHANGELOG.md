# Changelog

## 2.3.1
* fix: Add ignore on update lifecycle on volume claim templates
* fix: Update variable type and description of additionnal ingress paths

## 2.3.0

* feat: Add additional ingress path
* chore: bump pre-commit-terraform to 1.31.0

## 2.2.0

* feat: Add possibility to mount the service account token in the pod.
* fix: Link service account to pod template

## 2.1.0

* maintenance: Set default version of the docker image to 3.38.0

## 2.0.1

* fix: Fix healthcheck path

## 2.0.0

* refactoring: (BREAKING) Complete rehaul of the module.

## 1.1.0

* Feat: Add explicit dependancy on ingress
* Feat: Now run test on kind

## 1.0.2

* Add sleep after namespace to fix non availability issue

## 1.0.1

* Fix rolebinding namespace issue

## 1.0.0

* Conversion to terraform 0.12
* Add namespace creation
