FROM python:3.6-slim

RUN apt-get update && apt-get install -y git

RUN pip3 install --user --upgrade git+https://github.com/twintproject/twint.git@origin/master#egg=twint
