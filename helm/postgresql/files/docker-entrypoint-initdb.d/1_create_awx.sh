
#!/bin/bash
set -e

POSTGRES="psql -h 127.0.0.1 --username postgres"

echo "Creating database role: awx-user"

$POSTGRES <<-EOSQL
CREATE USER awx WITH CREATEDB PASSWORD '11awx00';
EOSQL
