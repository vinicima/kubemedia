# Kubernetes NFS-Client Provisioner

[![Docker Repository on Quay](https://quay.io/repository/external_storage/nfs-client-provisioner/status "Docker Repository on Quay")](https://quay.io/repository/external_storage/nfs-client-provisioner)

**nfs-client** is an automatic provisioner that use your *existing and already configured* NFS server to support dynamic provisioning of Kubernetes Persistent Volumes via Persistent Volume Claims. Persistent volumes are provisioned as ``${namespace}-${pvcName}-${pvName}``.

#Projeto Coletado do repositorio https://github.com/kubernetes-incubator/external-storage

# Como implantar NFS-cliente para o cluster.

Para observar novamente, você deve ter * * Já um servidor NFS.

** Etapa 1: Obtenha informações de conexão para seu servidor NFS **. Certifique-se de que seu servidor NFS esteja acessível em seu cluster do Kubernetes e obtenha as informações necessárias para se conectar a ele. No mínimo, você precisará do seu nome de host.

** Etapa 2: Obtenha os arquivos do NFS-Client Provisioner **. Para configurar o provedor, você fará o download do conjunto de arquivos YAML, editá-los para adicionar as informações de conexão do servidor NFS e, em seguida, aplicar cada um com o comando `` oc``.

Obtenha todos os arquivos no diretório [deploy] (https://steps.everis.com/git/MAPFRE/PAP/edit/master/dynamic-storage/nfs-client/deploy) deste repositório.

** Etapa 3: autorização de configuração **. Se o seu cluster tiver o RBAC ativado ou você estiver executando o OpenShift, deverá autorizar o provisionador. Se você estiver em um namespace / projeto diferente de "default", edite o `deploy / rbac.yaml`.
Kubernetes:

```sh
# Set the subject of the RBAC objects to the current namespace where the provisioner is being deployed
$ NAMESPACE=`oc project -q`
$ sed -i'' "s/namespace:.*/namespace: $NAMESPACE/g" ./deploy/rbac.yaml
$ kubectl create -f deploy/rbac.yaml
```

OpenShift:

Em algumas instalações do OpenShift, o usuário administrador padrão não possui permissões de administrador de cluster. Se esses comandos falharem, consulte a documentação do OpenShift para ** Gerenciamento de usuários e funções ** ou entre em contato com seu provedor OpenShift para ajudá-lo a conceder as permissões corretas para seu usuário administrador.

```sh
# Set the subject of the RBAC objects to the current namespace where the provisioner is being deployed
$ NAMESPACE=`oc project -q`
$ sed -i'' "s/namespace:.*/namespace: $NAMESPACE/g" ./deploy/rbac.yaml
$ oc create -f deploy/rbac.yaml
$ oadm policy add-scc-to-user hostmount-anyuid system:serviceaccount:$NAMESPACE:nfs-client-provisioner
```

**Step 4: Configure the NFS-Client provisioner**

Nota: Para implantar use `deploy / deployment.yaml`.

Em seguida, você deve editar o arquivo de implantação do provedor para adicionar informações de conexão ao seu servidor NFS. Edite o `deploy / deployment.yaml` e substitua as duas ocorrências de <YOUR NFS SERVER HOSTNAME> pelo hostname do seu servidor.
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nfs-client-provisioner
---
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: nfs-client-provisioner
spec:
  replicas: 1
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: nfs-client-provisioner
    spec:
      serviceAccountName: nfs-client-provisioner
      containers:
        - name: nfs-client-provisioner
          image: quay.io/external_storage/nfs-client-provisioner:latest
          volumeMounts:
            - name: nfs-client-root
              mountPath: /persistentvolumes #Não alterar, metadados e deve ser este valor
          env:
            - name: PROVISIONER_NAME
              value: nfs.mpfr.com.br #Nome do cluster e path
            - name: NFS_SERVER
              value: 10.244.0.1 # IP do NFS_SERVER
            - name: NFS_PATH
              value: /exports # Exports do NFS
      volumes:
        - name: nfs-client-root
          nfs:
            server: 10.244.0.1 #IP do NFS_SERVER
            path: /exports #Exports do NFS_SERVER
```

Você também pode querer mudar o PROVISION_NAME acima de `` nfs.mpfr.com.br`` para algo mais descritivo como `` nfs-storage``, mas se você lembrar do PROVISIONER_NAME na definição de classe de armazenamento abaixo :

Este é `implantar / class.yaml` que define Kubernetes Storage Class da NFS-Cliente:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: managed-nfs-storage
provisioner: nfs.mpfr.com.br # Deve ser o mesmo nome do arquivo deployment na variavel PROVISIONER_NAME - 'env PROVISIONER_NAME'
parameters:
  archiveOnDelete: "false"
```

** Step 5: Definindo o Storage Class como default **
Nome do Storage Class em questão é managed-nfs-storage
```sh
  kubectl patch storageclass managed-nfs-storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

**Step 6: Finally, test your environment!**

Agora vamos testar sua provisão de NFS.

Deploy:

```sh
$ kubectl create -f deploy/test-claim.yaml -f deploy/test-pod.yaml
```

Agora verifique seu servidor NFS para o arquivo `SUCCESS`.

```sh
kubectl delete -f deploy/test-pod.yaml -f deploy/test-claim.yaml
```

Agora, verifique se a pasta foi excluída.

** Etapa 7: Implantando seus próprios PersistentVolumeClaims **. Para implantar seu próprio PVC, certifique-se de ter a `storage-class` correta, conforme indicado pelo seu arquivo` deploy / class.yaml`.
For example:

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim
  annotations:
    volume.beta.kubernetes.io/storage-class: "managed-nfs-storage"
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Mi
```


