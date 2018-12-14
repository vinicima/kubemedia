#!/bin/bash
set -e

POSTGRES="psql -h 127.0.0.1 --username postgres"

echo "Creating database: sonar-db"

$POSTGRES <<EOSQL
CREATE DATABASE sonardb OWNER sonar;
EOSQL
