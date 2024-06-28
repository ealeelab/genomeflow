# Basic airflow and utility imports


## Reference Files
# Concurrency
# Local Executor
# https://stackoverflow.com/questions/55278947/apache-airflow-run-all-parallel-tasks-in-single-dag-run
# RabbitMQ
# https://medium.com/sicara/using-airflow-with-celery-workers-54cb5212d405
# https://www.sicara.ai/blog/2019-04-08-apache-airflow-celery-workers
# https://www.accionlabs.com/how-to-setup-airflow-multinode-cluster-with-celery-rabbitmq

# https://airflow.apache.org/docs/apache-airflow-providers-google/stable/operators/cloud/index.html

from datetime import datetime, timedelta
from os import environ
from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
# Kubernetes airflow components
from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator  #, Volume, VolumeMount
#from airflow.contrib.kubernetes import secret, pod


# Volume mount example
# -----------------------
# "pv-airflow" is the name of a persistentvolume in the kubernetes cluster that runs Google Cloud Composer,
# which in turn points to a persistent disk in Google Compute Engine that can be used to move files between
# tasks in Airflow/Cloud Composer.
# The mount_path is the directory that will be mounted in running containers.
# Your containers will be able to read and write to this path in order to move files between tasks + containers.
# volume_mount = VolumeMount('pv-ad-airflow',
#                            mount_path='/data',
#                            sub_path=None,
#                            read_only=False)
# volume_config= {
#     'persistentVolumeClaim':
#     {
#         'claimName': 'pv-ad-claim-airflow'
#     }
# }
# volume = Volume(name='pv-ad-airflow', configs=volume_config) # The name here should match the volume mount.

# Node affinity
# ----------------
# You can optionally set a node affinity to run a task in a different node pool in kubernetes
# than the one used by Google Cloud Composer.
# I've set aside an auto-scaling node pool of higher-memory instances, called "airflow-dev-working", for machine learning
node_affinity={
        'nodeAffinity': {
            'requiredDuringSchedulingIgnoredDuringExecution': {
                'nodeSelectorTerms': [{
                    'matchExpressions': [{
                        'key': 'cloud.google.com/gke-nodepool',
                        'operator': 'In',
                        'values': [
                            'airflow-dev-working',
                        ]
                    }]
                }]
            }
        }
}


# DAG definitions
# ------------------
# DAGs (Directed Acyclic Graphs) are the sequences that execute Airflow tasks
# This is just a generic example set of default Airflow DAG configurations
# See more info about writing DAGs and Airflow here:
# http://michal.karzynski.pl/blog/2017/03/19/developing-workflows-with-apache-airflow/
# https://www.astronomer.io/guides/dag-best-practices/
# https://github.com/jghoman/awesome-apache-airflow
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    # start_date defines when a task starts -- important!
    # Be careful with this as if the time is set before now, Airflow will attempt to "catch up"
    # by default, by running the task many times; see https://airflow.apache.org/scheduler.html
    # This can be disabled by setting catchup=False (see below)
    'start_date': datetime(2019,4,1),
    'email': ['junseokpark.kr@gmail.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}

dag = DAG(
    # The DAG ID: try to version this as this is how the metadata database tracks it
    'ad_transposon_dl',
    default_args=default_args,
    # Can be defined as an interval or cron; see documentation
    # Important, as this defines how often the task is run
    schedule_interval=timedelta(minutes=10),
    # Important! Catchup defaults to "true", which means airflow will attempt backfill runs
    # if the start date is before now (in UTC)
    catchup = False
)


# This is an example task container (using a generic ubuntu image) that pulls a SELECT 20 of data
# from the loan table from Snowflake using snowsql, and then writes the result to the persistent disk.

# Multi-Core-Test
synapseDownloader = KubernetesPodOperator (
    namespace = 'composer-1-17-2-airflow-2-1-2-e1e89060',
    image_pull_policy='Always',
    image='gcr.io/aleelab-genomeflow/downloader:synapse',
    cmds=["synapes","-u","nuggiowl","-p","chlwowns","get",],
    name="dl-synapse",
    task_id="dl-synapse-task",
#    do_xcom_push=True,
    get_logs=True,
    dag=dag,
    startup_timeout_seconds = 300
    # volumes = [volume],
    # volume_mounts = [volume_mount],
    # id_delete_operator_pod=True

)


HISAT2Alignment = KubernetesPodOperator (
    namespace = 'composer-1-17-2-airflow-2-1-2-e1e89060',
    image_pull_policy='Always',
    image='grc.io/synapseDownloader:',
    cmds=["echo","SAMPLE_ID","&&","ls","-alF","/data"],
    name="hisatAlignment",
    task_id="alignment-hisat2-task",
#    do_xcom_push=True,
    get_logs=True,
    dag=dag,
    startup_timeout_seconds = 300
    # volumes = [volume],
    # volume_mounts = [volume_mount],
    # id_delete_operator_pod=True
)

# upload_file = LocalFilesystemToGCSOperator(
#         task_id="upload_file",
#         src=PATH_TO_UPLOAD_FILE,
#         dst=DESTINATION_FILE_LOCATION,
#         bucket=BUCKET_NAME,
#     )
#
# download_file = GCSToLocalFilesystemOperator(
#         task_id="download_file",
#         object_name=PATH_TO_REMOTE_FILE,
#         bucket=BUCKET,
#         filename=PATH_TO_LOCAL_FILE,
#     )


## Put volumeFile to GCP bucket




# This DummyOperator doesn't do anything; it passes if the previous tasks passed
# at the very end of the DAG
end = DummyOperator(task_id='end', dag=dag)

# This is an example of using bitshift operators to specify which tasks are downstream of which tasks
synapseDownloader >> HISAT2Alignment >> end