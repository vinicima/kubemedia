#!/bin/bash
set -e

POSTGRES="psql -h 127.0.0.1 --username postgres"

echo "Creating database: awx-db"

$POSTGRES <<EOSQL
CREATE DATABASE awxdb OWNER awx;
EOSQL
