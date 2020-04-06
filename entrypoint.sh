#!/bin/sh

set -e

wait_for_db() {
    if [ -z "$DB_HOST" ] || [ -z "$DB_PORT" ]; then
        echo "No django database host or port, not waiting for db."
    else
        echo "Waiting for database"
        dockerize -wait tcp://"$DB_HOST":"$DB_PORT" -timeout 30s
    fi
}

wait_for_db


echo "Running migrations"
python /app/pydokoro/manage.py migrate 

# Collect static files
echo "Running collectstatic"
python /app/pydokoro/manage.py collectstatic --noinput

echo "Running capacities fixures"
python /app/pydokoro/manage.py createsuperuser


# echo "Running capacities fixures"
# python /app/pydokoro/manage.py loaddata /app/pydokoro/capacities/fixtures/*.json

# # echo "Running home fixures"
# python /app/pydokoro/manage.py loaddata /app/pydokoro/home/fixtures/*.json

# # echo "Running projects fixures"
# python /app/pydokoro/manage.py loaddata /app/pydokoro/projects/fixtures/*.json

# echo "Creating superuser"
# python /app/pydokoro/manage.py initadmin

exec "$@"