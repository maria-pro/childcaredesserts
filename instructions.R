docker pull osrm/osrm-backend
cd /Users/e5028514/Desktop/ChildDesserts/data
wget http://download.geofabrik.de/australia-oceania/australia-latest.osm.pbf

docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-extract -p /opt/car.lua /data/australia-latest.osm.pbf

#docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-extract -p /opt/car.lua /australia-latest.osm.pbf

docker run -t -v %cd%:/data osrm/osrm-backend osrm-partition /data/australia-latest.osm.pbf

#docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-partition australia-latest.osm.pbf

docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-partition /data/australia-latest.osm.pbf


docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-customize /data/australia-latest.osm.pbf

docker run -t -i -p 5000:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld --max-table-size 10000  /data/australia-latest.osm.pbf


options(osrm.server = "http://localhost:5000/", osrm.profile = "car")
