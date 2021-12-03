# Instalar GLPI usando docker.

![Docker Pulls](https://img.shields.io/docker/pulls/ugleiton/glpi) ![Docker Stars](https://img.shields.io/docker/stars/ugleiton/glpi) [![](https://images.microbadger.com/badges/image/ugleiton/glpi.svg)](http://microbadger.com/images/ugleiton/glpi "Get your own image badge on microbadger.com") ![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/ugleiton/glpi)

## Implantar GLPI via linha de comando sem persistencia de dados ( para testes rápidos )
```sh
docker run \
  --name mysqlserver \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=glpidb \
  -e MYSQL_USER=glpi_user \
  -e MYSQL_PASSWORD=glpi \
  -d mysql/mysql-server:8.0.27 \
  /entrypoint.sh mysqld \
  --default-authentication-plugin=mysql_native_password \
  --disable_log_bin
docker run \
  --name glpi \
  --link mysqlserver:mysqlserver -p 80:80 \
  -e MYSQL_HOST=mysqlserver \
  -e MYSQL_DATABASE=glpidb \
  -e MYSQL_USER=glpi_user \
  -e MYSQL_PASSWORD=glpi -d ugleiton/glpi
```

## Implantar GLPI via linha de comando com persistencia de dados
```sh
docker run \
  --name mysqlserver \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=glpidb \
  -e MYSQL_USER=glpi_user \
  -e MYSQL_PASSWORD=glpi \
  -v /storage/docker/mysql-data:/var/lib/mysql \
  -d mysql/mysql-server:8.0.27 \
  /entrypoint.sh mysqld \
  --default-authentication-plugin=mysql_native_password \
  --disable_log_bin
docker run \
  --name glpi \
  --link mysqlserver:mysqlserver -p 80:80 \
  -e MYSQL_HOST=mysqlserver \
  -e MYSQL_DATABASE=glpidb \
  -e MYSQL_USER=glpi_user \
  -e MYSQL_PASSWORD=glpi -d ugleiton/glpi
```

# Imlantar com docker-compose

Informe no arquivo .env as variáveis de ambiente necessárias

```
MYSQL_HOST=mysqlserver
MYSQL_ROOT_HOST=%
MYSQL_ROOT_PASSWORD=pass0rddemo1
MYSQL_DATABASE=glpidb
MYSQL_USER=glpi_user
MYSQL_PASSWORD=pass0rddemo2
LANG=pt_BR
```

## sem persistencia de dados ( para testes rápidos )
```yaml
version: "3.2"

services:
  mysqlserver:
    container_name: mysqlserver
    image: mysql/mysql-server:8.0.27
    restart: always
    ports:
      - "3306:3306"
    env_file:
      - .env
    command: /entrypoint.sh mysqld --default-authentication-plugin=mysql_native_password --disable_log_bin

  glpi:
    image: ugleiton/glpi
    ports:
      - "80:80"
    restart: always
    depends_on:
      - mysqlserver
    env_file:
      - .env
```

## com persistencia de dados
```yaml
version: "3.2"

services:
  mysqlserver:
    container_name: mysqlserver
    image: mysql/mysql-server:8.0.27
    restart: always
    ports:
      - "3306:3306"
    env_file:
      - .env
    volumes:
      - /storage/docker/mysql-data:/var/lib/mysql
    command: /entrypoint.sh mysqld --default-authentication-plugin=mysql_native_password --disable_log_bin

  glpi:
    image: ugleiton/glpi
    ports:
      - "80:80"
    restart: always
    depends_on:
      - mysqlserver
    env_file:
      - .env
```


---
**NOTE**

   As contas de usuário padrão após instalação são:

   * *glpi/glpi* conta de administrador,
   * *tech/tech* conta de técnico,
   * *normal/normal* conta "normal",
   * *post-only/postonly* conta somente pós-publicação.
---
