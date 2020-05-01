FROM python:3.8

LABEL maintainer="mjchimal@gmail.com"
LABEL vendor="pydokoro"

ARG DJANGO_ENV

ENV DJANGO_ENV=${DJANGO_ENV}} \
    # python:
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  # pip:
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  # dockerize:
  DOCKERIZE_VERSION=v0.6.1 \
  # tini:
  TINI_VERSION=v0.18.0 \
  # poetry:
  POETRY_VERSION=1.0.5 \
  POETRY_VIRTUALENVS_CREATE=false \
  POETRY_CACHE_DIR='/var/cache/pypoetry'

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    bash \
    build-essential \
    curl \
    gettext \
    git \
    libpq-dev \
    wget \
  # Cleaning cache:
  && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* \
  # Installing `dockerize` utility:
  # https://github.com/jwilder/dockerize
  && wget "https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" \
  && tar -C /usr/local/bin -xzvf "dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" \
  && rm "dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" && dockerize --version \
  # Installing `tini` utility:
  # https://github.com/krallin/tini
  && wget -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" \
  && chmod +x /usr/local/bin/tini && tini --version \
  # Installing `poetry` package manager:
  # https://github.com/python-poetry/poetry
  && pip install "poetry==$POETRY_VERSION" && poetry --version

WORKDIR /app

COPY ./poetry.lock ./pyproject.toml /app/

# Project initialization:
RUN echo "$DJANGO_ENV" \
  && poetry install \
    $(if [ "$DJANGO_ENV" = 'production' ]; then echo '--no-dev'; fi) \
    --no-interaction --no-ansi \
  # Cleaning poetry installation's cache for production:
  && if [ "$DJANGO_ENV" = 'production' ]; then rm -rf "$POETRY_CACHE_DIR"; fi

COPY ./docker/django/entrypoint.sh /docker-entrypoint.sh


RUN chmod +x '/docker-entrypoint.sh' \
  && groupadd -r web && useradd -d /app -r -g web web \
  && chown web:web -R /app

USER web

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

# FROM development_build as production_build
COPY --chown=web:web . /app