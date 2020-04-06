FROM python:3.7

# build deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    wget

RUN mkdir /var/log/uwsgi

# Install dockerize to wait db to be ready

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Web app source code
COPY . /app
WORKDIR /app

RUN set -ex && pip install -U pipenv
RUN set -ex && pipenv install --deploy --system
RUN set -ex && pip install -U uwsgi

RUN chmod +x /app/entrypoint.sh

EXPOSE 3031

ENTRYPOINT [ "/app/entrypoint.sh" ]

CMD [ "uwsgi", "--socket", "0.0.0.0:3031", \
               "--protocol", "uwsgi", \
               "--wsgi", "pydokoro.pydokoro.wsgi:application" ]
