\copy (SELECT * FROM motion_tag_waypoint_covid LIMIT 100) TO '~/MOBISarchive/example_waypoint_covid.csv' WITH CSV HEADER DELIMITER ';'
