FROM python:2.7
MAINTAINER junseok.park@childrens.harvard.edu

ARG GOOGLE_CREDENTIAL_FILE
ARG GOOGLE_BUCKET
ARG JUPYTER_TOKEN_KEY

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
    iputils-ping libfontconfig1-dev libcairo2-dev \
    software-properties-common \
    libgit2-dev \
    apt-transport-https

RUN apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main' \
    && apt-get update -y && apt-get install -y openjdk-8-jdk

RUN add-apt-repository 'deb http://cloud.r-project.org/bin/linux/debian buster-cran35/' \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 'B8F25A8A73EACF41' \
    && apt update -y && apt -y install r-base

## Prerequisites Program Installation
WORKDIR /app

RUN wget https://github.com/alexdobin/STAR/archive/2.5.2a.tar.gz \
    && tar -xzf 2.5.2a.tar.gz \
    && cd STAR-2.5.2a/source \
    && make STAR \
    && ln -s /app/STAR-2.5.2a/source/STAR /usr/local/bin/STAR \
    && cd /app \
    && rm -rf 2.5.2a.tar.gz

RUN wget https://github.com/samtools/samtools/releases/download/1.12/samtools-1.12.tar.bz2 \
    && tar -xjf samtools-1.12.tar.bz2 \
    && cd samtools-1.12 \
    && ./configure \
    && make \
    && make install \
    && cd /app \
    && rm -r samtools-1.12.tar.bz2 samtools-1.12

RUN git clone https://github.com/griffithlab/regtools \
    && cd regtools/ \
    && mkdir build \
    && cd build/ \
    && cmake .. \
    && make \
    && ln -s /app/regtools/build/regtools /usr/local/bin/regtools \
    && cd /app

RUN git clone https://github.com/chaolinzhanglab/olego.git \
    && cd olego \
    && sed 's/-m64/#-m64/g' Makefile >> Makefile.new \
    && mv Makefile Makefile.old \
    && mv Makefile.new Makefile \
    && make \
    && ln -s /app/olego/olego /usr/local/bin/olego \
    && cd /app

RUN wget ftp://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz \
    && tar -zxvf gsl-2.7.tar.gz \
    && cd gsl-2.7 \
    && ./configure \
    && make \
    && make install \
    && cd /app \
    && rm -r gsl-2.7.tar.gz

## R Package Installs
ENV LD_LIBRARY_PATH=/usr/local/lib

ADD installLeafCutter.R /app/installLeafCutter.R

RUN Rscript /app/installLeafCutter.R

## Downloader for SRA-Toolkit (GTEx Samples)
RUN wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz \
    && tar -zxvf sratoolkit.current-ubuntu64.tar.gz \
    && ln -s /app/sratoolkit.2.11.2-ubuntu64 /app/sratoolkit \
    && rm -r sratoolkit.current-ubuntu64.tar.gz

ENV PATH=/app/sratoolkit/bin:$PATH
RUN echo "Aexyo" | vdb-config -i

# Install Python Env based on miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /miniconda
ENV PATH=$PATH:/miniconda/condabin:/miniconda/bin
COPY packages packages

## Google Cloud Install and Setup based on user defined key
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
 | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
 | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y \
  && apt-get install google-cloud-sdk -y && apt-get -y autoremove && apt-get -y clean

RUN mkdir /root/keys
COPY ${GOOGLE_CREDENTIAL_FILE} /root/keys/google-key.json
ENV GOOGLE_BUCKET=${GOOGLE_BUCKET}
ENV GOOGLE_APPLICATION_CREDENTIALS="/root/keys/google-key.json"

## Install Conda for Notebook
RUN conda env update -f packages/environment_base.yml
RUN for kernel in $(jupyter kernelspec list | awk 'FNR>=2 {print $1}'); do jupyter kernelspec remove -f $kernel; done
RUN /miniconda/bin/python -m ipykernel install --name base --display-name "Python 3"

# For iPython debugger
RUN apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates && curl -sL \
    https://deb.nodesource.com/setup_12.x | sudo -E bash - && apt -y install nodejs
RUN jupyter labextension install @jupyterlab/debugger
RUN conda install xeus-python -c conda-forge --yes


## R Env for Jupyter Notebook
RUN R -e "install.packages('IRkernel')"
RUN R -e "IRkernel::installspec(user = FALSE)"

RUN rm -rf packages
RUN rm Miniconda3-latest-Linux-x86_64.sh

# Conda Init
SHELL ["/bin/bash","-c"]
RUN conda init
RUN echo 'conda activate base' >> ~/.bashrc

# Port for ipython notebook and RStudio
EXPOSE 8888 8787

COPY getTokenFromPassword.py /usr/local/bin/getTokenFromPassword
COPY entry_point.sh /root/entry_point.sh
RUN chmod +x /root/entry_point.sh
ENTRYPOINT ["/root/entry_point.sh"]
