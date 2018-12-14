#!/bin/bash
set -e

POSTGRES="psql -h 127.0.0.1 --username postgres"

echo "Creating database: notary_server"

$POSTGRES <<EOSQL
CREATE DATABASE notary_server OWNER harbor;
EOSQL
