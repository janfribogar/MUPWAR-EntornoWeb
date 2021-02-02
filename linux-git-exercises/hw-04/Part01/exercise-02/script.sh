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
grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" $fromdir/$logfile.log | sort -r -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 | uniq -c | awk '{print $2 " -> " $1}' >> $fromdir/$logreq.txt
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
