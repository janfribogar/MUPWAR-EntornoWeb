# [MPWAR] - Entorno Web
## Entregable 4 - Parte 1 [Linux] - Ejercicio 3

<br>

### Utilizando el script del ejercicio anterior, crea un crontab con los siguientes requerimientos:

- El script se deberá ejecutar exclusivamente de lunes a domingo
- La hora de ejecución será 23.59 hrs
- Todos los meses del año

<br>

> <br>
> Respuestas:
> <br>
> <br>

<br>

_- Creación de crontab:_

```bash
crontab -e
```

_- liniea de comando dentro del archivo crontab:_

```bash
59 23 * * 0-6 cd /home/mario/Documentos/MUPWAR/01_EntornoWeb/Tema04_Git/linux-git-exercises/hw-04/Part01/exercise-02 && ./script.sh
```

_- Alternativa:_

```bash
52 9 * * * cd /home/mario/Documentos/MUPWAR/01_EntornoWeb/Tema04_Git/linux-git-exercises/hw-04/Part01/exercise-02 && ./script.sh
```

Al ser de lunes a domingo se puede obviar especificarlo y poner un *
Para ser testeado en otro PC susbtituir la ruta donde se encuentre el archivo script.sh