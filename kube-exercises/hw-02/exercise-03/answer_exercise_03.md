# [MPWAR] - Entorno Web
## Entregable 2 - Ejercicio 3

<br>

### Crea un objeto de tipo service para exponer la aplicación del ejercicio anterior de las siguientes formas:

- Exponiendo el servicio hacia el exterior (crea service1.yaml)
- De forma interna, sin acceso desde el exterior (crea service2.yaml)
- Abriendo un puerto especifico de la VM (crea service3.yaml)

<br>

> <br>
> Respuestas:
> <br>
> <br>

<br>

_- service1.yaml:_

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-server-svc1
spec:
  type: LoadBalancer
  selector:
    app: nginx-server
  ports:
  - protocol: TCP
    port: 8081
    targetPort: 80
```

"LoadBalancer" no funciona en minikube. No lo puedo probar.

_- service2.yaml:_

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-server-svc2
spec:
  selector:
    app: nginx-server
  ports:
  - protocol: TCP
    port: 8082
    targetPort: 80
```

Por defeto el "type" es "ClusterIP" por eso se puede no poner.

_- service3.yaml:_

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-server-svc3
spec:
  type: NodePort
  selector:
    app: nginx-server
  ports:
  - protocol: TCP
    port: 8083
    targetPort: 80
    nodePort: 30007
```