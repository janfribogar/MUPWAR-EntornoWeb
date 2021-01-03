# [MPWAR] - Entorno Web
## Entregable 1 - Ejercicio 5

<br>

### La compañía para la que trabajáis estudia la posibilidad de incorporar a nivel interno una herramienta para la monitorización de logs. Para ello, os han encomendado la tarea de realizar una “Proof of Concept” (PoC). Tras evaluar diferentes productos, habéis considerado que una buena opción es la utilización del producto Elastic stack, cumple con los requisitos y necesidades de la empresa.
### Tras comentarlo con el CTO a última hora de la tarde, os ha solicitado que preparéis una presentación para mañana a primera hora. Dado el escaso margen para montar la demostración, la opción más ágil y rápida es utilizar una solución basada en contenedores donde levantaréis el motor de indexación (ElasticSearch) y la herramienta de visualización (Kibana).
### Rellena el siguiente fichero docker-compose para que podáis hacer la demostración al CTO.

```Docker
version: '3.6'
services:
elasticsearch:
# Utilizar la imagen de elasticsearch v7.9.3
...
# Asignar un nombre al contenedor
...
# Define las siguientes variables de entorno:
# discovery.type=single-node
...
# Emplazar el contenedor a la red de elastic
...
# Mapea el Puerto externo 9200 al puerto interno del contenedor 9200
# Idem para el puerto 9300
...
kibana:
# Utilizar la imagen kibana v7.9.3
...
# Asignar un nombre al contenedor
...
# Emplazar el contenedor a la red de elastic
...
# Define las siguientes variables de entorno:
# ELASTICSEARCH_HOST=elasticsearch
# ELASTICSEARCH_PORT=9200
...
# Mapear el puerto externo 5601 al puerto interno 5601
...
# El contenedor Kibana depe esperar a la disponibilidad del servicio elasticsearch
...
# Definir la red elastic (bridge)
...
```

<br>

> <br>
> Creación de docker-compose.yml, levantar docker-compose y revisar datos en http://localhost:5601
> <br>
> <br>

<br>

_docker-compose.yml:_

```Docker
version: '3.6'

## SERVICIOS
services:
# Contenedor de elasticsearch
  elasticsearch:
    image: elasticsearch:7.9.3
    container_name: en001ej05es
    environment:
      - discovery.type=single-node
    networks:
      - elastic
    ports:
      - 9200:9200
      - 9300:9300
# Contenedor de kibana
  kibana:
    image: kibana:7.9.3
    container_name: en001ej05kb
    environment:
      - ELASTICSEARCH_HOST=elasticsearch
      - ELASTICSEARCH_PORT=9200
    networks:
      - elastic
    ports:
      - 5601:5601
    depends_on:
      - elasticsearch

## REDES
networks:
# Red para elasticsearch y kibana (bridge)
  elastic:
    driver: bridge
```

_Levantar docker-compose:_

```Docker
docker-compose up -d
```

_Adjunto imagenes en la carpeta del ejercicio como prueba del correcto funcionamiento._