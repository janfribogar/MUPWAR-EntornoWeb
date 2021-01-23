# [MPWAR] - Entorno Web
## Entregable 2 - Ejercicio 2

<br>

### Crear un objeto de tipo replicaSet a partir del objeto anterior con las siguientes especificaciones:

- Debe tener 3 replicas
- ¿Cúal sería el comando que utilizarías para escalar el número de replicas a 10?
- Si necesito tener una replica en cada uno de los nodos de Kubernetes, ¿qué objeto se adaptaría mejor? (No es necesario adjuntar el objeto)

<br>

> <br>
> Respuestas:
> <br>
> <br>

<br>

_- replicaset.yaml:_

```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-server
  labels:
    app: nginx-server
    tier: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - image: nginx:1.19.4-alpine
        name: nginx-server
```

_- Despliegue de replicaset en kubernetes:_

```
kubectl create -f replicaset.yaml
```

_- Escalar el número de replicas a 10:_

```
kubectl scale --replicas=10 replicaset nginx-server
```

_- Objeto para tener una replica en cada nodo de Kubernetes:_

DaemonSet