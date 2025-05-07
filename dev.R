## read example_trips.csv and check if trajectory is recoverable
devtools::load_all()

library(sf)
library(DBI)
library(tidyverse)

trips <- read.delim("./example_trips.csv", sep = ";")
trip1 <- as.vector(trips[1, ])

con <- con()
sql <- paste0("SELECT * FROM motion_tag_trips WHERE uuid = '", trip1$uuid, "';")
trip1_ <- DBI::dbGetQuery(con, sql)
trip1_ <- as.vector(trip1_)

g1 <- trip1$geometry
class(g1) <- "pq_geometry"
g1_ <- trip1_$geometry

g1 == g1_

plot(st_as_sfc(g1, crs = 4326))
plot(st_as_sfc(g1_, crs = 4326))
geom <- st_as_sfc(g1_, crs = 4326)

swiss <- Heimisc::swiss_shapefiles(url = "https://data.geo.admin.ch/ch.swisstopo.swissboundaries3d/swissboundaries3d_2024-01/swissboundaries3d_2024-01_2056_5728.shp.zip")
switzerland <- swiss$landesgebiet$geometry
ggplot() +
  geom_sf(data = switzerland, fill = "cornsilk") +
  geom_sf(data = geom, col = "blue") +
  theme_minimal()

## just for fun
trips <- DBI::dbGetQuery(con, "SELECT * FROM motion_tag_trips LIMIT 10000;")
trips <- filter(trips, !overseas, type == "Track", length < 400e3)
trips <- st_as_sfc(trips$geometry, crs = 4326)
ggplot() +
  geom_sf(data = switzerland, fill = "black") +
  geom_sf(data = trips, col = "red", lwd = 1, alpha = 0.2) +
  theme_minimal()
