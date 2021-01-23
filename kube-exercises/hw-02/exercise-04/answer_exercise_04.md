# [MPWAR] - Entorno Web
## Entregable 2 - Ejercicio 4

<br>

### Crear un objeto de tipo deployment con las especificaciones del ejercicio 1.

- Despliega una nueva versión de tu nuevo servicio mediante la técnica “recreate”
- Despliega una nueva versión haciendo “rollout deployment”
- Realiza un rollback a la versión generada previamente


<br>

> <br>
> Respuestas:
> <br>
> <br>

<br>

_- deployment.yaml:_

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-server
  labels:
    app: nginx-server
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-server
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: nginx-server
    spec:
      containers:
      - name: nginx-server
        image: nginx:1.19.4-alpine
        ports:
        - containerPort: 80
```

_- Despliegue del deployment en kubernetes:_

```
kubectl apply -f deployment.yaml 
```

_- Desplegar nueva version con la técnica recreate (indicada previamente en el deployment.yaml):_

```
kubectl set image deployment nginx-server nginx-server=nginx:1.19.5-alpine
```

_- Modificamos el deployment.yaml cambiando el type a RollingUpdate y la version de nginx a 1.19.6-alpine:_

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-server
  labels:
    app: nginx-server
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-server
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: nginx-server
    spec:
      containers:
      - name: nginx-server
        image: nginx:1.19.6-alpine
        ports:
        - containerPort: 80
```

_- Despliegue la modificación del deployment en kubernetes:_

```
kubectl apply -f deployment.yaml --record
```

_- Revisamos el historial de revisiones del deployment:_

```
kubectl rollout history deployment nginx-server
```

La salida nos muestra que tenemos 3 revisiones pero la causa de ellas solo aparece en la tarcera revisión que es la que hemos aplicado el parámetro "--record" para que nos guarde el motivo del cambio de revision.

_- Rollback a la versión anterior (en mi caso la 2ª de las 3 realizadas):_

```
kubectl rollout undo deployment nginx-server
```

o especificando la versión:

```
kubectl rollout undo deployment nginx-server --to-revision=2
```

_- Revisamos el historial de revisiones del deployment:_

```
kubectl rollout history deployment nginx-server
```

Podemos ver que la version 2 ha desparecido y ahora solo tenemos la 1, la 3 y la 4. Esta última vuelve a ser igual que la 2 al hacer el rollback. Deberiamos haber lanzado, previamente, el despliegue 2 con el parámetro "--record" para asegurarnos del comando utilizado para ese despliegue.

_- Revisar version de nginx corriendo en cualquiera de los 3 pods para verificar el correcto rollback:_

```
kubectl describe pod nginx-server-5f47f7dcbf-XXXXX
```