# Copyright 2015-2017 Ivan Krizsan
# Copyright 2020 Kuzon Chen
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Build image with: docker-compose build --no-cache .

FROM docker.io/library/centos:7

LABEL maintainer="Ivan Krizsan, https://github.com/krizsan"
LABEL maintainer="Kuzon Chen, https://github.com/kuzoncby"

# Set this environment variable to True to set timezone on container start.
ENV SET_CONTAINER_TIMEZONE False
# Default container timezone as found under the directory /usr/share/zoneinfo/.
ENV CONTAINER_TIMEZONE UTC
# URL from which to download Elastalert.
ENV ELASTALERT_URL https://codeload.github.com/Yelp/elastalert/tar.gz/v0.2.1
# Directory holding configuration for Elastalert and Supervisor.
ENV CONFIG_DIR /opt/config
# Elastalert rules directory.
ENV RULES_DIRECTORY /opt/rules
# Elastalert configuration file path in configuration directory.
ENV ELASTALERT_CONFIG ${CONFIG_DIR}/elastalert_config.yaml
# Directory to which Elastalert and Supervisor logs are written.
ENV LOG_DIR /opt/logs
# Elastalert home directory full path.
ENV ELASTALERT_HOME /opt/elastalert
# Supervisor configuration file for Elastalert.
ENV ELASTALERT_SUPERVISOR_CONF ${CONFIG_DIR}/elastalert_supervisord.conf
# Alias, DNS or IP of Elasticsearch host to be queried by Elastalert. Set in default Elasticsearch configuration file.
ENV ELASTICSEARCH_HOST elasticsearchhost
# Port on above Elasticsearch host. Set in default Elasticsearch configuration file.
ENV ELASTICSEARCH_PORT 9200
# Use TLS to connect to Elasticsearch (True or False)
ENV ELASTICSEARCH_TLS False
# Verify TLS
ENV ELASTICSEARCH_TLS_VERIFY True
# ElastAlert writeback index
ENV ELASTALERT_INDEX elastalert_status

WORKDIR /opt
# Copy the script used to launch the Elastalert when a container is started.
COPY . /opt/

# Install Elastalert.
RUN yum install python36 python36-pip python36-devel make gcc-c++ -y && \
    python3.6 -m pip install pip --upgrade && \
    pip install "elastalert==0.2.1" && \
    mkdir -p "${CONFIG_DIR}" && \
    mkdir -p "${RULES_DIRECTORY}" && \
    mkdir -p "${LOG_DIR}" && \
    mkdir -p /var/empty && \
    chmod +x /opt/start-elastalert.sh

# Define mount points.
VOLUME [ "${CONFIG_DIR}", "${RULES_DIRECTORY}", "${LOG_DIR}"]

# Launch Elastalert when a container is started.
CMD ["bash", "/opt/start-elastalert.sh"]
