# [MPWAR] - Entorno Web
## Entregable 3 - Ejercicio 3

<br>

### [Horizontal Pod Autoscaler] Crea un objeto de kubernetes HPA, que escale a partir de las  métricas CPU  o  memoria (a  vuestra  elección). Establece el umbral al 50%  de CPU/memoria utilizada, cuando pase el umbral, automáticamente se deberá escalaral doble de replicas. 

- Podéis realizar una prueba de estrés realizando un número de peticiones masivas mediantela siguiente instrucción:

```
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never --/bin/sh -c "while sleep 0.01; do wget -q -O- http://<svc_name>; done"
```

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
  replicas: 1
  selector:
    matchLabels:
      app: nginx-server
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
        resources:
          limits:
            cpu: 20m
          requests:
            cpu: 20m
```

_- Despliegue del deployment en kubernetes:_

```
kubectl create -f deployment.yaml
```

_- service.yaml:_

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-server-svc
spec:
  selector:
    app: nginx-server
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80
```

_- Despliegue del service en kubernetes:_

```
kubectl create -f service.yaml
```

_- Orden para ejecutar el horizontal pod autoscaler:_

```
kubectl autoscale deployment nginx-server --cpu-percent=10 --min=1 --max=10
```

Al tratarse un nginx alpine los recursos de CPU son mínimos por eso ajusto el porcentaje al 10% para forzar al escalado más rápido de los pods.

_- Orden para realizar la prueba de estres del deployment atacando al servicio:_

```
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.005; do wget -q -O- http://172.17.0.6; done"
```

He rebajado el tiempo a 0.005 segundos para forzar más el escalado automático.
Al final consigue escalar a 10 replicas para mantener el ratio de 10% requerido.

_- Paro el estress test para ver que vuelve a su estado normal de 1 pod si baja el consumo de CPU:_

El tiempo de desescalado está por defecto a 5 minutos y con una desescalada progresiva. Se podrían ajustar estos valores en el HPA.

_- Elimino el HPA:_

```
kubectl delete hpa nginx-server
```

_- Vuelvo a ejecutar el horizontal pod autoscaler pero esta vez al 20%:_

```
kubectl autoscale deployment nginx-server --cpu-percent=20 --min=1 --max=10
```

_- Orden para realizar la prueba de estres del deployment atacando al servicio:_

```
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.005; do wget -q -O- http://172.17.0.6; done"
```

Al final consigue escalar a 5 replicas para mantener el ratio de 10% requerido.

_- Paro el estress test para ver que vuelve a su estado normal de 1 pod si baja el consumo de CPU:_

Dejo una imagen donde hago un `kubectl get hpa -w` durante todo el proceso para ver el escalado. La imagen adjunta en la carpeta es: "hpa.png". En amarillo se puede observar el primer tramo con el HPA al 10% y en rojo el segundo tramo al 20%.