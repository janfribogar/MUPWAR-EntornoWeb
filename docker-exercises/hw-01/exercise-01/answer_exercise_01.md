# [MPWAR] - Entorno Web
## Entregable 1 - Ejercicio 1

<br>

### Indica la diferencia entre el uso de la instrucción CMD y ENTRYPOINT (Dockerfile):

<br>

Cuando una imagen creada a partir de un Dockerfile contiene la instrucción CMD, esta instrucción puede ser anulada (sobrescrita) cuando creamos el contenedor con dicha imagen.<br>
Con una imagen creada a partir de un Dockerfile con la instrucción ENTRYPOINT, esta instrucción NO puede ser anulada (sobrescrita) cuando creamos el contenedor con dicha imagen.

<br>

> <br>
> Ejemplo CMD:
> <br>
> <br>

<br>

_Dockerfile:_

```Dockerfile
FROM alpine:3.12.3
CMD ["echo","Hello World"]
```
_Creación de imagen a partir de Dockerfile:_

```Dockerfile
docker build -t en001ej01:CMD .
```

_Test CMD y anular CMD:_

```Docker
docker run --name en001ej01CMD en001ej01:CMD
Hello World
```
```Docker
docker run --name en001ej01CMD2 en001ej01:CMD hostname
bb0cacb8afed
```

> <br>
>Ejemplo ENTRYPOINT:
> <br>
> <br>

<br>

_Dockerfile:_

```Dockerfile
FROM alpine:3.12.3
ENTRYPOINT ["echo","Hello World"]
```

_Creación de imagen a partir de Dockerfile:_

```Dockerfile
docker build -t en001ej01:ENTRYPOINT .
```

_Test ENTRYPOINT y "NO" anular ENTRYPOINT:_

```Docker
docker run --name en001ej01ENTRYPOINT en001ej01:ENTRYPOINT
Hello World
```
```Docker
docker run --name en001ej01ENTRYPOINT2 en001ej01:ENTRYPOINT hostname
Hello World hostname
```