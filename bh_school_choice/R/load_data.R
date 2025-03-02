##load data script
library(shiny)
library(leaflet)
library(sf)
library(dplyr)
library(tidyverse)
library(viridis)
library(janitor)
library(shinylive)
library(httpuv)
library(here)


#BN_pcds_to_school_dist <- st_read("https://www.dropbox.com/scl/fi/hbbcjavns1n873yyxbz3d/BN_pcds_to_school_dist.gpkg?rlkey=t3t2ty3r5596vmzxbyzlnd2sx&raw=1") %>% st_transform(4326)
BN_pcds_to_school_dist <- st_read("BN_pcds_to_school_dist.gpkg") %>% st_transform(4326)


#brighton_sec_schools <- read_csv("https://www.dropbox.com/scl/fi/fhzafgt27v30lmmuo084y/edubasealldata20241003.csv?rlkey=uorw43s44hnw5k9js3z0ksuuq&raw=1") %>%
brighton_sec_schools <- read_csv("edubasealldata20241003.csv") %>%
   clean_names() %>%
   filter(la_name == "Brighton and Hove") %>%
   filter(phase_of_education_name == "Secondary") %>%
   filter(establishment_status_name == "Open") %>%
   st_as_sf(., coords = c("easting", "northing")) %>%
   st_set_crs(27700) %>%
   st_transform(4326) %>%
   st_set_crs(4326)
#
bh_sec_sch <- brighton_sec_schools %>%
   select(urn, establishment_name, geometry) %>%
   rename(id = urn)
#
coords <- st_coordinates(bh_sec_sch)
bh_sec_sch$lon <- coords[, 1]
bh_sec_sch$lat <- coords[, 2]

# # Convert dataframes to sf objects
BN_pcds_to_school_dist <- st_as_sf(BN_pcds_to_school_dist)
brighton_sec_schools <- st_as_sf(brighton_sec_schools)
# 
#Perform the spatial join
BN_pcds_to_school_dist <- st_join(BN_pcds_to_school_dist, brighton_sec_schools, join = st_nearest_feature)
# 
# Select and rename columns
BN_pcds_to_school_dist <- BN_pcds_to_school_dist %>%
  select(origin_id, destination_id, entry_cost, network_cost, exit_cost, total_cost, geom, school_name = establishment_name)

