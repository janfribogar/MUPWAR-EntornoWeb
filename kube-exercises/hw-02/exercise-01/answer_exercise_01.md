# [MPWAR] - Entorno Web
## Entregable 2 - Ejercicio 1

<br>

### Crea un pod de forma declarativa con las siguientes especificaciones:

- Imagen: nginx
- Version: 1.19.4
- Label: app: nginx-server
- Limits
    - CPU: 100 milicores
    - Memoria: 256Mi
- Requests
    - CPU: 100 milicores
    - Memoria: 256Mi

### Realiza un despliegue en Kubernetes, y responde las siguientes preguntas:

- ¿Cómo puedo obtener las últimas 10 líneas de la salida estándar (logs
generados por la aplicación)?
- ¿Cómo podría obtener la IP interna del pod? Aporta capturas para indicar
el proceso que seguirías.
- ¿Qué comando utilizarías para entrar dentro del pod?
- Necesitas visualizar el contenido que expone NGINX, ¿qué acciones
debes llevar a cabo?
- Indica la calidad de servicio (QoS) establecida en el pod que acabas de
crear. ¿Qué lo has mirado?

<br>

> <br>
> Respuestas:
> <br>
> <br>

<br>

_- pod.yaml:_

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: nginx-server
  name: nginx-server-v1
spec:
  containers:
  - image: nginx:1.19.4-alpine
    name: nginx-server
    resources:
      limits:
        cpu: 100m
        memory: 256Mi
      requests:
        cpu: 100m
        memory: 256Mi
  dnsPolicy: ClusterFirst
  restartPolicy: Never
```

_- Despliegue de pod en kubernetes:_

```
kubectl create -f pod.yaml
```

_- Logs de las 10 últimas líneas:_

```
kubectl logs --tail=10 nginx-server-v1
```

_- Información del pod extendida (con IP interna):_

```
kubectl get pods/nginx-server-v1 -o wide
```

_- Entrar dentro del pod con shell:_

```
kubectl exec -it nginx-server-v1 -- /bin/sh
```

_- Visualizar el contenido que expone NGINX:_

```
kubectl port-forward nginx-server-v1 8080:80
```
Desde el navegador ponemos la URL--> http://localhost:8080/

_- Calidad (QoS) del pod:_

```
kubectl describe pod nginx-server-v1
```
Del resultado que nos da buscamos "QoS Class". En este caso da "BestEffort"