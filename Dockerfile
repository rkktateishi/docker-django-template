FROM python:3
ENV PYTHONBUFFERED 1
RUN mkdir /code
WORKDIR /code
ADD requirements/base.txt /code/
RUN apt-get update
RUN apt-get install -qq binutils libproj-dev gdal-bin postgresql
ADD . /code/
VOLUME /var/logs/gunicorn
EXPOSE 8000
