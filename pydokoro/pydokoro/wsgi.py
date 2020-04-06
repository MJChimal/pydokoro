"""
WSGI config for transformacion_urbana project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/2.0/howto/deployment/wsgi/
"""

import os

import sys

from django.core.wsgi import get_wsgi_application

proj_path = (os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir))

sys.path.append(os.path.join(proj_path, '..'))

os.environ.setdefault("DJANGO_SETTINGS_MODULE", 'pydokoro.settings.production')

sys.path.append(proj_path)

os.chdir(proj_path)

application = get_wsgi_application()