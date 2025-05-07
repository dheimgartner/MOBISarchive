\copy (SELECT * FROM motion_tag_trips LIMIT 100) TO '~/MOBISarchive/example_trips.csv' WITH CSV HEADER DELIMITER ';'
