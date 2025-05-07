#!/bin/bash

HOST="id-hdb-psgr-cp50.ethz.ch"
PORT=5432
DBNAME="mobis_study"
USER="mobis"

connect() {
  psql -h $HOST -p $PORT -d $DBNAME -U $USER
}

run() {
  psql -h $HOST -p $PORT -d $DBNAME -U $USER -f "$1"
}

case "$1" in
  connect)
    connect
    ;;
  run)
    run "$2"
    ;;
  *)
    echo "Usage $0 {connect|run <sqlfile>}"
    ;;
esac
