# dazmodel_platform
Sergii Sinienok - Platform repository

# TOC
1. [Домашнее задание №1 - Kubernetes Intro](/kubernetes-intro/home-work-1.md)
2. [Домашнее задание №2 - Kubernetes security](/kubernetes-security/hw-k8s-security.md)
3. [Домашнее задание №3 - Networks](/kubernetes-networks/k8s-networks.md)
3. [Домашнее задание №4 - Volumes](#Домашнее-задание-№4-Kubernetes-Volumes)

## Домашнее задание №4 - Kubernetes Volumes

### Выполнено ДЗ №4

 - [X] Основное ДЗ
 - [X] * Advanced Task

### В процессе сделано:
 - `kind` has been installed via `go get sigs.k8s.io/kind`
 - kind cluster was successfully launched
 - minio stateful set created and launched
 - minio headless service created and launched
 - * minio secert was ceated, stateful set was reconfigured to use it

### Как запустить проект:
 - В корне проекта выполнить `kubectl apply -f kubernetes-volumes --recursive  `

### PR checklist:
 - [X] Выставлен label с номером домашнего задания
 - [X] Лектор добавлен в Assignees
 - [X] Выставлен label Review Required
