FROM python:3.8-slim

ADD . /app
WORKDIR /app

RUN apt update
# install dependencies
RUN apt -y install --no-install-recommends curl

# setup certificates
RUN curl -o ca-viasat-io.crt https://cacerts.viasat.io/ca-viasat-io.crt # legacy
RUN mv ca-viasat-io.crt /usr/local/share/ca-certificates/ca-viasat-io.crt
RUN curl -o ca-viasat-io.crt https://cacerts.viasat.io/viasatio.crt     # PKI root
RUN mv ca-viasat-io.crt /usr/local/share/ca-certificates/ca-viasat-io-pki.crt
RUN update-ca-certificates
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

RUN mkdir -p /.local && chmod -R 777 /.local

# install dependencies
RUN pip3 install pip setuptools --upgrade
RUN pip3 install tox==3.26.0
RUN pip3 install twine pdoc3 isort black
RUN pip3 install -r requirements.txt
RUN pip3 install -r test-requirements.txt

CMD /bin/bash
