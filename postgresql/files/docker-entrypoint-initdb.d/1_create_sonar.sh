
#!/bin/bash
set -e

POSTGRES="psql -h 127.0.0.1 --username postgres"

echo "Creating database role: sonar-user"

$POSTGRES <<-EOSQL
CREATE USER sonar WITH CREATEDB PASSWORD '11sonar00';
EOSQL
