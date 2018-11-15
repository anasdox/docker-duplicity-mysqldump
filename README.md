
Exemple : 
```
docker run --rm \
    -v $PWD:/app \
    -v ~/.ssh/id_rsa:/id_rsa:ro \
    -v ~/.ssh/known_hosts:/etc/ssh/ssh_known_hosts:ro \
    -e DATABASE_HOST=mariadb \
    -e DATABASE_PORT=3306 \
    -e DATABASE_USER=user1 \
    -e DATABASE_PASSWORD=blablabalabla \
    -e DATABASE_NAME=dbname \
    -e DATABASE_DUMP_DIR_PATH=/tmp/dump \
    -e DUPLICITY_INCLUD=/app/var/uploads \
    -e DUPLICITY_DEST=file:///tmp/backup \
    anasdox/duplicity-mysqldump \
    /backup.sh
```