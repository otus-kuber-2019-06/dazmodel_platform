
## Домашнее задание №5 - Kubernetes Storage

### Выполнено ДЗ №5

 - [X] Основное ДЗ
 - [X] Задание со *

### Основное ДЗ: В процессе сделано:

 - CSI Hostpath Driver has been installed: `git clone https://github.com/kubernetes-csi/csi-driver-host-path.git` then `csi-driver-host-path/deploy/kubernetes-1.15/deploy-hostpath.sh`
 - Kind cluster created with "feature-gates": "VolumeSnapshotDataSource=true"
 - Pod, Storage Class and PVC were created and applied to the cluster

### Задание со *: В процессе сделано:

 1. Развернут кластер согласно [k8s cluster in GCP using IaC approach.](../infra/readme.md)
 2. Кластер состоит из 3х мастеров и 2х воркеров. Все ноды работают под ОС Cent OS 7
 3. Виртуальная машина с iscsi-target описана в infra/terraform-infra/iscsi-network.tf и infra/terraform-infra/iscsi-target.tf
 4. Устанавливаем необходимые пакеты на `iscsi-target`:
 ```sh
 ansible-playbook kubernetes-storage/iscsi/ansible/package-iscsi-target.yml
 ```
5. Устанавливаем необходимые пакеты на `worker`:
 ```sh
ansible-playbook kubernetes-storage/iscsi/ansible/package-worker.yml
 ```
 6. Создаем lvm на отдельном диске выделенном под iscsi.
