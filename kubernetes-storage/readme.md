
## Домашнее задание №5 - Kubernetes Storage

### Выполнено ДЗ №5

 - [X] Основное ДЗ
 - [ ] Задание со *

### Основное ДЗ: В процессе сделано:

 - CSI Hostpath Driver has been installed: `git clone https://github.com/kubernetes-csi/csi-driver-host-path.git` then `csi-driver-host-path/deploy/kubernetes-1.15/deploy-hostpath.sh`
 - Kind cluster created with "feature-gates": "VolumeSnapshotDataSource=true"
 - Pod, Storage Class and PVC were created and applied to the cluster

### Задание со *: В процессе сделано:

 1. Развернут кластер согласно [k8s cluster in GCP using IaC approach.](../infra/readme.md)

### Как запустить проект:

 - В корне проекта выполнить `kind create cluster --config kubernetes-storage/cluster/cluster.yaml `
 - В корне проекта выполнить `kubectl apply -f kubernetes-storage --recursive  `

### PR checklist:

 - [X] Выставлен label с номером домашнего задания
 - [X] Лектор добавлен в Assignees
 - [X] Выставлен label Review Required