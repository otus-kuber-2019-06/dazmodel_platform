# dazmodel_platform
Sergii Sinienok - Platform repository

# TOC
1. [Домашнее задание №1 - Kubernetes Intro](/kubernetes-intro/home-work-1.md)
2. [Домашнее задание №2 - Kubernetes security](/kubernetes-security/hw-k8s-security.md)
3. [Домашнее задание №3 - Networks](#Домашнее-задание-№3-Kubernetes-Networking)

## Домашнее задание №3 - Kubernetes Networking

### Выполнено ДЗ №3

 - [ ] Основное ДЗ
 - [X] Самостоятельная работа
 - [X] * Advanced Task

### В процессе сделано:
 - ReadinessProbe was added to kubernetes-intro/web-pod.yaml.
 - Web Deploy Deployment was created. readinessProbe was fixed for the container.
 - `kubespy` was installled.
 - have been playing with deployment's `strategy` for a while.
 - ClusterIP Service was created and verified.
 - IPVS was enabled, was able to ping service IP successfully!!!
 - MetalLB was successfully installed and configured. The service is avasilable from within my host OS. SUCCESS!!!
 - * CoreDNS services for UPD and TCP were sucessfully deployed. Check: `nslookup kubernetes.default.svc.cluster.local. 172.17.255.10`
 - Ingress rules along with hedless service was successfully added, configured and tested.
 - ** Canary deployemtn was configured using Ingress.

### Как запустить проект:
 - В корне проекта выполнить `kubectl apply -f kubernetes-networks --recursive  `

### PR checklist:
 - [X] Выставлен label с номером домашнего задания
 - [X] Лектор добавлен в Assignees
