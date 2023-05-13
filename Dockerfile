ARG MYSQL_VERSION=8.0.33
FROM mysql:${MYSQL_VERSION}

# Define the ARG variables
ARG CONSUL_VERSION=1.15.2
ARG PROXYSQL_VERSION=2.5.2

# Define the ARG variables as ENV variables so they are available at runtime
ENV CONSUL_VERSION=${CONSUL_VERSION}
ENV PROXYSQL_VERSION=${PROXYSQL_VERSION}

WORKDIR /cluster
COPY ./mysql_cluster_manager/ .

RUN chmod +x ./install.sh && \
    ./install.sh &&  \
    rm install.sh

#ENTRYPOINT ["bash", "-c", "set -e && ./mysql_cluster_manager.py join_or_bootstrap"]

EXPOSE 6032/tcp
CMD ["tail", "-f", "/dev/null"]
