library(osrm)

options(osrm.server = "http://localhost:5000/", osrm.profile = "car")


#centroid_sa1%>%write_csv("data/centroid_sa1.csv")

#all sa1 centroids
#centroid_sa1<-read_csv("data/centroid_sa1.csv")


#all childcare centres
geo_data_flat<-read_csv("data/geoCoded_googleway_sa1_centroid.csv")
sa1_demand<-read_csv("data/sa1_demand.csv")
#all possible sa1 and their centroids for driving time matrix


#loop
locations<-"2GMEL"

locations<-c("1GSYD", "2GMEL")

"1RNSW", "2RVIC",

for (i in locations) {
 # test_table<-geo_data_flat%>%filter(gcc_code_2021 %in% c("1RNSW", "2RVIC"))
 # source<-centroid_sa1%>%filter(gcc_code_2021 %in% c("1RNSW", "2RVIC"))


  test_table<-geo_data_flat%>%filter(gcc_code_2021== locations)

  source<-centroid_sa1%>%filter(gcc_code_2021== locations)


  dest<-as.data.frame(test_table[, c("cent_long", "cent_lat")])


  str(dest)

  # source<-test_table[, c("sa1_code_2021", "X", "Y")]%>%distinct()

 # source%>%count(sa1_code_2021, sort=TRUE)

 # test_table<-test_table%>%select(ServiceApprovalNumber, cent_lat, cent_long, X, Y)

distA2 <- osrmTable(src=source[, c("X", "Y")],
                    dst=dest[, c("cent_long", "cent_lat")])

#distA2 <- osrmTable(dst=source[, c("X", "Y")],
#                    src=dest[,c("cent_long", "cent_lat")])

sa1_demand_location<-sa1_demand%>%filter(gcc_code_2021==locations)
#sa1_demand_location<-sa1_demand%>%filter(gcc_code_2021 %in% c("1RNSW", "2RVIC"))



population<-sa1_demand_location%>%select(Age0to5)

supply<-as_vector(test_table$RevisedPlaces)


#sum(test_table$RevisedPlaces)

library(SpatialAcc)

## Metro areas
## the d0 is the parameter for driving time. For metro areas the parameter is 10 minutes or less and for regional areas the parameter is 20 minutes or less. The decay function is specified in ‘power’ and is different for metro and regional areas to reflect the different driving times.


Metro <- ac(p = population,
            n = test_table$RevisedPlaces,
            D = distA2[["durations"]], d0 = 10, family = "KD2SFCA", power =  .2084095)


sa1_demand_location$ac<-Metro

#test_table$total_revised_places<-distance_matrix$total_revised_places

sa1_demand_location%>%write_csv("data/2GMEL_new.csv")

## Regional areas

Regional <- ac(p = population,
               n = test_table$RevisedPlaces,
               D = distA2[["durations"]], d0 = 20, family = "KD2SFCA", power= .188818)

sa1_demand_location$ac<-Regional

sa1_demand_location%>%write_csv("data/1RNSW_2RVIC.csv")


#_______

RevisedPlaces_sa1<-geo_data_flat%>%group_by(sa1_code_2021)%>%
  summarize(
    RevisedPlaces_sa1=sum(RevisedPlaces)
  )%>%ungroup()


file.list <- list.files("/Users/e5028514/Library/CloudStorage/OneDrive-VictoriaUniversity/files/final", full.names = TRUE)
df.list <- lapply(file.list, read_csv)

data <- bind_rows(df.list)

data<-left_join(data, RevisedPlaces_sa1, by=c("sa1_2021_code"= "sa1_code_2021"))

data<-data%>%mutate(
  sa1_2021_code=as.character(sa1_2021_code)
)

map_sa1 <- sa12021
map_sa1<-st_drop_geometry(map_sa1)
map_sa1<-map_sa1%>%select()

data_full<-left_join(data, map_sa1, by=c("sa1_2021_code"= "sa1_code_2021"))



data_full%>%write_csv("data/data_full_flat_sa.csv")
