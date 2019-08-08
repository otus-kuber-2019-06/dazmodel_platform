## Домашнее задание №2 - Kubernetes security

### Выполнено ДЗ №2

 - [X] Основное ДЗ

### В процессе сделано:
 - Taks01:
   - Создан Service Account `bob`, ему выдана роль `admin` посредством RoleBinding
   - Создан Sevice Account `dave` без ассайна роли. Не имеет доступа к кластеру
 - Task02:
   - Создан Namespace `prometheus`
   - Создан Sevice Account `carol`, добавлен в Namespace `prometheus`
   - Создана ClusterRole `read-cluster-pods` с правами [ 'get', 'list', 'watch' ] для pod
   - ClusterRole `read-cluster-pods` выдана всем Sevice Accounts в Namespace `prometheus`
 - Task03:
   - Создан Namespace `dev`
   - Создан Sevice Account `jane`, добавлен в Namespace `dev`
   - `admin` ClusterRole выдана Sevice Account `jane` в Namespace `dev`
   - Создан Sevice Account `ken`, добавлен в Namespace `dev`
   - `view` ClusterRole выдана Sevice Account `ken` в Namespace `dev`

### Как запустить проект:
 - В корне проекта выполнить `kubectl apply -f kubernetes-security --recursive  `

### Как проверить работоспособность:
 - task01:
   - `kubectl apply -f kubernetes-security/task01`
   - `kubectl auth can-i get deployments --as system:serviceaccount:default:bob -n default` - expected: `yes`
   - `kubectl auth can-i get deployments --as system:serviceaccount:default:dave -n default` - expected: `no`
 - task02:
   - `kubectl apply -f kubernetes-security/task02`
   - `kubectl auth can-i get pods --as system:serviceaccount:prometheus:carol -n prometheus` - expected: `yes`
   - `kubectl auth can-i get deployments --as system:serviceaccount:default:dave -n default` - expected: `no`
 - task03:
   - `kubectl auth can-i create pods --as system:serviceaccount:dev:jane -n dev` - expected: `yes`
   - `kubectl auth can-i get pods --as system:serviceaccount:dev:ken -n dev` - expected: `yes`
   - `kubectl auth can-i create pods --as system:serviceaccount:dev:ken -n dev` - expected: `no`

### PR checklist:
 - [X] Выставлен label с номером домашнего задания
 - [X] Лектор добавлен в Assignees
