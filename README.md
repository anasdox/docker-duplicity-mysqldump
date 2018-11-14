
Exemple : 
```
docker run --rm \
    -v $PWD:/app \
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