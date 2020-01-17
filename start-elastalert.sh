#!/usr/bin/env bash

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

set -e

# Check if the Elastalert index exists in Elasticsearch and create it if it does not.
if ! wget ${WGET_OPTIONS} -O - "${WGET_SCHEMA}${WGET_AUTH}${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/${ELASTALERT_INDEX}" 2>/dev/null; then
  echo "Creating Elastalert index in Elasticsearch..."
  elastalert-create-index ${CREATE_EA_OPTIONS} \
    --host "${ELASTICSEARCH_HOST}" \
    --port "${ELASTICSEARCH_PORT}" \
    --config "${ELASTALERT_CONFIG}" \
    --index "${ELASTALERT_INDEX}" \
    --old-index ""
else
  echo "Elastalert index already exists in Elasticsearch."
fi

echo "Starting Elastalert..."
elastalert --verbose --config "${ELASTALERT_CONFIG}"
