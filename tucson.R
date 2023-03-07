# interrogation openstreetmap data 
# Sanjay Kumar V
# sanjay.murthy.29@gmail.com
# 2023-03-07

library(osmdata)
library(ggplot2)

# A 2x2 matrix
tucson_bb <- matrix(data = c(-111.0, -110.7, 31.0, 32.3),
                    nrow = 2,
                    byrow = TRUE)
# Update column and row names
colnames(tucson_bb) <- c("min", "max")
rownames(tucson_bb) <- c("x", "y")
# Print the matrix to the console
tucson_bb

# Use the bounding box defined for Tucson by OSM
tucson_bb <- getbb("Tucson")
# Print the matrix to the console
tucson_bb

tucson_major <- getbb(place_name = "Tucson") %>%
  opq(timeout = 50) %>%
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", "secondary")) %>%
  osmdata_sf()


tucson_major

# Create the plot object, using the osm_lines element of tucson_major
street_plot <- ggplot() +
  geom_sf(data = tucson_major$osm_lines,
          inherit.aes = FALSE,
          color = "black",
          size = 0.2)
# Print the plot
street_plot

tucson_minor <- getbb(place_name = "Tucson") %>%
  opq(timeout = 50) %>%
  add_osm_feature(key = "highway", value = c("tertiary", "residential")) %>%
  osmdata_sf()

# Create the plot object, using the osm_lines element of tucson_minor
street_plot <- street_plot +
  geom_sf(data = tucson_minor$osm_lines,
          inherit.aes = FALSE,
          color = "#666666",  # medium gray
          size = 0.1) # half the width of the major roads
# Print the plot
street_plot

# Query for Tucson restaurants
tucson_rest <- getbb(place_name = "Tucson") %>%
  opq(timeout = 50) %>%
  add_osm_feature(key = "amenity", value = "restaurant") %>%
  osmdata_sf()

tucson_rest

# Query for Tucson restaurants, them filter to mexican cuisine
tucson_rest <- getbb(place_name = "Tucson") %>%
  opq(timeout = 50) %>%
  add_osm_feature(key = "amenity", value = "restaurant") %>%
  add_osm_feature(key = "cuisine", value = "mexican") %>% # filters results
  osmdata_sf()

tucson_rest

# Create a new plot object, starting with the street map
rest_plot <- street_plot +
  geom_sf(data = tucson_rest$osm_points,
          inherit.aes = FALSE,
          size = 1.5,
          color = "#1B9E77") # approximately "elf green"???
# Print the plot
rest_plot

# Create a new plot object, starting with the street map
rest_plot <- street_plot +
  geom_sf(data = tucson_rest$osm_points,
          inherit.aes = FALSE,
          size = 1.5,
          color = "#1B9E77") +
  coord_sf(ylim = c(32.1, 32.3), # Crop out southern part of map
           expand = FALSE)  # if we don't set, will expand to fit data
# Print map
rest_plot

# Create a new plot object, starting with the street map
rest_plot <- street_plot +
  geom_sf(data = tucson_rest$osm_points,
          inherit.aes = FALSE,
          size = 1.5,
          color = "#1B9E77") +
  coord_sf(ylim = c(32.1, 32.3), # Crop out southern part of map
           expand = FALSE) + # if we don't set, will expand to fit data
  theme_void() # remove gray background
# Print map
rest_plot
