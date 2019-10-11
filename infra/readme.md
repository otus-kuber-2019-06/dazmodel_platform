## k8s cluster in GCP using IaC approach.

### Terrafrom

1. Инфраструктура в gcloud описана с помощью terraform (директория infra/terraform_infra).

2. Указываем ссылку на GCP credentials файл в terraform-infra/main.ts (credentials = "${file("../gcp-creds.json")}")

3. Указываем название нашего проекта GCP project в terraform-infra/variables.tf:
```
variable "project" {
  default = "{gcp-project-name}"
}
```

4. Для создания инфраструктуры необходимо выполнить:
```sh
cd terraform_infra/
terraform init
terraform apply
```

5. Параметры которые переодически будут изменяться в целях тестирования (количество узлов кластера, образы ОС ..) вынесены  terraform_infra/variables.tf

6. Переменная с именем проекта используется как системная
```sh
export TF_VAR_project="your-gcloud-project-name"
```

### Ansible dynamic inventory

1. Ansible будет использоваться для развертывания кластера с помощью kubespray и по возможности в домашних заданиях. В связи с тем, что количество узлов кластера будет переодически изменяться, то используется dynamic inventory (Директория - ansible_inventory).

2. Настройку проводим в соответствии с https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html и https://docs.ansible.com/ansible/2.5/scenario_guides/guide_gce.html . Файл настройки плагина `gcp_compute` для Dynamic Inventory выглядит следующим образом:
```yaml
plugin: gcp_compute
projects:
  - {gcp-project-name}
filters: []
groups:
  k8s-cluster: "'controller-' in name or 'worker-' in name"
  kube-master: "'controller-' in name"
  kube-node: "'worker-' in name"
  etcd: "'controller-' in name"
  iscsi-target: "'iscsi-target' in name"
auth_kind: serviceaccount
service_account_file: {gcp-project-creds-file}.json
```

3. Потребуется вынести некоторые данные в системные переменные:
```sh
export GCE_EMAIL="you_email_gcloud"
export GCE_PROJECT="your-gcloud-project-name"
export GCE_CREDENTIALS_FILE_PATH="you_credentials.json"
```

### Configuring SSH Access for Ansible:

1. Create an SSH public/private key pair. The SSH key will be used to programmatically access the GCE VM. On a Mac, you can use the following commands to create a new key pair and copy the public key to the clipboard (DO NOT SPECIFY THE PASSPHRASE FOR KEYS!!! ANSIBLE WILL NOT BE ABLE TO SSH WITH IT):
```sh
ssh-keygen -t rsa -b 4096 -C "ansible"
cat ~/.ssh/ansible.pub | pbcopy
```

2. Add your new public key clipboard contents to the project, on the Compute Engine ⇒ Metadata ⇒ SSH Keys tab.

3. Make sure the following is added to your `ansible.cfg`:
```ini
[defaults]
host_key_checking = False
remote_user = ansible
private_key_file = ~/.ssh/ansible

[ssh_connection]
pipelining = True

[privilege_escalation]
become = True
become_user = root
become_method = sudo
```

4. Test the connection (green output with SUCCES is expected):
```sh
ansible all -m ping
```

### Kubernetes cluster
1. Run `gcloud init` to log in and set up GCP account/project/etc.
2. Создадим системную переменную, которая будет содержать публичный статический адрес,используемый для балансировки нагрузки между мастер-нодами
```sh
export KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe k8s-staticip \
      --region $(gcloud config get-value compute/region) \
      --format 'value(address)')
```
2. Клонируем kubespay рядом с основным проектом
```sh
git clone https://github.com/kubernetes-sigs/kubespray.git
```
3. Добавим публичный адрес в ansible_inventory/group_vars/k8s-cluster/k8s-cluster.yml.
```yaml
supplementary_addresses_in_ssl_keys: ["{{ lookup('env','KUBERNETES_PUBLIC_ADDRESS') }}"]
```
Это необходимо чтобы данный IP был добавлен в сертификаты безопасности.

4. Установите ansible. Руководство: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

5. Разворачиваем  k8s кластер с помощью kubespray
```sh
ansible-playbook ../kubespray/cluster.yml
```
6. Копируем c мастер-ноды /etc/kubernetess/admin.conf на свою машину в ~/.kube/config. Меняем ip адрес в конфиге на тот,что в KUBERNETES_PUBLIC_ADDRESS.

## Troubleshooting

1. While running `ansible-inventory -i inventory.compute.gcp.yml --list`, there's an error message `ERROR! Unexpected Exception, this is probably a bug: 'module' object has no attribute '_vendor'`: modify command to be `ansible-inventory -vvv -i inventory.compute.gcp.yml --list` (add -vvv) and observe an output. Most likely the `cryptography` module is causing an issue, output will contain the following piece:
```python
File "/Library/Python/2.7/site-packages/google/auth/crypt/_cryptography_rsa.py", line 28, in <module>
    import pkg_resources
  File "/System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python/pkg_resources/__init__.py", line 90, in <module>
    packaging = pkg_resources._vendor.packaging
AttributeError: 'module' object has no attribute '_vendor'
```
Run the following to solve:
```sh
pip uninstall cryptography
```

## Useful Reading

1. ["How to Use Ansible Gcp compute inventory plugin"](http://matthieure.me/2018/12/31/ansible_inventory_plugin.html)
2. ["Deploy a Kubernetes Cluster using Kubespray"](https://medium.com/@iamalokpatra/deploy-a-kubernetes-cluster-using-kubespray-9b1287c740ab)
3. ["Getting Started with Red Hat Ansible for Google Cloud Platform"](https://itnext.io/getting-started-with-red-hat-ansible-for-google-cloud-platform-fa666c42a00c)
4. ["GCP Operating System images"](https://cloud.google.com/compute/docs/images)
5. ["Ansible - Privilege Escalation Settings"](https://docs.ansible.com/ansible/2.4/intro_configuration.html#privilege-escalation-settings)