# [MPWAR] - Entorno Web
## Entregable 3 - Ejercicio 2

<br>

### [StatefulSet] Crear un StatefulSet con 3 instancias de MongoDB (ejemplo visto en clase)

Se pide:

- Habilitar el clúster de MongoDB
- Realizar una operación en una de las instancias a nivel de configuración y verificar que el cambio se ha aplicado al resto de instancias
- Diferencias que existiría si el montaje se hubiera realizado con el objeto de ReplicaSet

<br>

> <br>
> Respuestas:
> <br>
> <br>

<br>

_- statefulset.yaml:_

```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongo
spec:
  serviceName: mongo-svc
  replicas: 3
  selector:
    matchLabels:
      role: mongo
  template:
    metadata:
      labels:
        role: mongo
    spec:
      terminationGracePeriodSeconds: 10
      containers:
        - name: mongo-container
          image: mongo
          command:
            - mongod
          args:
            - --bind_ip=0.0.0.0
            - --replSet=rs0
            - --dbpath=/data/db
          ports:
            - containerPort: 27017
          volumeMounts:
            - name: db-storage
              mountPath: /data/db
  volumeClaimTemplates:
  - metadata:
      name: db-storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```

_- Despliegue del statefulset en kubernetes:_

```
kubectl create -f statefulset.yaml
```

_- service.yaml:_

```
apiVersion: v1
kind: Service
metadata:
  name: mongo-svc
  labels:
    name: mongo
spec:
  ports:
  - port: 27017
    targetPort: 27017
  selector:
    role: mongo
```

_- Despliegue del servicio en kubernetes:_

```
kubectl create -f service.yaml
```

_- Comprobación de que el servicio tiene los endpoints de los pods creados por el statefulset (las 3 replicas de mongo):_

```
kubectl get endpoints mongo-svc
```

Resultado:

```
NAME        ENDPOINTS                                            AGE
mongo-svc   172.17.0.4:27017,172.17.0.5:27017,172.17.0.6:27017   8m37s
```

_- Entramos dentro del primer pod para ajecutar los comando que nos habilitará el cluster de mongodb:_

```
kubectl exec -it mongo-0 sh
```

_- Aplicamos esta serie de comandos para habilitar el cluster en mongo:_

```
mongo
> rs.initiate({_id: "rs0", version: 1, members: [
... { _id:0, host : "mongo-0.mongo-svc.default.svc.cluster.local:27017" },
... { _id:1, host : "mongo-1.mongo-svc.default.svc.cluster.local:27017" },
... { _id:2, host : "mongo-2.mongo-svc.default.svc.cluster.local:27017" }
... ]});

```

_- mongo-express.yaml:_

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongo-express
  labels:
    app: web
    name: mongo-express
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
      name: mongo-express
  template:
    metadata:
      labels:
        app: web
        name: mongo-express
    spec:
      containers:
      - name: mongo-express
        image: mongo-express:0.54.0
        env:
        - name: ME_CONFIG_MONGODB_SERVER
          value: mongodb://mongo-0.mongo-svc.default,mongo-1.mongo-svc.default,mongo-2.mongo-svc.default?replicaSet=ns0
        ports:
          - containerPort: 8081
```

_- Despliegue del deployment en kubernetes:_

```
kubectl create -f mongo-express.yaml
```

_- Realizamos un port-forward de mongo express para verlo en el navegador:_

```
kubectl port-forward mongo-express-xxxxxxxxx-xxxxx 8081:8081
```

Desde el navegador entramos en http://localhost:8081 y nos aparece la web de mongo-express. Creamos una database, una colleción y un documento nuevo de esta colección (Ver imagenes adjuntas en la carpeta).

_- Entramos en varios pods de mongo para comprobar que los datos generados en mongo-express estan en todas las instancias de la base de datos:_

```
kubectl exec -it mongo-0 sh
mongo
```

o

```
kubectl exec -it mongo-1 sh
mongo
```

o

```
kubectl exec -it mongo-2 sh
mongo
```

_- Ejecutamos el siguiente código sino nos dará fallo a la hora de mostrar los datos de nuestra db creada:_

```
rs.secondaryOk()
show dbs
use test
show tables
db.students.find()
```
Ver imagen "BusquedaDatosMongo.png" en la carpeta para ver los resultados.

_- Diferencias  que  existiría  si  el  montaje  se  hubiera realizado  con  el  objeto  de ReplicaSet:_

- Las instancias (pods) no tendrian un nombre fijo tipo [mongo-"número consecutivo empezando por 0"] y serian del tipo [mongo-"cadena de números aleatorios creqados por kubernetes"].
- Por culpa del punto anterior sería imposible configurar el replicaset dentro de mongo ya que cada vez que caiese un pod y se levantara uno nuevo cambiara el nombre y no lo crearia con el mismo nombre que tenia anteriormente.