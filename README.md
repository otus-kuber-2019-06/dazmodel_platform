# dazmodel_platform
Sergii Sinienok - Platform repository

# TOC
1. [Домашнее задание №1](#Домашнее-задание-№1)

## Домашнее задание №1

### Выполнено ДЗ №1

 - [X] Основное ДЗ

### В процессе сделано:
 - Установлен *kubectl* при помощи Homebrew - `brew install kubernetes-cli`. 
    ```
    kubectl version                                                       (:|✔)
    Client Version: version.Info{Major:"1", Minor:"12+", GitVersion:"v1.12.8-dispatcher", GitCommit:"1215389331387f57594b42c5dd024a2fe27334f8", GitTreeState:"clean", BuildDate:"2019-05-13T18:18:50Z", GoVersion:"go1.10.8", Compiler:"gc", Platform:"darwin/amd64"}
    Unable to connect to the server: dial tcp 192.168.99.100:8443: i/o timeout
    ```
 - Настроен Kubectl Autocomplete для ZSH:
    ```
    source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell
    echo "if [ $commands[kubectl] ]; then source <(kubectl completion zsh); fi" >> ~/.zshrc # add autocomplete permanently to your zsh shell
    ```
 - Установлен *VirtualBox* через Homebrew - `brew cask install virtualbox`
 - Установлен *minicube* через Homebrew - `brew cask install minikube`
    ```
    minikube start                                                                    (:|✔)
    😄  minikube v1.2.0 on darwin (amd64)
    💡  Tip: Use 'minikube start -p <name>' to create a new cluster, or 'minikube delete' to delete this one.
    🔄  Restarting existing virtualbox VM for "minikube" ...
    ⌛  Waiting for SSH access ...
    🐳  Configuring environment for Kubernetes v1.15.0 on Docker 18.09.6
    🔄  Relaunching Kubernetes v1.15.0 using kubeadm ...
    ⌛  Verifying: apiserver proxy etcd scheduler controller dns
    🏄  Done! kubectl is now configured to use "minikube"
    ```
 - Посмотрел информацию по поднятому k8s кластеру
    ```
    kubectl cluster-info                                                                                                                                                                                                                (:|✔)
    Kubernetes master is running at https://192.168.99.100:8443
    KubeDNS is running at https://192.168.99.100:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
    ```
 - Установлен *Dashboard*. Гайд по генерации JWT для логина: https://github.com/kubernetes/dashboard/wiki/Creating-sample-user
    <br/>
    <details><summary>Результат</summary>
    <p>
    ```
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta1/aio/deploy/recommended.yaml                                                                                                                    (:|✔)
    namespace/kubernetes-dashboard created
    serviceaccount/kubernetes-dashboard created
    service/kubernetes-dashboard created
    secret/kubernetes-dashboard-certs created
    secret/kubernetes-dashboard-csrf created
    secret/kubernetes-dashboard-key-holder created
    configmap/kubernetes-dashboard-settings created
    role.rbac.authorization.k8s.io/kubernetes-dashboard created
    clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
    rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
    clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
    deployment.apps/kubernetes-dashboard created
    service/dashboard-metrics-scraper created
    deployment.apps/kubernetes-metrics-scraper created
    ```
    </p>
    </details>
    <br/>
 - Установлен k9s - `brew install derailed/k9s/k9s`
 - Успешно приконнектился по SSH к виртуальной машине minikube:
    <br/>
    <details><summary>Результат</summary>
    <p>
    ```
        minikube ssh                                                                                                                                                                                                                        (:|✔)
                            _             _            
                _         _ ( )           ( )           
    ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __  
    /' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
    | ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
    (_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

    $ docker ps
    CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS              PORTS               NAMES
    024dc749f4cc        kubernetesui/metrics-scraper   "/metrics-sidecar"       About an hour ago   Up About an hour                        k8s_kubernetes-metrics-scraper_kubernetes-metrics-scraper-86456cdd8f-9bxm4_kubernetes-dashboard_8c3fe82c-c9a5-41ba-ab07-a4a9f2904e17_0
    7ced44e4bd96        kubernetesui/dashboard         "/dashboard --insecu…"   About an hour ago   Up About an hour                        k8s_kubernetes-dashboard_kubernetes-dashboard-5c8f9556c4-z98ll_kubernetes-dashboard_ea51f79b-96cf-45d5-b107-047c3ee3db54_0
    2def2f541249        k8s.gcr.io/pause:3.1           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kubernetes-metrics-scraper-86456cdd8f-9bxm4_kubernetes-dashboard_8c3fe82c-c9a5-41ba-ab07-a4a9f2904e17_0
    e93bf4ff220b        k8s.gcr.io/pause:3.1           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kubernetes-dashboard-5c8f9556c4-z98ll_kubernetes-dashboard_ea51f79b-96cf-45d5-b107-047c3ee3db54_0
    4dccba57af0e        4689081edb10                   "/storage-provisioner"   About an hour ago   Up About an hour                        k8s_storage-provisioner_storage-provisioner_kube-system_f654d832-ab0f-4f78-8d11-e52c9eb720d5_1
    d820541549ed        eb516548c180                   "/coredns -conf /etc…"   About an hour ago   Up About an hour                        k8s_coredns_coredns-5c98db65d4-9f2sd_kube-system_dd81902d-511d-4478-b503-30bc1eabaed1_1
    0d4833c3c08c        eb516548c180                   "/coredns -conf /etc…"   About an hour ago   Up About an hour                        k8s_coredns_coredns-5c98db65d4-8mp8f_kube-system_2d197c6d-6bdb-409c-ac88-0d1ccc21a4d5_1
    1fe9d36d6e21        k8s.gcr.io/pause:3.1           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_storage-provisioner_kube-system_f654d832-ab0f-4f78-8d11-e52c9eb720d5_1
    15cd1d687a2c        k8s.gcr.io/pause:3.1           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_coredns-5c98db65d4-9f2sd_kube-system_dd81902d-511d-4478-b503-30bc1eabaed1_1
    2785c8376330        k8s.gcr.io/pause:3.1           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_coredns-5c98db65d4-8mp8f_kube-system_2d197c6d-6bdb-409c-ac88-0d1ccc21a4d5_1
    18100a3dcb66        d235b23c3570                   "/usr/local/bin/kube…"   About an hour ago   Up About an hour                        k8s_kube-proxy_kube-proxy-vsbjg_kube-system_a23eeedf-fc2b-4680-9514-1126fb96346f_1
    798e9906cbaf        k8s.gcr.io/pause:3.1           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-proxy-vsbjg_kube-system_a23eeedf-fc2b-4680-9514-1126fb96346f_1
    ef0bf9692484        2c4adeb21b4f                   "etcd --advertise-cl…"   About an hour ago   Up About an hour                        k8s_etcd_etcd-minikube_kube-system_89f36d1de777528a3e8b9a2534a41af4_1
    02d64c8d7ea3        2d3813851e87                   "kube-scheduler --bi…"   About an hour ago   Up About an hour                        k8s_kube-scheduler_kube-scheduler-minikube_kube-system_31d9ee8b7fb12e797dc981a8686f6b2b_3
    c2910113e4b8        8328bb49b652                   "kube-controller-man…"   About an hour ago   Up About an hour                        k8s_kube-controller-manager_kube-controller-manager-minikube_kube-system_676a8a1e3e146d0c0f7c4f6e1e96b578_2
    4e278a728c9f        119701e77cbc                   "/opt/kube-addons.sh"    About an hour ago   Up About an hour                        k8s_kube-addon-manager_kube-addon-manager-minikube_kube-system_65a31d2b812b11a2035f37c8a742e46f_1
    45aee4c9ad76        201c7a840312                   "kube-apiserver --ad…"   About an hour ago   Up About an hour                        k8s_kube-apiserver_kube-apiserver-minikube_kube-system_e0f883122ef4b18e9fbea5c005bca446_1
    634f1aecaff0        k8s.gcr.io/pause:3.1           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-scheduler-minikube_kube-system_31d9ee8b7fb12e797dc981a8686f6b2b_1
    585936e3057f        k8s.gcr.io/pause:3.1           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-controller-manager-minikube_kube-system_676a8a1e3e146d0c0f7c4f6e1e96b578_1
    fd59a861af68        k8s.gcr.io/pause:3.1           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-apiserver-minikube_kube-system_e0f883122ef4b18e9fbea5c005bca446_1
    c02a86777b61        k8s.gcr.io/pause:3.1           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_etcd-minikube_kube-system_89f36d1de777528a3e8b9a2534a41af4_1
    478717856c4b        k8s.gcr.io/pause:3.1           "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-addon-manager-minikube_kube-system_65a31d2b812b11a2035f37c8a742e46f_1
    $
    ```
    </p>
    </details>
    <br/>
 - Проверки кластера Kubernetes на отказоустойчивость:
    <br/>
    <details><summary>Результат</summary>
    <p>
    ```
    docker rm -f $(docker ps -a -q)
    024dc749f4cc
     .....
    530f58cf8b7e

    kubectl get pods -n kube-system                                                                                                                                                                                                     (:|✔)
    NAME                               READY   STATUS    RESTARTS   AGE
    coredns-5c98db65d4-8mp8f           1/1     Running   0          2d
    coredns-5c98db65d4-9f2sd           1/1     Running   0          2d
    etcd-minikube                      1/1     Running   0          2d
    kube-addon-manager-minikube        1/1     Running   0          2d
    kube-apiserver-minikube            1/1     Running   0          2d
    kube-controller-manager-minikube   1/1     Running   0          2d
    kube-proxy-vsbjg                   1/1     Running   0          2d
    kube-scheduler-minikube            1/1     Running   0          2d
    storage-provisioner                1/1     Running   1          2d

    kubectl delete pod --all -n kube-system                                                                                                                                                                                             (:|✔)
    pod "coredns-5c98db65d4-8mp8f" deleted
    pod "coredns-5c98db65d4-9f2sd" deleted
    pod "etcd-minikube" deleted
    pod "kube-addon-manager-minikube" deleted
    pod "kube-apiserver-minikube" deleted
    pod "kube-controller-manager-minikube" deleted
    pod "kube-proxy-vsbjg" deleted
    pod "kube-scheduler-minikube" deleted
    pod "storage-provisioner" deleted

    kubectl get componentstatuses                                                                                                                                                                                                       (:|✔)
    NAME                 STATUS    MESSAGE             ERROR
    scheduler            Healthy   ok                  
    controller-manager   Healthy   ok                  
    etcd-0               Healthy   {"health":"true"}
    ```
    </p>
    </details>
    <br/>
 - Причины восстановления pods в namespace kube-system:
    - kube-addon-manager, etcd-minikube, kube-apiserver-minikube, kube-controller-manager-minikube, kube-scheduler-minikube -  сконфигурированы как static pods, запускаются и рестартится через Systemd Service операционной системы:
    <br/>
    <details><summary>Результат</summary>
    <p>
        ```
        systemctl show kubelet | grep ExecStart
        ExecStart={ path=/usr/bin/kubelet ; argv[]=/usr/bin/kubelet --authorization-mode=Webhook --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --cgroup-driver=cgroupfs --client-ca-file=/var/lib/minikube/certs/ca.crt --cluster-dns=10.96.0.10 --cluster-domain=cluster.local --container-runtime=docker --fail-swap-on=false --hostname-override=minikube --kubeconfig=/etc/kubernetes/kubelet.conf --pod-manifest-path=/etc/kubernetes/manifests ; ignore_errors=no ; start_time=[Wed 2019-07-10 18:13:34 UTC] ; stop_time=[n/a] ; pid=3043 ; code=(null) ; status=0/0 }

        $ cd /etc/kubernetes/manifests
        $ ls -la
        total 20
        drwxr-xr-x 2 root root    0 Jul 10 18:13 .
        drwxr-xr-x 4 root root    0 Jul 10 18:13 ..
        -rw-r----- 1 root root 1406 Jul 10 18:13 addon-manager.yaml.tmpl
        -rw------- 1 root root 1971 Jul 10 18:13 etcd.yaml
        -rw------- 1 root root 2895 Jul 10 18:13 kube-apiserver.yaml
        -rw------- 1 root root 2264 Jul 10 18:13 kube-controller-manager.yaml
        -rw------- 1 root root  990 Jul 10 18:13 kube-scheduler.yaml
        ```
    </p>
    </details>
    <br/>
    - coredns - всегда восстанавливается в количестве 2х штук потому, что управляется через Deployment, который создает соответствующий ReplicaSet:
    <br/>
    <details><summary>Результат</summary>
    <p>
        ```
        kubectl get deployment  -n kube-system                                    (kubernetes-intro|✚1…)
        NAME      READY   UP-TO-DATE   AVAILABLE   AGE
        coredns   2/2     2            2           2d
        ```
    </p>
    </details>
    <br/>
    - kube-proxy - всегда восстанавливается потому, что управляется DaemonSet controller:
    <br/>
    <details><summary>Результат</summary>
    <p>
        ```
        kubectl get ds -n kube-system                                             (kubernetes-intro|✚1…)
        NAME         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR                 AGE
        kube-proxy   1         1         1       1            1           beta.kubernetes.io/os=linux   2d
        ```
    </p>
    </details>
    <br/>
    - storage-provisioner - addon, его yaml определение лежит в /etc/kubernetes/addons и восстанавливается оттуда
 - Сделан Dockerfile с Nginx внутри как веб-сервер. Была проблема с запуском nginx под нерутовым юзером, этот гайд помог решить http://pjdietz.com/2016/08/28/nginx-in-docker-without-root.html. Docker Image опубликован на DockerHub https://hub.docker.com/r/debugss/k8s-infrastructure-platform/tags
 - 

### Как запустить проект:
 - Например, запустить команду X в директории Y

### Как проверить работоспособность:
 - Например, перейти по ссылке http://localhost:8080

### PR checklist:
 - [ ] Выставлен label с номером домашнего задания
 - [ ] Лектор добавлен в Assignees


### Выполнено
- Развернут minikube ( https://kubernetes.io/docs/tasks/tools/install-minikube/ );
- Добавлен Dashboard (команда `minikube addons enable dashboard`, зайти в панель - команда `minikube dashboard`);
- Установлен k9s ( https://k9ss.io );
- Проверено, что контейнеры восстанавливаются после удаления;
- Создан Dockerfile, который запускает http сервер на 8000 порту под пользователем с uid 1001 (сделал на python); 
- Написан манифест web-pod.yaml;
- Выполнен деплой пода web и init контейнера;
- Опробован в работе kube-forwarder (https://kube-forwarder.pixelpoint.io ).


### Ответы на вопросы
1. `kube-apiserver` запускается и рестартится через Systemd Service операционной системы, а `coredns` - контролируется самим k8s через ReplicaSet;

### Полезное
Команды:
- `minikube start` - старт minikube;
- `minikube ssh` - войти на виртуальную машину minikube по ssh;
- `kubectl cluster-info` - проверка подключения к кластеру;
- `kubectl get pods -n kube-system` - показать все pods в namespace `kube-system`;
- `kubectl get cs` - показать состояние кластера;
- `kubectl get ...` - показать ресурсы;
- `kubectl describe ...` - показать детальную информацию о конктретном ресурсе;
- `kubectl logs ...` - показать логи контейнера в поде;
- `kubectl exec ...` - выполнить команду в контейнере в поде;
- `kubectl apply -f file.yaml` - применить манифест;
- `kubectl get pod web -o yaml` - получить манифест уже запущенного pod;
- `kubectl port-forward --address 0.0.0.0 pod/web 8000:8000` - редирект порта (в примере 8000);

