from airflow.decorators import dag, task
import pendulum

@dag(
    dag_id="hello_world_dag",
    start_date=pendulum.datetime(2025, 8, 1, tz="Asia/Colombo"),
    schedule=None,        # run on demand
    catchup=False,
    tags=["example", "hello"]
)
def hello_world():
    @task()
    def say_hello():
        print("Hello, world!")

    say_hello()

dag = hello_world()
