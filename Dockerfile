FROM python:3.6-slim

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

# install dependencies
RUN pip3 install tox
RUN pip3 install -r requirements.txt
RUN pip3 install -r test-requirements.txt

# workaround for permission denied error during package installations by mypy
RUN mkdir -p /.local
RUN chmod -R 777 /.local

CMD /bin/bash
