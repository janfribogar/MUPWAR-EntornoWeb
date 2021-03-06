# [MPWAR] - Entorno Web
## Entregable 3 - Ejercicio 1

<br>

### [Ingress Controller / Secrets] Crea los siguientes objetos de forma declarativa con las siguientes especificaciones:

- Imagen: nginx
- Version: 1.19.4
- 3 replicas
- Label: app: nginx-server
- Exponer el puerto 80 de los pods
- Limits:
  - CPU: 20 milicores
  - Memoria: 128Mi
- Requests:
  - CPU: 20 milicores
  - Memoria: 128Mi

a. A continuación, tras haber expuesto el servicio en el puerto 80, se deberá
acceder a la página principal de Nginx a través de la siguiente URL:

```
http://<student_name>.student.lasalle.com
```

b. Una vez realizadas las pruebas con el protocolo HTTP, se pide acceder al
servicio mediante la utilización del protocolo HTTPS, para ello:

- Crear un certificado mediante la herramienta OpenSSL u otra similar
- rear un secret que contenga el certificado

Validación:
- Navegador web

Aclaraciones:
- En la URL, se deberá sustituir <student_name> por el nombre del estudiante
- No es necesario cambiar los ficheros de configuración de Nginx
- No es necesario exponer el servicio hacia el exterior (ClusterIP)

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
    app: nginx-server-replicaset
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-server
  template:
    metadata:
      labels:
        app: nginx-server
    spec:
      containers:
      - image: nginx:1.19.4-alpine
        name: nginx-server
        resources:
          limits:
            cpu: 20m
            memory: 128Mi
          requests:
            cpu: 20m
            memory: 128Mi
        ports:
        - containerPort: 80
```

_- Despliegue del replicaset en kubernetes:_

```
kubectl apply -f replicaset.yaml
```

<br>

> <br>
> Respuestas punto a):
> <br>
> <br>

<br>

_- service.yaml:_

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  selector:
    app: nginx-server
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80
```

_- Despliegue del servicio en kubernetes:_

```
kubectl apply -f service.yaml
```

_- ingress.yaml:_

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
spec:
  rules:
  - host: mario.student.lasalle.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-svc
            port:
              number: 80
```

_- Despliegue del ingress en kubernetes:_

```
kubectl apply -f ingress.yaml
```

_- Comprobación de su correcto funcionamiento en el navegador (ver imagen en carpeta: ingress.png) y mediante terminal:_

```
curl -k http://mario.student.lasalle.com
```

Resultado:

```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

<br>

> <br>
> Respuestas punto b):
> <br>
> <br>

<br>

