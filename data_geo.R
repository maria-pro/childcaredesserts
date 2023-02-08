library(OpenStreetMap)
library(tidyverse)
library(sf)
library(absmapsdata)



library(tidyverse)
library(readxl)
library(janitor)
library(reactable)

library(sf)
library(absmapsdata)

theme_set(theme_minimal())
options("scipen"=100, "digits"=2)


data<-read_excel("/Users/e5028514/Desktop/ChildDesserts/data/VICNSW_for_geocodingV3.xlsx", sheet=1)

data_geo<-data%>%
  mutate(
    full_address=paste(ServiceAddress, ", ",
                             address_missing$Suburb, ", ",
                             address_missing$State, ", ",
                             address_missing$Postcode, sep="")

  )%>%
  select(
  c(ServiceApprovalNumber,
    `Provider Approval Number`,
    long, lat,
    ServiceName,
    ProviderLegalName, ServiceType, ServiceAddress,
    Suburb, State, Postcode, Phone, Fax,
    full_address,
    long, lat,
    RevisedPlaces)
)



#-------

library(OpenStreetMap)
library(osmdata)
library(tidygeocoder)

address_missing <- data_geo %>%filter(is.na(lat))

address_missing$full_address<-paste(address_missing$ServiceAddress, ", ",
                                    address_missing$Suburb, ", ",
                                    address_missing$State, ", ",
                                    address_missing$Postcode, sep="")

test<-address_missing%>%head(10)


test$text<-"Building 13, Connewarra Avenue, Aspendale, Melbourne, City of Kingston, Victoria, 3195, Australia"
test%>%
geocode(address = text, method = "osm", verbose = TRUE)



done<-test%>%
geocode(address = full_address, method = "osm", verbose = TRUE)


#google maps
library(googleway)

key <- ""
key <- ""



#"AIzaSyCDh-0018LAAPHzQU4jtQq0lFpGUXNcNyo"
set_key(key = key)
google_keys()

test%>%head(5)


for (i in test$full_address){

  df <- google_geocode(address =i,
                       key = key,
                       simplify = TRUE)
  i
  geocode_coordinates(df)
}

ggmap::register_google(key = key)

GeoCoded <- purrr::map_df(.x = address_missing$full_address, .f = ggmap::geocode)

GeoCoded%>%write_csv("GeoCoded.csv")

test_geo<-cbind(address_missing, GeoCoded
            )
test_geo_filtered<-test_geo%>%select(
  -c(3,4)
  )%>%filter(!is.na(lat))


#test_geo is saved as "geoCoded_googleway.csv" - saved with proper lat- long all manually added

#--------

data_missing<-read_csv("/Users/e5028514/Desktop/ChildDesserts/data/geoCoded_googleway.csv")

data_geo<-data_geo%>%filter(!is.na(long))

data_full<-rbind(data_geo, data_missing)



geo_data = st_as_sf(data_full, coords = c("long", "lat"), crs = 4326)

class(geo_data)


map_sa1 <- sa12021


geo_data <- st_join(map_sa1, geo_data ,
                                join = st_contains)

geo_data%>%filter(is.na(ServiceApprovalNumber))

geo_data_f<-geo_data%>%filter(!is.na(ServiceApprovalNumber))

#__________________
#sa1_demand

sa1_demand<-read_excel("/Users/e5028514/Desktop/ChildDesserts/data/SA1 0 to 5 year olds.xlsx", sheet=1)%>%
  mutate(
    sa1_2021_code=as.character(sa1_2021_code)
  )


geo_data_f<-left_join(geo_data_f, sa1_demand, by=c("sa1_code_2021"="sa1_2021_code"))

geo_data_f%>%st_write("data/geoCoded_googleway_sa1.geojson")

geo_data_flat<-st_drop_geometry(geo_data_f)

geo_data_flat%>%write_csv("data/geoCoded_googleway_sa1.csv")

#------------------
library(rmapshaper)

