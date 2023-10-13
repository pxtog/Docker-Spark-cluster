FROM pxtog/cluster-base

# -- Layer: Apache Spark

ARG spark_version=3.4.1
ARG hadoop_version=3
ARG scala_version=2.13

RUN apt-get update -y && \
    apt-get install -y curl && \
    curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}-scala${scala_version}.tgz -o spark.tgz && \
    tar -xf spark.tgz && \
    mv spark-${spark_version}-bin-hadoop${hadoop_version}-scala${scala_version} /usr/bin/ && \
    mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}-scala${scala_version}/logs && \
    rm spark.tgz

ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}-scala${scala_version}
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077

# Instala el conector MySQL JDBC utilizando curl
RUN curl -L -o /tmp/mysql-connector-java-8.0.26.tar.gz https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.26.tar.gz \
    && tar -xvf /tmp/mysql-connector-java-8.0.26.tar.gz -C /tmp/ \
    && cp /tmp/mysql-connector-java-8.0.26/mysql-connector-java-8.0.26.jar $SPARK_HOME/jars/mysql-connector-java.jar \
    && rm -rf /tmp/mysql-connector-java-8.0.26 /tmp/mysql-connector-java-8.0.26.tar.gz

# -- Runtime

WORKDIR ${SPARK_HOME}