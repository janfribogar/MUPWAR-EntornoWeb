# [MPWAR] - Entorno Web
## Entregable 4 - Parte 1 [Linux] - Ejercicio 1

<br>

### Utiliza el siguiente comando para descargar el fichero que vamos a necesitar para realizar el ejercicio:

```
curl -o nginx_logs_examples.log https://raw.githubusercontent.com/elastic/examples/master/Common%20Data%20Formats/nginx_logs/nginx_logs
```

Este fichero contiene ejemplos de logs de acceso a NGINX. Con la ayuda de los comandos vistos en clase, se requiere:

- Ordenar las IPs (en orden decreciente)
- Buscar el número total ocurrencias por cada una de las IPs

El output tras la ejecución del comando debería ser el siguiente:

```
80.91.33.133 -> 1202
93.180.71.3 -> 30
...
...
```

Tras la ejecución del comando, guardar la salida en un fichero nginx_requests_total.txt
Comentarios:

- Se debería conseguir el resultado esperado con la ejecución de una única
sentencia. Recordad, podéis utilizar command 1| command 2 | command 3
- Podéis utilizar comandos que no hayamos visto en clase

<br>

> <br>
> Respuestas:
> <br>
> <br>

<br>

_- Comando utilizado:_

```
grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" nginx_logs_examples.log | sort -r -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 | uniq -c | awk '{print $2 " -> " $1}' >> nginx_requests_total.txt

```

_- Alternativa:_

```
grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" nginx_logs_examples.log | sort -rV | uniq -c | awk '{print $2 " -> " $1}' >> nginx_requests_total.txt
```