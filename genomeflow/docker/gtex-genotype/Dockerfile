#######################################################################
#     Basic image
#######################################################################
FROM ubuntu:16.04
MAINTAINER Chong Simon Chu (chong.simon.chu@gmail.com), Michele Berselli (berselli.michele@gmail.com)

#######################################################################
#     General updates & installing necessary Linux components
#######################################################################
RUN apt-get update -y && apt-get install -y \
    bzip2 \
    gcc \
    git \
    less \
    libncurses-dev \
    make \
    time \
    unzip \
    vim \
    wget \
    zlib1g-dev \
    liblz4-tool \
    python3-pip

#######################################################################
#     Setting working env
#######################################################################
WORKDIR /usr/local/bin

#######################################################################
#     Software
#######################################################################
## conda and pysam
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.10.3-Linux-x86_64.sh && bash Miniconda3-py38_4.10.3-Linux-x86_64.sh -p /miniconda -b
ENV PATH=/miniconda/bin:$PATH
RUN conda config --add channels r \
    && conda config --add channels bioconda \
    && conda install -c conda-forge libgcc-ng \
    && conda install -c bioconda samtools==1.6 \
    && conda install -c bioconda bwa==0.7.17 \
    && conda install pysam==0.17.0 sortedcontainers==2.4.0 numpy==1.22.3 pandas==1.4.2 scikit-learn==1.0.2 -y

## deep-forest
RUN pip install deep-forest==0.1.5

#######################################################################
#     Scripts
#######################################################################
## xTea
RUN git clone https://github.com/parklab/xTea.git && \
    cd xTea && \
    git checkout v0.1.9 && \
    cd .. && \
    cp -r xTea/xtea/* .
RUN rm -rf xTea
RUN chmod +x *.py

#######################################################################
#     Setting env variables
#######################################################################
## Supporting UTF-8
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

## Removed by GenomeFlow
# CMD ["ls /usr/local/bin"]

## Added for samples download
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.7_amd64.deb \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0-dev_1.0.2n-1ubuntu5.7_amd64.deb \
    && apt-get install -y ./*.deb \
    && apt-get install -y gnupg gnupg2 gnupg1


RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
 | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
 | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y \
  && apt-get install google-cloud-sdk -y && apt-get -y autoremove && apt-get -y clean

## Copy key and setup for the key
RUN mkdir /root/keys
ARG GOOGLE_CREDENTIAL_FILE
COPY ${GOOGLE_CREDENTIAL_FILE} /root/keys/google-key.json
ENV GOOGLE_APPLICATION_CREDENTIALS="/root/keys/google-key.json"

RUN gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
ARG GCP_PROJECT
RUN gcloud config set project $GCP_PROJECT


## GenomeFlow Modules
COPY referenceDownload.sh /app/bin/referenceDownload.sh
COPY sampleDownload.sh /app/bin/sampleDownload.sh
COPY additionalPrograms.sh /app/bin/additionalPrograms.sh
RUN chmod +x /app/bin/referenceDownload.sh /app/bin/sampleDownload.sh /app/bin/additionalPrograms.sh
COPY worker.py /app/bin/worker.py

CMD python /app/bin/worker.py 2>&1 | tee /app/bin/worker.log