#!/bin/sh -xe
#
# Build the mon data base

if [ $USER != 'dbadmin' ]; then
  echo "Must be run by the dbadmin user"
  exit
fi

# Make sure the locale settings are set correctly
. /etc/profile.d/vertica_node.sh

# create the db
/opt/vertica/bin/admintools -t create_db -s 127.0.0.1 -d mon -p password

# Add in the schemas
/opt/vertica/bin/vsql -w password < /var/vertica/mon_schema.sql
/opt/vertica/bin/vsql -w password < /var/vertica/mon_metrics_schema.sql
/opt/vertica/bin/vsql -w password < /var/vertica/mon_users.sql
/opt/vertica/bin/vsql -w password < /var/vertica/mon_grants.sql

# For ssl support link the cert/key and restart the db
ln /var/vertica/catalog/server* /var/vertica/catalog/mon/v*/
/opt/vertica/bin/admintools -t stop_db -p password -d mon
/opt/vertica/bin/admintools -t start_db -p password -d mon
