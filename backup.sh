#!/bin/bash

set -e

readonly DATABASE_DUMP_DIR_NAME="dump"
readonly APP_ROOT_DIR="/app"

cd ${APP_ROOT_DIR}

usage()
{
    cat << EOF
usage: $0 

This script create a backup for web application
OPTIONS:
    -h        Show this message
ENV:
    DATABASE_HOST             database host, default value localhost
    DATABASE_PORT             database port, default value 3306
    DATABASE_USER             database user
    DATABASE_PASSWORD         databass password
    DATABASE_DUMP_DIR_PATH    database dump directory path, default value ${APP_ROOT_DIR}/var/dump
    DUPLICITY_INCLUD          duplicity include list, ex "dir1 dir2 dir3"
    DUPLICITY_DEST            duplicity destination
EOF
}

error() {
  echo -e "\033[31m$1\033[00m"
  kill -s TERM $TOP_PID
}

while test $# -gt 0
do
    case "$1" in
        -h )
            usage
            exit 0
            ;;
        *)
            usage
            error "No parameter needed"
            ;;
        esac
    shift
done

if [[ -z ${DATABASE_HOST} ]]; then
    DATABASE_HOST=localhost
fi

if [[ -z ${DATABASE_PORT} ]]; then
    DATABASE_HOST=3306
fi

if [[ -z ${DATABASE_USER} ]]; then
    error "DATABASE_USER env variable is mandatory"
fi

if [[ -z ${DATABASE_PASSWORD} ]]; then
    error "DATABASE_PASSWORD env variable is mandatory"
fi

if [[ -z ${DATABASE_NAME} ]]; then
    error "DATABASE_NAME env variable is mandatory"
fi

if [[ -z ${DATABASE_DUMP_DIR_PATH} ]]; then
    DATABASE_DUMP_DIR_PATH="/tmp/dump"
fi

if [[ -z ${DUPLICITY_INCLUD} ]]; then
    error "DUPLICITY_INCLUD env variable is mandatory"
fi

echo "-- Backup $(date) --"
[ -d "${DATABASE_DUMP_DIR_PATH}" ] || mkdir -p "${DATABASE_DUMP_DIR_PATH}"

echo "-- Dump database ${DATABASE_NAME} --"
mysqldump \
    -h ${DATABASE_HOST} \
    -u${DATABASE_USER} \
    -p${DATABASE_PASSWORD} \
    ${DATABASE_NAME} > "${DATABASE_DUMP_DIR_PATH}/${DATABASE_NAME}.sql"

echo "-- Push the backup via duplicity --"
duplicity \
    --full-if-older-than=6M \
    --allow-source-mismatch \
    --rsync-options='-e "ssh -i /id_rsa -o StrictHostKeyChecking=no"' \
    --no-encryption \
    --include "${DUPLICITY_INCLUD}" \
    --exclude "**" \
    ${APP_ROOT_DIR}/var \
    ${DUPLICITY_DEST}
