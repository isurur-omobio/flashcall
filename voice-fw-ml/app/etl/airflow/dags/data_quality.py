from airflow import DAG
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator
from datetime import datetime

with DAG(
    dag_id="spark_example",
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,
    catchup=False,
) as dag:

    spark_job = SparkSubmitOperator(
        task_id="spark_task",
        application="/opt/spark/app/wordcount.py",
        conn_id="sparkdefault",              # references the connection
        executor_cores=2,
        executor_memory="2g",
        driver_memory="1g",
        name="wordcount_job",
    )

