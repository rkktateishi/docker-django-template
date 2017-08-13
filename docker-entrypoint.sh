#!/bin/bash

set -e

settings="$1"
port="$2"
if [ "$3" -eq "0"] ; then
	dev="0"
else
	dev="$3"
fi

shift

pip install -r requirements/base.txt
python3 manage.py collectstatic --clear --noinput --settings=settings.$settings

python3 manage.py collectstatic --noinput --settings=settings.$settings

python3 manage.py migrate --settings=settings.$settings

touch /var/logs/gunicorn/gunicorn.log
touch /var/logs/gunicorn/access.log
tail -n 0 -f /var/logs/gunicorn/*.log &

exec gunicorn {{ project_name }}.wsgi:application \
	--name {{ project_name }} \
	--bind 0.0.0.0:$port \
	--workers 2 \
	--reload \
	--log-level=info \
	--log-file=/var/logs/gunicorn/gunicorn.log \
	--access-logfile=/var/logs/gunicorn/access.log
	--env DJANGO_SETTINGS_MODULE=settings.$settings
