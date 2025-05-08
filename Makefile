.PHONY: all mount unmount motion_tag_trips motion_tag_waypoint motion_tag_waypoint_covid

all:
	@time $(MAKE) mount motion_tag_trips motion_tag_waypoint motion_tag_waypoint_covid

mount:
	sudo mount -t drvfs E: /mnt/e

unmount:
	sudo umount /mnt/e

motion_tag_trips:
	bash ./main.sh motion_tag_trips > log/motion_tag_trips

motion_tag_waypoint:
	bash ./main.sh motion_tag_waypoint > log/motion_tag_waypoint

motion_tag_waypoint_covid:
	bash ./main.sh motion_tag_waypoint_covid > log/motion_tag_waypoint_covid
