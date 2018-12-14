#!/bin/bash
set -e

POSTGRES="psql -h 127.0.0.1 --username postgres"

echo "Creating database: grafanadb"

$POSTGRES <<EOSQL
CREATE DATABASE grafanadb OWNER grafana;
EOSQL
