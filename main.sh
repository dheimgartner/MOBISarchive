#!/bin/bash

HOST="id-hdb-psgr-cp50.ethz.ch"
PORT=5432
DBNAME="mobis_study"
USER="mobis"

# arg: sql code to execute
sql() {
  psql -h $HOST -p $PORT -d $DBNAME -U $USER -c "$1"
}

# arg: table
get_start_date() {
  read start_date <<< $(psql -h $HOST -p $PORT -d $DBNAME -U $USER -t -A -c \
    "SELECT MIN(tracked_at) FROM $1;")
  date=$(echo "$start_date" | cut -d' ' -f1)
  echo $date
}

# arg: table
get_end_date() {
  read end_date <<< $(psql -h $HOST -p $PORT -d $DBNAME -U $USER -t -A -c \
    "SELECT MAX(tracked_at) FROM $1;")
  date=$(echo "$end_date" | cut -d' ' -f1)
  echo $date
}

# arg: table
main() {
  ## get start and end date
  start_date=$(get_start_date "$1")
  end_date=$(get_end_date "$1")

  ## loop by month
  current_date=$start_date
  while [[ "$current_date" < "$end_date" ]]; do
    year=$(date -d "$current_date" +%Y)
    month=$(date -d "$current_date" +%m)
    next_month=$(date -d "$current_date + 1 month" +%Y-%m-%d)

    ## execute main query
    sql "\copy (
      SELECT * FROM $1
      WHERE tracked_at >= DATE '$current_date'
      AND tracked_at < DATE '$next_month'
    ) TO '$1_${year}_${month}.csv' WITH CSV HEADER DELIMITER ';'"

    ## increment
    current_date=$next_month
  done
}

case "$1" in
  dump)
    main "$2"
    ;;
  *)
    echo "Usage $0 dump <table>"
    ;;
esac
