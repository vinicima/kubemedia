#!/bin/bash
set -e

POSTGRES="psql -h 127.0.0.1 --username postgres"

echo "Creating database role: grafana"

$POSTGRES <<-EOSQL
CREATE USER grafana WITH CREATEDB PASSWORD '11grafana00';
EOSQL
