#!/bin/bash

STORAGE="/mnt/e/mobis-archive"

HOST="id-hdb-psgr-cp50.ethz.ch"
PORT=5432
DBNAME="mobis_study"
USER="mobis"

# arg: sql code to execute
sql() {
  psql -h $HOST -p $PORT -d $DBNAME -U $USER -c "$1"
}

# arg1: table
# arg2: timestamp
get_start_date() {
  read start_date <<< $(psql -h $HOST -p $PORT -d $DBNAME -U $USER -t -A -c \
    "SELECT MIN($2) FROM $1;")
  date=$(echo "$start_date" | cut -d' ' -f1)
  echo $date
}

# arg1: table
# arg2: timestamp
get_end_date() {
  read end_date <<< $(psql -h $HOST -p $PORT -d $DBNAME -U $USER -t -A -c \
    "SELECT MAX($2) FROM $1;")
  date=$(echo "$end_date" | cut -d' ' -f1)
  echo $date
}

# arg: YYYY-MM-DD
get_floor_date() {
  date=$(date -d "$1" +%Y-%m-01)
  echo "$date"
}

# arg1: table
# arg2: timestamp
# arg3: select
main() {
  ## get start and end date
  start_date=$(get_start_date "$1" "$2")
  end_date=$(get_end_date "$1" "$2")

  ## loop by month
  current_date=$(get_floor_date "$start_date")
  while [[ "$current_date" < "$end_date" ]]; do
    year=$(date -d "$current_date" +%Y)
    month=$(date -d "$current_date" +%m)
    next_month=$(date -d "$current_date + 1 month" +%Y-%m-%d)

    ## execute main query
    sql "\copy (
      SELECT $3 FROM $1
      WHERE $2 >= DATE '$current_date'
      AND $2 < DATE '$next_month'
    ) TO '$STORAGE/$1_${year}_${month}.csv' WITH CSV HEADER DELIMITER ';'"

    ## increment
    current_date=$next_month
  done
}

SELECT_WAYPOINTS="id, user_id, tracked_at, created_at, latitude, longitude, geom, accuracy, altitude"
motion_tag_waypoint() {
  main "motion_tag_waypoint" "tracked_at" "$SELECT_WAYPOINTS"
}

motion_tag_waypoint_covid() {
  main "motion_tag_waypoint_covid" "tracked_at" "$SELECT_WAYPOINTS"
}

SELECT_TRIPS="uuid, user_id, mt_trip_id, merged_into_id, started_at, finished_at, detected_finished_at, created_at, confirmed_at, updated_at, misdetected_completely, type, length, detected_length, detected_mode, mode, geometry, detected_geometry, purpose, detected_purpose, overseas"
motion_tag_trips() {
  main "motion_tag_trips" "started_at" "$SELECT_TRIPS"
}

case "$1" in
  motion_tag_waypoint)
    motion_tag_waypoint
    ;;
  motion_tag_waypoint_covid)
    motion_tag_waypoint_covid
    ;;
  motion_tag_trips)
    motion_tag_trips
    ;;
  *)
    echo "Usage $0 {motion_tag_waypoint|motion_tag_waypoint_covid|motion_tag_trips}"
    ;;
esac
