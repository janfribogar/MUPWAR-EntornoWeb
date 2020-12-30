# [MPWAR] - Entorno Web
## Entregable 1 - Ejercicio 4

<br>

### Crea una imagen docker a partir de un Dockerfile. Esta aplicación expondrá un servicio en el puerto 8080 y se deberá hacer uso de la instrucción HEALTHCHECK para comprobar si la aplicación está ofreciendo el servicio o por si el contrario existe un problema.

### El healthcheck deberá parametrizarse con la siguiente configuración:
- La prueba se realizará cada 45 segundos
- Por cada prueba realizada, se esperará que la aplicación responda en menos de 5 segundos. Si tras 5 segundos no se obtiene respuesta, se considera que la prueba habrá fallado
- Ajustar el tiempo de espera de la primera prueba (Ejemplo: Si la aplicación del contenedor tarda en iniciarse 10s, configurar el parámetro a 15s)
- El número de reintentos será 2. Si fallan dos pruebas consecutivas, el contenedor deberá cambiar al estado “unhealthy”)

<br>

> <br>
> Creación de index.html, Dockerfile, imagen, contenedor y comprobación de health:
> <br>
> <br>

<br>

_index.html:_

```HTML
<!DOCTYPE html>
<html>
<head>
<title>Entregable 1 - Ejercicio 4</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Entregable 1 - Ejercicio 4</h1>
</body>
</html>
```

_Dockerfile:_

```Dockerfile
FROM nginx:1.19.3-alpine
COPY ./index.html /usr/share/nginx/html
HEALTHCHECK --interval=45s --timeout=5s --retries=2 CMD curl -f http://localhost/ || exit 1
```
- No he utilizado el `--start-period=10s` ya que la primera comprobación la realiza a 45 segundos del inicio. El start-period deberia ser superior al tiempo interval sino no tiene ningún efecto.
- Al no ponerlo, por defecto, su tiempo es de 0s.

_Creación de imagen a partir de Dockerfile:_

```Docker
docker build -t en001ej04:1.0 .
```

_Creación del contenedor a partir de la imagen anterior:_

```Docker
docker run -p 8080:80 -d --name en001ej04 en001ej04:1.0
```

_Comprobar cuantos healthchecks lleva realizados y cuanto ha tardado cada uno. Así como ver sus resultados:_

```Docker
docker inspect --format "{{json .State.Health }}" en001ej04 | jq
```

- Viendo el resultado del healthcheck se podria realizar la prueba con un timeout mucho menor ya que no tarda ni un segundo en terminar la prueba.

_Adjunto imagenes en la carpeta del ejercicio como prueba del estado "healthy" del contenedor._