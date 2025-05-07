.PHONY: all motion_tag_trips motion_tag_waypoint motion_tag_waypoint_covid

all: motion_tag_trips motion_tag_waypoint motion_tag_waypoint_covid

motion_tag_trips:
	bash ./main.sh motion_tag_trips > log/motion_tag_trips

motion_tag_waypoint:
	bash ./main.sh motion_tag_waypoint > log/motion_tag_waypoint

motion_tag_waypoint_covid:
	bash ./main.sh motion_tag_waypoint_covid > log/motion_tag_waypoint_covid
