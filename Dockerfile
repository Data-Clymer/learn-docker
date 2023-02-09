#dbt core for Snowflake with preinstalled dbt labs packages

# Top level build args
ARG build_for=linux/amd64

##
# base image (abstract)
##
FROM --platform=$build_for python:3.10.7-slim-bullseye as base

ARG dbt_snowflake_ref=dbt-snowflake@v1.4.0

# System setup
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    git \
    ssh-client \
    software-properties-common \
    make \
    build-essential \
    ca-certificates \
    libpq-dev \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# Env vars
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# Update python
RUN python -m pip install --upgrade pip setuptools wheel --no-cache-dir

WORKDIR /usr/app/dbt/
VOLUME /usr/app

# ENTRYPOINT ["dbt"]

FROM base as dbt-snowflake

RUN python -m pip install --no-cache-dir dbt-snowflake

CMD ["git clone", "REPO"]

RUN dbt build
