# [MPWAR] - Entorno Web
## Entregable 4 - Parte 2 [Git]

<br>

1. Crea un nuevo proyecto e inicializa git
2. Añade una regla para ignorar los ficheros de tipo .sh
3. Crea dos ficheros vacíos: demo1.txt y demo2.txt. Añade estos ficheros al stage
area.
4. Añade contenido al fichero demo1.txt. A continuación, realiza un commit con el
mensaje “Modified demo1.txt”
5. Añade contenido al fichero demo2. A continuación, realiza un commit con el
mensaje “Modified demo3.txt”
6. Rectifica el commit anterior con el mensaje “Modified demo2.txt”
7. Crea una nueva rama “develop” y añade un fichero script.sh que imprima por
pantalla “Git 101”
8. Da permisos de ejecución al script
9. Realiza un merge (develop -> master) para integrar los cambios
10. Sube todos los cambios a tu repositorio remoto

Ejecutar el siguiente comando e inclúyelo en tu repositorio para ver que todos los cambios solicitados se han realizado:

```
git log --oneline > verification.log
```

Indica todos los comandos que has utilizado para llevar a cabo cada uno de los puntos.

<br>

> <br>
> Respuestas:
> <br>
> <br>

<br>

_- Ejercicio 01:_

```bash
mkdir newproject && cd newproject
git init
```

_- Ejercicio 02:_

```bash
touch .gitignore
nano .gitignore
```

Dentro del archivo .gitignore:

```
*.sh
```

Salvamos y salimos del editor.

_- Ejercicio 03:_

```bash
touch demo1.txt demo2.txt
git add demo1.txt demo2.txt
```

_- Ejercicio 04:_

```bash
nano demo1.txt
```

Dentro del archivo demo1.txt:

```
Contenido demo1.txt
```

Añadimos el archivo modificado:

```bash
git add demo1.txt
```

Al intentar hacer un commit me pide configurar el email y nombre previamente:

```bash
git config --global user.email mario.sp@students.salle.url.edu
git config --global user.name mario
```

Commit:

```bash
git commit -m "Modified demo1.txt"
```

_- Ejercicio 05:_

```bash
nano demo2.txt
```

Dentro del archivo demo2.txt:

```
Contenido demo2.txt
```

Añadimos el archivo modificado:

```bash
git add demo2.txt
```

Commit:

```bash
git commit -m "Modified demo3.txt"
```

_- Ejercicio 06:_

```bash
git commit --amend -m "Modified demo2.txt"
```

_- Ejercicio 07:_

```bash
git branch develop
git checkout develop
touch script.sh
nano script.sh
```

Dentro del archivo script.sh:

```bash
#!/bin/bash
echo "Git 101"
```

_- Ejercicio 08:_

```bash
chmod +x script.sh
```

_- Ejercicio 09:_

Al ignorar todos los archivos `.sh` no hay ningún archivo modificado para añadir ni hacer commit en la rama develop.

Resultado de `git add script.sh`

```bash
Las siguientes rutas son ignoradas por uno de tus archivos .gitignore:
script.sh
Usa -f si realmente quieres agregarlos.
```

Resultado de `git status`:

```bash
En la rama develop
Archivos sin seguimiento:
  (usa "git add <archivo>..." para incluirlo a lo que se será confirmado)
        .gitignore

no hay nada agregado al commit pero hay archivos sin seguimiento presentes (usa "git add" para hacerles seguimiento)
```

Añado el archivo script.sh forzandolo:

```bash
git add -f script.sh
```

Resultado de `git status`:

```bash
En la rama develop
Cambios a ser confirmados:
  (usa "git restore --staged <archivo>..." para sacar del área de stage)
        nuevo archivo:  script.sh

Archivos sin seguimiento:
  (usa "git add <archivo>..." para incluirlo a lo que se será confirmado)
        .gitignore
```

Commit:

```bash
git commit -m "Added script.sh to branch develop"
```

Volvemos a la rama master para realizar el merge:

```bash
git checkout master
git merge develop
```

Resultado:

```bash
Actualizando 9b1f909..5e27dbc
Fast-forward
 script.sh | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100755 script.sh
```

_- Ejercicio 10:_

```
git remote add origin https://github.com/janfribogar/MUPWAR-EntornoWeb-newproject.git
git push --all
git log --oneline > verification.log
```