_- Creación del certificado mediante openssl:_

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=mario.student.lasalle.com"
```

_- Visualizar la llave y el certificado en base64 para poder copiar el contenido dentro del secret.yaml:_

```
cat tls.crt | base64
cat tls.key | base64
```

_- secret.yaml:_

```
apiVersion: v1
kind: Secret
metadata:
  name: nginx-secret-tls
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURLVENDQWhHZ0F3SUJBZ0lVVWlVdzhWL240eWNjS1ZYQ2kwNzd6TTRnQ0RVd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0pERWlNQ0FHQTFVRUF3d1piV0Z5YVc4dWMzUjFaR1Z1ZEM1c1lYTmhiR3hsTG1OdmJUQWVGdzB5TVRBeApNak14TkRJNU1UbGFGdzB5TWpBeE1qTXhOREk1TVRsYU1DUXhJakFnQmdOVkJBTU1HVzFoY21sdkxuTjBkV1JsCmJuUXViR0Z6WVd4c1pTNWpiMjB3Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRRE8KVktvcW13S3oyOWtqNWVWV1gwTVdKRFd1cDJCTzM1WVhWSDdOc1gwcUN5eTJGSm9QTHR3N1pWbmtBWFAvOHBCdwptditEVHBIcVdoclduZ1RMR0hTbmM0YksreEh5aXVkeWpSUXJST3dRZExFRWtMdGdydzlMUG9Ba1NMdk5JdmVWCmNWWnRYTkd0aElXQnJoWjFKL3cxbytMditYU21CRU5vZEhUbUxxeWwyODVTZTdKL2hUSDEzLzdyczlRdldJdzgKNzZmR1llNzRIR0orRjN2bUkzcVNkWDhQeW5sODJacVBTU3R4RnNNR3NCcTZMU2t1UzRVNHp4dHVvSFROdlp1dwpSZHRQZHZQUjFXaG4rTlNrdXQrbTFxbkd2ajdSSVkwM3RVVmJJaVdtUDZHMlh0MzVyUFUzYnpxT3RYbnNPaGpBCmdrSFFpdVN0eGtIa3Z4Tjc2SDZQQWdNQkFBR2pVekJSTUIwR0ExVWREZ1FXQkJRTkovVkJjWUpOdHkvSWJtdXEKRVZWbHk1QkdJakFmQmdOVkhTTUVHREFXZ0JRTkovVkJjWUpOdHkvSWJtdXFFVlZseTVCR0lqQVBCZ05WSFJNQgpBZjhFQlRBREFRSC9NQTBHQ1NxR1NJYjNEUUVCQ3dVQUE0SUJBUUNiNFZ2WU1aQUhjUVpSRVgydnRRSncwQUlYClQweHB0YzdnSFQwQXJzQ0NHNUF5ZW1VOXJieGQ0eVc1THc5OERacjlvbVh4WEZ4MUExQktoSUYwc1pGZTNoUC8KYy9RRHVxeTZnZVpkQ1RONU5JRk84YWxtVUxtbCtqYlVJcmZyS3VBdHpZc00ya1VrVWVhWGIzNGgrTFpCODB6WAplalFsOXdPcmdKL0ZQMDJZY0dPdG8vdVp1a0RkZXVrNysxUzJVUDhDdk1pZlo2SHYvTVRDbjh6OFM3VCtscnVXCmhxQzNWNnN1L3ovZ2xuS25KNWhScTFKekRzZk16QnRqcVZGV2l5UUxISHU4UnJheSsvZW4zSE1WbGdQUmZQOUYKb0tiRkdCSkR6QlFLNk1GWEhzU01rbkNybnFFRXNERS82ZEQySFUrZ0k1TzFsWkMzQjFndVpadE01SitrCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
  tls.key: LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2Z0lCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktnd2dnU2tBZ0VBQW9JQkFRRE9WS29xbXdLejI5a2oKNWVWV1gwTVdKRFd1cDJCTzM1WVhWSDdOc1gwcUN5eTJGSm9QTHR3N1pWbmtBWFAvOHBCd212K0RUcEhxV2hyVwpuZ1RMR0hTbmM0YksreEh5aXVkeWpSUXJST3dRZExFRWtMdGdydzlMUG9Ba1NMdk5JdmVWY1ZadFhOR3RoSVdCCnJoWjFKL3cxbytMditYU21CRU5vZEhUbUxxeWwyODVTZTdKL2hUSDEzLzdyczlRdldJdzg3NmZHWWU3NEhHSisKRjN2bUkzcVNkWDhQeW5sODJacVBTU3R4RnNNR3NCcTZMU2t1UzRVNHp4dHVvSFROdlp1d1JkdFBkdlBSMVdobgorTlNrdXQrbTFxbkd2ajdSSVkwM3RVVmJJaVdtUDZHMlh0MzVyUFUzYnpxT3RYbnNPaGpBZ2tIUWl1U3R4a0hrCnZ4Tjc2SDZQQWdNQkFBRUNnZ0VBUFRXY3Jic0NtRHpXTS9JVmtRUDlzT25aQ3hFWVh3MnhSd2FILzVseDJqRXEKZUhHd0ttVHFiS3hxZUZ0K0FDWURkNFJqM0o1SVowK0h1cmR5RUpZV3RUNXVkSFQ3SkFyVkVvU0x3VEpYSGFLZwppUXd1cWtZRXNYdS9KQVIzd2lsbmJXd01DYkdKZW9KZjROSzJVdGNqMlAzZmF2V0VCMlFvWXlwNUszZ1pPN0pxCjVIUHVKVUhIKzBadVcvT2NIOEE3Zkx6L2FVa0g2ZzE4VEJDY1BPKzVSV3dzYm5EWG43SXNtVXZoRm1pOUN0elEKem1GdWFXUWNxWjVRWTNxallPa2EvMXFDdW0xVnhwYVdYVnNlSGVibmwxL1YrWmxOYW0zYmhWb0Z4TFNCMytkUwp1TXJJci9iVUMzZGlJUjYyb2IzUXdPekpsaVFKS0xQeHhlRlRsbXNwRVFLQmdRRDFDWERtbGI2azVVaG9CakFICnE5c3pQZ2UwRFlMbjFURHl3YkdmUytKZ1ZjTG9SdG9sQVlZQVIvVUtPc2NYVEZXNGduUkdMMVdBM0dVNEYzSnMKdHJtVXpqSXNkVmNud0V0aTBNSG9WVHAxeDVVVHdBMS9WTU81eXNRWnBOeHJvWWtvS2pqSjloK0g1UXB1b1NRTwo1Z25JVnBlL0JRYWczcUFHWnhwQzZlMmZvd0tCZ1FEWGorWHJob3daRXAxUEU2Q2JxODJ0dW1jc1ZvN0w1VEx1ClFRSDRWc2tEYW9jQnhsNFhwRE5rTWF6WXJyZEhaZGpFdUYxQitYbjZ6aFo4WDl0VVNFRmNtTDI1c0lwelBoRUEKVEZOSzVEb054cDFLeTVRVkdvUWt3ZlRsUWNwSnYzMUVleitUdWo0dmlXTmhQVVd1d0VwYVI0NGw4K3RMckd6MgpFeUd6ZVVTa0pRS0JnUUNyNnpUUVEwM2Y2WkpVa2NyUEJ3K2pNeWs2ZGFSYnZlTTYzeFVkTzZPWGpYUlRmYXA5Ci9rU2pHOWxibFFPc1gvMWdsLzYyWTIxdEhMVFRsdmZNT0tPYU9OVlJCZjdoUC9Sa1h5MDlNZGJ6WGRWRlp5RFIKTG9xb1p4QVJJZThZZ054M1ZyQkRXckNpcXRzWDVXMGtHdGZRUEpqNUI3Q3YyNktRKzNPY2NQNHNXd0tCZ0FnQgpmaWFMTHJUWHJpUDd0S0ZUZGlZWG9ERlRYYVpROHQxS2FNcFNYdERUcWdQMDNCWEFzVy90TUdBenpQYkgzNDhlCjBjZmJmaDVFZlMxTldoWDlRUUF4WkFwN2RnamxxemY1bmJaUVY1K2ZXc1FtWDIrUk5vc3U4T3Q2MEFxQkpDUGcKOS9HQ24wQ2d0NklxNW1XaEdxSFR1b0hLVjFqT0pKWFhEQTlnVjU1SkFvR0JBSW5UZW9MSmdua0dMOStlQ25BUAo3UDRud3VrcmhON1V4a1lyQkQyZEFxTWlTWFE4OEMxNjRhdDdvL2FEMmREN0lEQWFWanAvdnd4ZHU1WHUxVGpXClZoM3JjbXZRSWpIQjZMSGhPSWlWUFBvOVpZcW1LMFVrS3ZRWVhRTXo5ZXZIRE1MNDc4Y1VPOVJNSFAwRHpXeE0KK1p0WW1iRzRFMGc2ZDlnUThjeWhYNmgwCi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0K
type: kubernetes.io/tls
```

_- Despliegue del secret en kubernetes:_

```
kubectl apply -f secret.yaml
```

_- ingress_tls.yaml:_

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress-tls
spec:
  tls:
  - hosts:
      - mario.student.lasalle.com
    secretName: nginx-secret-tls
  rules:
  - host: mario.student.lasalle.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-svc
            port:
              number: 80
```

_- Antes de desplegar el ingres_tls.yaml borro el ingress anteriormente creato sin certificado de kubernetes:_

```
kubectl delete ingress nginx-ingress
```

_- Despliegue del ingress_tls en kubernetes:_

```
kubectl apply -f ingress_tls.yaml
```

_- Comprobación de su correcto funcionamiento en el navegador (ver imagenes en carpeta: ingress_tls_1.png y ingress_tls_2.png) y mediante terminal:_

```
curl --cacert tls.crt https://mario.student.lasalle.com
```

Resultado:

```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```