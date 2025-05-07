#!/bin/bash

# Database credentials

DB_USER="USER"

DB_NAME="DB"

# Loop through each month of 2019

for month in {01..12}

do

    # Define the start and end date for the month

    START_DATE="2019-$month-01"

    END_DATE="2019-$month-31"

    # Export data to CSV

    psql -U $DB_USER -d $DB_NAME -c "\copy (SELECT * FROM example_table WHERE timestamp_col >= DATE '$START_DATE' AND timestamp_col < (DATE '$START_DATE' + INTERVAL '1 month')) TO 'export_2019_$month.csv' CSV HEADER"

done