```sh
ansible-playbook kubernetes-storage/iscsi/ansible/lvm.yml
```
7. Создаем lvm на отдельном диске выделенном под iscsi.
```
ansible-playbook kubernetes-storage/iscsi/ansible/lvm.yml
```
8. Создаем хранилище на iscsi-target
```sh
gcloud compute ssh iscsi-target
sudo -i
targetcli
```
```sh
[root@iscsi-target ~]# targetcli
targetcli shell version 2.1.fb46
Copyright 2011-2013 by Datera, Inc and others.
For help on commands, type 'help'.

/>
```
Связываем lvm раздел с блоком в хранилище
```sh
/> cd backstores/
/backstores> block/ create block_data /dev/vg_iscsi/lv_iscsi
Created block storage object block_data using /dev/vg_iscsi/lv_iscsi.
```
создаем iscsi target
```sh
/iscsi> create
Created target iqn.2003-01.org.linux-iscsi.iscsi-target.x8664:sn.42e5cd9958f1.
Created TPG 1.
Global pref auto_add_default_portal=true
Created default portal listening on all IPs (0.0.0.0), port 3260.
```
Пропишем ACLs для worker-нод (смотрим имя iscsi инициатора на worker'ах в /etc/iscsi/initiatorname.iscsi)
```sh
/iscsi/iqn.20...70934e76/tpg1> acls/ create iqn.1994-05.com.redhat:d8f1b17f435
Created Node ACL for iqn.1994-05.com.redhat:d8f1b17f435
/iscsi/iqn.20...70934e76/tpg1> acls/ create iqn.1994-05.com.redhat:4365725d6714
Created Node ACL for iqn.1994-05.com.redhat:4365725d6714
/iscsi/iqn.20...70934e76/tpg1>
```
Создаем Lun
```sh
/iscsi/iqn.20...70934e76/tpg1> luns/ create /backstores/block/block_data
Created LUN 0.
Created LUN 0->0 mapping in node ACL iqn.1994-05.com.redhat:4365725d6714
Created LUN 0->0 mapping in node ACL iqn.1994-05.com.redhat:d8f1b17f435
```
Создаем portal
```sh
/iscsi/iqn.20...70934e76/tpg1> portals/ create ip_address=192.168.0.100 ip_port=3260
Using default IP port 3260
Created network portal 192.168.0.100:3260.
```
Итоговая картина на iscsi-target
```sh
o- / ..................................................................... [...]
  o- backstores .......................................................... [...]
  | o- block .............................................. [Storage Objects: 1]
  | | o- block_data .... [/dev/vg_iscsi/lv_iscsi (10.0GiB) write-thru activated]
  | |   o- alua ............................................... [ALUA Groups: 1]
  | |     o- default_tg_pt_gp ................... [ALUA state: Active/optimized]
  | o- fileio ............................................. [Storage Objects: 0]
  | o- pscsi .............................................. [Storage Objects: 0]
  | o- ramdisk ............................................ [Storage Objects: 0]
  o- iscsi ........................................................ [Targets: 1]
  | o- iqn.2003-01.org.linux-iscsi.iscsi-target.x8664:sn.42e5cd9958f1  [TPGs: 1]
  |   o- tpg1 ........................................... [no-gen-acls, no-auth]
  |     o- acls ...................................................... [ACLs: 2]
  |     | o- iqn.1994-05.com.redhat:4365725d6714 .............. [Mapped LUNs: 1]
  |     | | o- mapped_lun0 ........................ [lun0 block/block_data (rw)]
  |     | o- iqn.1994-05.com.redhat:d8f1b17f435 ............... [Mapped LUNs: 1]
  |     |   o- mapped_lun0 ........................ [lun0 block/block_data (rw)]
  |     o- luns ...................................................... [LUNs: 1]
  |     | o- lun0  [block/block_data (/dev/vg_iscsi/lv_iscsi) (default_tg_pt_gp)]
  |     o- portals ................................................ [Portals: 1]
  |       o- 192.168.0.100:3260 ........................................... [OK]
  o- loopback ..................................................... [Targets: 0]

```
9. Создаем iscsi PersistentVolume
```sh
kubectl apply -f kubernetes-storage/iscsi/iscsi-pv.yaml
```
10. Создаем iscsi PersistentVolumeClaim
```sh
kubectl apply -f kubernetes-storage/iscsi/iscsi-pvc.yaml
```
11. Создаем Pod cо смонтированной директорией /data
```sh
kubectl apply -f kubernetes-storage/iscsi/iscsi-pod.yaml
```
12. Заходим в Pod и пишем данные в /data
```sh
kubectl exec -it iscsi-pod /bin/bash
cd /data
echo "YOHOOOO" > data.txt
```
13. Делаем снапшот LVM раздела на iscsi-target
```sh
gcloud compute ssh iscsi-target
sudo -i
lvcreate --size 10G --snapshot --name snap_lv_iscsi /dev/vg_iscsi/lv_iscsi
```
14. Удаляем данные, pod, pvc, pv, lvm из iscsi
```sh
kubectl exec -it iscsi-pod /bin/bash
rm -rf /data/*
exit
kubectl delete po iscsi-pod
kubectl delete pvc iscsi-pvc
kubectl delete pv iscsi-pv
gcloud compute ssh iscsi-target
sudo -i
targetcli
backstores/block/ delete block_data
```
15. Восстанавливаемся из снапшота
```sh
[root@iscsi-target ~]# lvconvert --merge /dev/vg_iscsi/snap_lv_iscsi
  Merging of volume vg_iscsi/snap_lv_iscsi started.
  vg_iscsi/lv_iscsi: Merged: 100,00%
```
Снова добавляем раздел в хранилище
```
[root@iscsi-target ~]# targetcli
targetcli shell version 2.1.fb46
Copyright 2011-2013 by Datera, Inc and others.
For help on commands, type 'help'.

/> /backstores/block create block_data /dev/vg_iscsi/lv_iscsi
Created block storage object block_data using /dev/vg_iscsi/lv_iscsi.
/> cd iscsi/iqn.2003-01.org.linux-iscsi.iscsi-target.x8664:sn.42e5cd9958f1/
/iscsi/iqn.20....42e5cd9958f1> cd tpg1/
/iscsi/iqn.20...cd9958f1/tpg1> luns/ create /backstores/block/block_data
Created LUN 0.
Created LUN 0->0 mapping in node ACL iqn.1994-05.com.redhat:4365725d6714
Created LUN 0->0 mapping in node ACL iqn.1994-05.com.redhat:d8f1b17f435
/iscsi/iqn.20...cd9958f1/tpg1>
```
Создаем pv, pvc, pod
```sh
kubectl apply -f kubernetes-storage/iscsi/iscsi-pv.yaml
kubectl apply -f kubernetes-storage/iscsi/iscsi-pvc.yaml
kubectl apply -f kubernetes-storage/iscsi/iscsi-pod.yaml
```
Заходим в pod и проверяем есть ли данные
```sh
kubectl exec -it iscsi-pod /bin/bash
root@iscsi-pod:/# cd /data
root@iscsi-pod:/data# ls
data.txt  lost+found
root@iscsi-pod:/data# cat data.txt
YOHOOOO
root@iscsi-pod:/data#
```
Все данные на месте!

### Как запустить проект:

 - В корне проекта выполнить `kind create cluster --config kubernetes-storage/cluster/cluster.yaml `
 - В корне проекта выполнить `kubectl apply -f kubernetes-storage --recursive`
 - ДЗ со * нужно запускать согласно инструкции выше.

### PR checklist:

 - [X] Выставлен label с номером домашнего задания
 - [X] Лектор добавлен в Assignees
 - [X] Выставлен label Review Required