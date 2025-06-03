FROM node:12.21.0-buster-slim as base

# This image is NOT made for production use.
LABEL maintainer="Eero Ruohola <eero.ruohola@shuup.com>"

RUN apt-get update \
    && apt-get --assume-yes install \
        postgresql-client \
        gettext \
        build-essential \
        libcairo2-dev \
        libpangocairo-1.0-0 \
        python3 \
        python3-dev \
        python3-pil \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        libxml2-dev \
        libxslt1-dev \
        libffi-dev \
        libpq-dev \
        curl \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && rm -rf /var/lib/apt/lists/ /var/cache/apt/

ENV PATH="/root/.cargo/bin:${PATH}"

# These invalidate the cache every single time but
# there really isn't any other obvious way to do this.
COPY . /app
WORKDIR /app

# The dev compose file sets this to 1 to support development and editing the source code.
# The default value of 0 just installs the demo for running.
ARG editable=1

RUN pip3 install markupsafe==2.0.1
RUN pip3 install --upgrade pip && pip3 install django==2.2.24 psycopg2==2.8.6 \
    && pip3 install --upgrade setuptools

RUN if [ "$editable" -eq 1 ]; then pip3 install -r requirements-tests.txt && python3 setup.py build_resources; else pip3 install shuup; fi

RUN curl -o /usr/local/bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x /usr/local/bin/wait-for-it.sh

RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]

# RUN python3 -m shuup_workbench migrate
# RUN python3 -m shuup_workbench shuup_init

# RUN echo '\
# from django.contrib.auth import get_user_model\n\
# from django.db import IntegrityError\n\
# try:\n\
#     get_user_model().objects.create_superuser("admin", "admin@admin.com", "admin")\n\
# except IntegrityError:\n\
#     pass\n'\
# | python3 -m shuup_workbench shell


# CMD ["python3", "-m", "shuup_workbench", "runserver", "0.0.0.0:8000"]