test_full_set<-geo_data_f%>%
  select(
    ServiceApprovalNumber,
    gcc_code_2021,
    State,
    cent_lat,
    cent_long,
    Age0to5,geometry
  )%>%
  mutate(
    id = row_number()
  )

test_full_set%>%write_csv("data/test_full_set.csv")

test_1RNSW<-test%>%filter(gcc_code_2021=="1RNSW")
test = ms_simplify(test_1RNSW, keep = 0.05)

st_write(test,"data/test_1RNSW.geojson")



coords = paste(paste(test$cent_long,test$cent_lat,sep=","), collapse = ";")
ids = test$id

# Get a matrix
router = "http://0.0.0.0:5000"
query = paste0(router,"/table/v1/driving/",coords,"?annotations=duration")
response = RCurl::getURL(query)

#!
# Data Handling


output = rjson::fromJSON(response)
duration = data.frame(output[["durations"]])
colnames(duration) = ids
output_write = cbind(id = ids, duration)

# Export data
write.csv(output_write,"data/TimeDistCarIsere_duration_1RNSW.csv", row.names = FALSE )


#------

locations<-c("1RNSW", "1GSYD", "2RVIC", "2GMEL")

for (i in locations) {
  test<-test_full_set%>%filter(gcc_code_2021==i)
  test = ms_simplify(test, keep = 0.05)

  st_write(test,paste("data/test_", i, ".geojson", sep=""))



  coords = paste(paste(test$cent_long,test$cent_lat,sep=","), collapse = ";")
  ids = test$id

  # Get a matrix
  router = "http://0.0.0.0:5000"
  query = paste0(router,"/table/v1/driving/",coords,"?annotations=duration")
  response = RCurl::getURL(query)

  #!
  # Data Handling


  output = rjson::fromJSON(response)
  duration = data.frame(output[["durations"]])
  colnames(duration) = ids
  output_write = cbind(id = ids, duration)

  # Export data
  write.csv(output_write,paste("data/TimeDistCarIsere_duration_", i, ".csv", sep=""), row.names = FALSE )


}

#---

isere = test[,c("id","name","lon", "lat")] %>% st_drop_geometry()

#driving time

library(tidyverse)
library(osmdata)
library(sf)
library(spatstat)
library(maptools)
library(raster)
library(RColorBrewer)
library(leaflet)
library(sp)
library(gstat)
library(osrm)
library(ggmap)
library(ggtext)
library(cartography)
library(showtext)

select <- dplyr::select


loc <- "Victoria, Australia" # This is the city I want to create a map for.
bounding_box <- getbb(loc) # this function looks for the square bounding box for this city.

vic_boundaries_metro <-bounding_box %>%
  opq() %>%
  add_osm_feature(key = 'name', value= "Metropolitan") %>%
  osmdata_sp()

vic_boundaries_metro <- vic_boundaries_metro[["osm_multipolygons"]]@data


# The input of the osrm function only allow for these 3 columns
geo_data_flat_school <- as_tibble(geo_data_flat) %>%
  mutate(id = 1:n()) %>%
  select(id, cent_long,   cent_lat)

# create the grid, using expand.grid()
grid <- expand.grid(seq(bounding_box[1,1], bounding_box[1,2], by = 0.001),
                    seq(bounding_box[2,1], bounding_box[2,2], by = .001)) %>%
  as_tibble() %>%
  mutate(id = 1:n()) %>%
  relocate(id) %>%
  setNames(c("id", "lon","lat"))

# make the boundaries of Accra plottable in ggplot2,
vic_boundaries_metro_poly <- fortify(vic_boundaries_metro)

# plot the grid, with as background the shapefile of Accra
ggplot() +
  geom_polygon(data = vic_boundaries_metro_poly,
               aes(x=long, y=lat, group = group),
               fill = NA, col = "black") +
  geom_point(data = grid,
             aes(x = lon, y = lat),
             col = "red", size = .001)
#-----
wget http://download.geofabrik.de/australia-oceania/australia-latest.osm.pbf
