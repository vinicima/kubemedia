
#!/bin/bash
set -e

POSTGRES="psql -h 127.0.0.1 --username postgres"

echo "Creating database role: gitlab-user"

$POSTGRES <<-EOSQL
CREATE USER gitlab WITH CREATEDB PASSWORD '11gitlab00';
EOSQL
