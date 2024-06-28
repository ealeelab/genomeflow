FROM gcr.io/aleelab-ten/rtea-tcga:2.1.15b

## Install synapseClient
RUN pip install synapseclient

RUN apt-get update -y --allow-releaseinfo-change && apt-get install -y git \
    htop \
    curl \
    wget apt-utils sudo \
    build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev \
    zlib1g-dev vim \
    libncurses-dev \
    libz-dev

RUN apt-get update -y && apt-get install -y libbz2-dev liblzma-dev cmake libxml2-dev libcurl4-openssl-dev \
    libboost-dev gawk libssl-dev pigz \
    iputils-ping libfontconfig1-dev libcairo2-dev

## Additional Program Installation
WORKDIR /app

# TELocal
RUN git clone https://github.com/mhammell-laboratory/TElocal.git \
    && cd TElocal \
    && python setup.py install \
    && cd /app

## TETra
RUN git clone https://github.com/mhammell-laboratory/TEtranscripts.git \
    && cd TEtranscripts \
    && python setup.py install \
    && cd /app

## STAR
RUN wget https://github.com/alexdobin/STAR/archive/2.7.9a.tar.gz \
    && tar -xzf 2.7.9a.tar.gz \
    && cd STAR-2.7.9a/source \
    && make STAR \
    && ln -s /app/STAR-2.7.9a/source/STAR /usr/local/bin/STAR \
    && cd /app

## L1EM
RUN git clone https://github.com/FenyoLab/L1EM.git \
    && cd L1EM \
    && conda env create -f L1EM.yml \
    && cd /app
ENV PATH=/app/L1EM:$PATH

RUN ls /lib/x86_64-linux-gnu

## Temp Install for GC cloud
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.7_amd64.deb \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0-dev_1.0.2n-1ubuntu5.7_amd64.deb \
    && apt-get install -y ./*.deb \
    && apt-get install -y gnupg gnupg2 gnupg1


RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
 | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
 | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y \
  && apt-get install google-cloud-sdk -y && apt-get -y autoremove && apt-get -y clean

## Copy keys
RUN mkdir /root/keys
ARG GOOGLE_CREDENTIAL_FILE
COPY ${GOOGLE_CREDENTIAL_FILE} /root/keys/google-key.json
ENV GOOGLE_APPLICATION_CREDENTIALS="/root/keys/google-key.json"

COPY referenceDownload.sh /app/rtea/referenceDownload.sh
COPY sampleDownload.sh /app/rtea/sampleDownload.sh
COPY additionalPrograms.sh /app/rtea/additionalPrograms.sh
RUN chmod +x /app/rtea/referenceDownload.sh /app/rtea/sampleDownload.sh /app/rtea/additionalPrograms.sh
COPY worker.py /app/rtea/worker.py

RUN gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
ARG GCP_PROJECT
RUN gcloud config set project $GCP_PROJECT


CMD python /app/rtea/worker.py 2>&1 | tee /app/rtea/worker.log

