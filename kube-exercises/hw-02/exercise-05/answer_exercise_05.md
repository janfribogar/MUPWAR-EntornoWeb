# [MPWAR] - Entorno Web
## Entregable 2 - Ejercicio 5

<br>

### Diseña una estrategia de despliegue que se base en ”Blue Green”. Podéis utilizar la imagen del ejercicio 1.

<br>

> <br>
> Respuestas:
> <br>
> <br>

<br>

_- deployment_blue.yaml:_

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-v1
  labels:
    app: nginx-v1
    release: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-v1
  template:
    metadata:
      labels:
        app: nginx-v1
    spec:
      containers:
      - name: nginx-v1
        image: nginx:1.19.4-alpine
        ports:
        - containerPort: 80
```

_- Despliegue del deployment productivo (blue) en kubernetes:_

```
kubectl apply -f deployment_blue.yaml
```

_- service_pro.yaml:_

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc-blue
spec:
  type: NdePort
  selector:
    app: nginx-v1
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80
    nodePort: 30100
```

_- Despliegue del servicio productivo (blue) en kubernetes:_

```
kubectl apply -f service_blue.yaml 
```

_- Revisamos los endpoints del servicio para comprobar su correcto funcionamiento:_

```
kubectl get endpoints nginx-svc-blue
```

Resultado:

```
NAME             ENDPOINTS                                   AGE
nginx-svc-blue   172.17.0.7:80,172.17.0.8:80,172.17.0.9:80   39s
```

_- Revisamos la ip de minikube para ir a ver en el navegador si funciona nuestro nginx (en el puerto 30100) productivo (blue):_

```
minikube ip
```

Resultado:

```
192.168.49.2
```

Ahora ya tenemos nuestra aplicación de producción (blue) con la versión de nginx 1.19.4-alpine visible en el puerto 30100 (Puerto de producción). Verificamos en el navegador (http://192.168.49.2:30100).

_- deployment_green.yaml:_

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-v2
  labels:
    app: nginx-v2
    release: green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-v2
  template:
    metadata:
      labels:
        app: nginx-v2
    spec:
      containers:
      - name: nginx-v2
        image: nginx:1.19.5-alpine
        ports:
        - containerPort: 80
```

_- Despliegue del deployment pre-productivo (green) en kubernetes:_

```
kubectl apply -f deployment_green.yaml
```

_- service_green.yaml:_

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc-green
spec:
  type: NodePort
  selector:
    app: nginx-v2
  ports:
  - protocol: TCP
    port: 8081
    targetPort: 80
    nodePort: 30101
```

_- Despliegue del servicio pre-productivo (green) en kubernetes:_

```
kubectl apply -f service_green.yaml 
```

_- Revisamos los endpoints del servicio para comprobar su correcto funcionamiento:_

```
kubectl get endpoints nginx-svc-green
```

Resultado:

```
NAME              ENDPOINTS                                      AGE
nginx-svc-green   172.17.0.10:80,172.17.0.11:80,172.17.0.12:80   43s
```

_- Revisamos la ip de minikube para ir a ver en el navegador si funciona nuestro nginx (en el puerto 30101) pre-productivo (green):_

```
minikube ip
```

Resultado:

```
192.168.49.2
```

Ahora ya tenemos nuestra aplicación de pre-producción (green) con la versión de nginx 1.19.5-alpine visible en el puerto 30101 (Puerto de pre-producción). Verificamos en el navegador (http://192.168.49.2:30101).
De esta manera se puede testear la aplicación hasta que se de el visto bueno para pasar a la siguiente versión en producción (blue).

_- Cambio del servicio de producción (blue) para apuntar a la nueva versión de la aplicación de pre-producción (green):_

```
kubectl patch service nginx-svc-blue -p '{"spec":{"selector":{"app": "nginx-v2"}}}'
```

_- Revisamos los endpoints del servicio para comprobar su correcto funcionamiento:_

```
kubectl get endpoints nginx-svc-blue
```

Resultado:

```
NAME              ENDPOINTS                                      AGE
nginx-svc-green   172.17.0.10:80,172.17.0.11:80,172.17.0.12:80   43s
```

Ahora observamos las IPs de los 3 pods marcados como "green" que ya tienen la versión nginx 1.19.5-alpine dentro del servicio de producción.
Ya tenemos nuestra aplicación de pre-producción (green) con la versión de nginx 1.19.5-alpine visible en el puerto 30100 (Puerto de producción). Verificamos en el navegador (http://192.168.49.2:30101).

_- Eliminar deployment de la version de producción (blue) anterior (v1):_

```
kubectl delete deploy nginx-v1
```

_- Por último, marcamos como blue la versión actual en la etiqueta que habiamos creado para ello en el .yaml en metadata>label>"release" ya que esta nueva versión v2 pasa a ser la estable de producción:_

```
kubectl patch deploy nginx-v2 -p '{"metadata":{"labels":{"release": "blue"}}}'
```

_- Revisión del estado final del deployment:_

```
kubectl describe deploy nginx-v2
```

Resultado:

```
Name:                   nginx-v2
Namespace:              default
CreationTimestamp:      Sat, 23 Jan 2021 11:32:19 +0100
Labels:                 app=nginx-v2
                        release=blue
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx-v2
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx-v2
  Containers:
   nginx-v2:
    Image:        nginx:1.19.5-alpine
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-v2-746b846fc (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  16m   deployment-controller  Scaled up replica set nginx-v2-746b846fc to 3
```

_- Revisión del estado final de uno de los pods:_

```
kubectl describe pod nginx-v2-746b846fc-XXXXX
```

Resultado:

```
Name:         nginx-v2-746b846fc-4lc86
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Sat, 23 Jan 2021 11:32:19 +0100
Labels:       app=nginx-v2
              pod-template-hash=746b846fc
Annotations:  <none>
Status:       Running
IP:           172.17.0.12
IPs:
  IP:           172.17.0.12
Controlled By:  ReplicaSet/nginx-v2-746b846fc
Containers:
  nginx-v2:
    Container ID:   docker://47b03135f648170f3eb983d7c4673b4f3ab4315ebfbb7beb5d7f9ba7b0f60ebf
    Image:          nginx:1.19.5-alpine
    Image ID:       docker-pullable://nginx@sha256:efc93af57bd255ffbfb12c89ec0714dd1a55f16290eb26080e3d1e7e82b3ea66
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Sat, 23 Jan 2021 11:32:20 +0100
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-9xfwj (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  default-token-9xfwj:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-9xfwj
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  18m   default-scheduler  Successfully assigned default/nginx-v2-746b846fc-4lc86 to minikube
  Normal  Pulled     18m   kubelet            Container image "nginx:1.19.5-alpine" already present on machine
  Normal  Created    18m   kubelet            Created container nginx-v2
  Normal  Started    18m   kubelet            Started container nginx-v2
```