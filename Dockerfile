FROM apache/airflow:2.8.1-python3.11

USER root
RUN apt-get update && apt-get install -y git && apt-get clean

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Switch to airflow user as required by the base image
USER airflow

# Install uv then deps as airflow user
RUN pip install --user uv && \
    pip install --user \
        dbt-core==1.7.0 \
        dbt-bigquery==1.7.0 \
        google-cloud-bigquery \
        google-cloud-bigquery-storage \
        db-dtypes \
        requests \
        pandas

# Copy dbt project
COPY --chown=airflow:root dbt/ /opt/airflow/dbt/
