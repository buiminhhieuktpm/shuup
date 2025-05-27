#!/bin/bash
set -e

/usr/local/bin/wait-for-it.sh postgres:5432 --timeout=60 --strict -- echo "Postgres is up"

python3 -m shuup_workbench migrate
python3 -m shuup_workbench shuup_init

echo '
from django.contrib.auth import get_user_model
from django.db import IntegrityError
try:
    get_user_model().objects.create_superuser("admin", "admin@admin.com", "admin")
except IntegrityError:
    pass
' | python3 -m shuup_workbench shell

exec python3 -m shuup_workbench runserver 0.0.0.0:8000