\copy (SELECT * FROM motion_tag_waypoint LIMIT 100) TO '~/MOBISarchive/example_waypoint.csv' WITH CSV DELIMITER ';'
