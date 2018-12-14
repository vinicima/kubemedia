#!/bin/bash
set -e

POSTGRES="psql -h 127.0.0.1 --username postgres"

echo "Creating database: registry"

$POSTGRES <<EOSQL
CREATE DATABASE registry OWNER harbor;
EOSQL
