#!/bin/bash
set -e

POSTGRES="psql -h 127.0.0.1 --username postgres"

echo "Creating database: clair"

$POSTGRES <<EOSQL
CREATE DATABASE clair OWNER harbor;
EOSQL
