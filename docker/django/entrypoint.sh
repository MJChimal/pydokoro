#!/bin/sh

set -e

wait_for_db() {
    if [ -z "$DJANGO_DATABASE_HOST" ] || [ -z "$DJANGO_DATABASE_PORT" ]; then
        echo "No django database host or port, not waiting for db."
    else
        echo "Waiting for database"
        dockerize -wait tcp://"$DJANGO_DATABASE_HOST":"$DJANGO_DATABASE_PORT" -timeout 30s
    fi
}

until wait_for_db; do
    >&2 echo "MySQL is unavailable - sleeping"
done

>&2 echo "MySQL is up - continuing..."


exec "$@"