# [MPWAR] - Entorno Web
## Entregable 5 - Ejercicio 1

<br>

### Diseña una pipeline que contenga las siguientes fases vistas en clase:

- Continuous Integration
- Continuous Delivery
- Continuous Deployment

Se deberá crear un fichero Jenkinsfile donde contenga todos los pasos de las diferentes fases.

Requerimientos:

- Diseñar pipeline desde la fase de construcción del proyecto hasta la fase de despliegue en Kubernetes
- Cada estudiante es libre de escoger la tecnología de su proyecto (Angular, React, Java, PHP, Golang, ...)
- No se evaluará el código o el proyecto (puede ser un programa que imprima “Hello World!”)
- Explicar todas las tecnologías utilizadas para la fase de Continuous Integration (gestor de paquetes, tests unitarios, funcionales, ...)
- Además del código, generar el fichero Dockerfile y los manifiestos de Kubernetes
- No es necesario instalar herramientas o lenguajes de programación. Para simular los comandos de cada fase, realizad un echo ‘<your_shell_command>’

<br>

> <br>
> Respuestas:
> <br>
> <br>

<br>

_- Creación del contenedor de jenkins:_

```
docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```

_- Entramos en el contenedor para buscar la password inicial de administración de jenkins:_

```
docker exec -it "container_id" bash
```

Visualizamos el contenido del archivo /var/jenkins_home/secrets/initialAdminPassword

```
more /var/jenkins_home/secrets/initialAdminPassword
```

_- Abrimos nuestro navegador para realizar la configuración inicial de jenkins:_

```
http://localhost:8080/
```

Nos pedirá nuestra password inicial copiada previamente e instalamos los plugins por defecto "Install suggested plugins"

Introducimos los datos de usuario de jenkins.

_- Creamos una nueva tarea tipo pipeline_

_- Pipeline:_

```
pipeline {
    agent any
    stages {
        // CONTINUOUS INTEGRATION
        stage('build') {
            steps {
                echo 'sh docker build -t janfribogar/cicd-hw-05:1.0 .'
            }
        }
        stage('test - image'){
            steps {
                echo 'sh docker image inspect janfribogar/cicd-hw-05:1.0'
            }  
        }
        stage('run container') {
            steps {
                echo 'sh docker run --name cicd-hw-05-test -d -p 8081:80 janfribogar/cicd-hw-05:1.0'
            }
        }
        stage('test - curl'){
            steps {
                echo "sh curl 'http://localhost:8081'"
            }  
        }
        stage('merge and/or commit') {
            steps {
                echo 'sh docker commit cicd-hw-05-test janfribogar/cicd-hw-05:1.0'
                echo 'sh docker rm -f cicd-hw-05-test'
                echo 'sh docker image prune -f'
            }
        }
        // CONTINUOUS DELIVERY
        stage('release (dockerhub)') {
            steps {
                echo 'sh cat ./my_password.txt | docker login --username janfribogar --password-stdin'
                echo 'sh docker push janfribogar/cicd-hw-05:1.0'
            }
        }
        // CONTINUOUS DEPLOYMENT
        stage('deploy') {
            steps {
                echo 'sh kubectl apply -f deploy.yaml'
            }
        }
    }
}
```

Al no trabajar de programador web ni venir de estudios relacionados directamente con la informatica no conozco, todavía, ni php, ni angular, ni react, etc... y tampoco conozco los tests. He estado intentando mirar por encima pero no me aclaraba del tema.

He realizado un ejemplo sencillo con un hello world en un html y un test de curl.

He probado todos los comandos en local simulando la secuencia del pipeline.