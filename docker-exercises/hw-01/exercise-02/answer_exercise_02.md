# [MPWAR] - Entorno Web
## Entregable 1 - Ejercicio 2

<br>

### Indica la diferencia entre el uso de la instrucción ADD y COPY (Dockerfile):

<br>

Las instrucciones ADD y COPY realizan la misma acción. Sirven para copiar archivos de una ubicación específica dentro de una imagen de docker.<br>
La diferencia reside en que COPY solo puede tener como fuente archivos locales en el host que crea la imagen de docker, mientras que ADD puede tener como fuente una URL.<br>
Tambien el comando ADD extrae archivos comprimidos en un archivo .tar y los copia dentro de la imagen de docker.<br>
Se puede realizar la acción de copiar desde una URL y descomprimir ejecutando una serie de comandos RUN en el Dockerfile evitando así usar el comando ADD.

<br>

> <br>
> Ejemplo copiar archivos de URL y descomprimirlos sin usar ADD:
> <br>
> <br>

<br>

_Parte de un Dockerfile para copiar archivos de URL y descomprimirlos sin usar ADD:_

```Dockerfile
RUN wget -O myfile.tar.gz http://example.com/myfile.tar.gz \
    && tar -xvf myfile.tar.gz -C /usr/src/myapp \
    && rm myfile.tar.gz
```