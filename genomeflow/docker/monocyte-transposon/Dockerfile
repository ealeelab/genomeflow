FROM gcr.io/aleelab-ten/rtea-tcga:2.1.17

## Additional Program Installation
WORKDIR /app

## Change ncbi file
COPY user-settings.mkfg rtea/

## Update worker.py
COPY worker.py rtea/

CMD python /app/rtea/worker.py 2>&1 | tee /app/rtea/worker.log

