#!/bin/bash
source /opt/circonus/etc/pg-conf.sh

which psql >/dev/null 2>&1 || exit 1
PGUSER="${PGUSER:="postgres"}"
PGDATABASE="${PGDATABASE:="postgres"}"
OLDIFS=$IFS
LINEBREAKS=$'\n\b'

DB_LIST=$(psql -U "$PGUSER" -F, -Atc "SELECT buffers_checkpoint, buffers_clean, buffers_backend, buffers_alloc FROM pg_stat_bgwriter" $PGDATABASE)

for db in $DB_LIST; do
   IFS=','
  DATA=( `echo "${db}"` )
  echo -e "buffers_at_checkpoint\tL\t${DATA[0]}"
  echo -e "buffers_cleaned\tL\t${DATA[1]}"
  echo -e "buffers_by_backend\tL\t${DATA[2]}"
  echo -e "buffers_allocated\tL\t${DATA[3]}"
done

