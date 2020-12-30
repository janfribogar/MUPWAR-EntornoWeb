# [MPWAR] - Entorno Web
## Entregable 1 - Ejercicio 3

<br>

### Crea un contenedor con las siguientes especificaciones:
- a. Utilizar la imagen base NGINX haciendo uso de la versión 1.19.3
- b. Al acceder a la URL localhost:8080/index.html aparecerá el mensaje HOMEWORK 1
- c. Persistir el fichero index.html en un volumen llamado static_content

<br>

> <br>
> OPCIÓN 1: Creación de index.html, Dockerfile, imagen y contenedor:
> <br>
> <br>

<br>

_index.html:_

```HTML
<!DOCTYPE html>
<html>
<head>
<title>HOMEWORK 1 - OPCION 1</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>HOMEWORK 1 - OPCION 1</h1>
</body>
</html>
```

_Dockerfile:_

```Dockerfile
FROM nginx:1.19.3-alpine
COPY ./index.html /usr/share/nginx/html
```
_Creación de imagen a partir de Dockerfile:_

```Docker
docker build -t en001ej03:1.0 .
```

_Creación del contenedor a partir de la iamgen anterior:_

```Docker
docker run --mount 'type=volume,src=static_content,dst=/usr/share/nginx/html' -p 8080:80 -d --name en001ej03op1 en001ej03:1.0
```

> <br>
> OPCIÓN 2: Creación de index.html, creación del volumen, crear contenedor y añadir archivo index.html al contenedor/volumen:
> <br>
> <br>

<br>

_index.html:_

```HTML
<!DOCTYPE html>
<html>
<head>
<title>HOMEWORK 1 - OPCION 2</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>HOMEWORK 1 - OPCION 2</h1>
</body>
</html>
```

_Creación del volumen (He cambiado el nombre del volumen añadiendo un 2 para probar la opción 1 y 2 a la vez):_

```Docker
docker volume create static_content2
```

_Creación del contenedor (He cambiado el puerto al 8081 para poder probar opción 1 y 2 a la vez):_

```Docker
docker run --mount 'type=volume,src=static_content2,dst=/usr/share/nginx/html' -p 8081:80 -d --name en001ej03op2 nginx:1.19.3-alpine
```

_Añadir el archivo index.html dentro del contenedor/volumen:_

```Docker
docker cp ./index.html en001ej03op2:/usr/share/nginx/html
```