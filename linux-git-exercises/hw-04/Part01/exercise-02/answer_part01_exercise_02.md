# [MPWAR] - Entorno Web
## Entregable 4 - Parte 1 [Linux] - Ejercicio 2

<br>

### Crea un script que cumpla con los siguientes requisitos:

Comprueba la existencia del siguiente directorio:

```
/backup/<student_name>/<year>/<month>/<day>
```

Si no existe el directorio, se deberá crear. Este directorio contendrá una copia del fichero de logs del ejercicio anterior siguiendo el siguiente formato:

nginx_log_requests_`<date>`.log donde la fecha vendrá definida como YYYYMMDD (año-mes-día).

Por ejemplo:

nginx_log_requests_20210125.log

Si la fecha de ejecución del script se realiza el último día de la semana, además del cumplir el requisito anterior, se deberá guardar en un fichero comprimido tar.gz el resultado de las ejecuciones de todos los días de la semana (solo la semana vigente).

Ejemplo:

nginx_logs_20210131.tar.gz
- nginx_log_requests_20210125.log
- nginx_log_requests_20210126.log
- nginx_log_requests_20210127.log
- nginx_log_requests_20210128.log
- nginx_log_requests_20210129.log
- nginx_log_requests_20210130.log
- nginx_log_requests_20210131.log

<br>

> <br>
> Respuestas:
> <br>
> <br>

<br>

_- Creación de sript:_

```bash
touch script.sh
```

_- Asignación de permison de ejecución:_

```bash
chmod +x script.sh
```

_- Edición del script:_

```bash
nano script.sh
```

_- script.sh:_

```bash
#!/bin/bash
fromdir=../exercise-01
student=$(whoami)
year=$(date +"%Y")
month=$(date +"%m")
day=$(date +"%d")
dayofweek=$(date +"%u")
todir=./backup/$student/$year/$month/$day
logfile=nginx_logs_examples
logreq=nginx_requests_total
logtar=nginx_logs
# Crear directorio si no existe
mkdir -p $todir
# Extraer los requests totales del archivo de logs
grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" $fromdir/$logfile.log | sort -r -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 | uniq -c | aw>
# Copiar logs y resumen requests totales
cp $fromdir/$logfile.log $todir/$logfile"_"$year$month$day.log
cp $fromdir/$logreq.txt $todir/$logreq"_"$year$month$day.txt
# Generar .tar.gz al final de cada semana (domingo)
if [ "$dayofweek" = 7 ];
then
  todir=./tmp
  mkdir $todir
  for i in {6..0}
  do
    year=$(date --date="$i days ago" +"%Y")
    month=$(date --date="$i days ago" +"%m")
    day=$(date --date="$i days ago" +"%d")
    fromdir=./backup/$student/$year/$month/$day
    cp $fromdir/* $todir/
  done
  tar -czf ./backup/$student/$year/$month/$day/$logtar"_"$year$month$day.tar.gz $todir/*
  rm -R $todir
fi
```