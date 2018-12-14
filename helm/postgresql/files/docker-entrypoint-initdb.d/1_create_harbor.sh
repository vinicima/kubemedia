#!/bin/bash
set -e

POSTGRES="psql -h 127.0.0.1 --username postgres"

echo "Creating database role: harbor"

$POSTGRES <<-EOSQL
CREATE USER harbor WITH CREATEDB PASSWORD '11harbor00';
EOSQL
