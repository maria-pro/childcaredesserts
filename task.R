To redo the childcare deserts work, we need the following:

  1.	The number of childcare places available (supply)
2.	The number of children by SA1 area (demand)
3.	The geolocation of childcare places
4.	The location of children
5.	A matrix that shows the driving time between the demand of places (number of children by SA1) and location of places (supply)
6.	A program that calculates the relative supply and demand using a process known as a ‘floating catchment area’

Some things to note:
  -	We only need results Victoria at this stage, but to do that we need to calculate NSW as well.
-	There are a couple of options for the r package that we can use and I can explain more later
-	The big work is finding the longitude and latitude details for the childcare sites and then setting up a server to calculate driving times. OpenStreetMap is fine to use to calculate driving time, but you need to set up a server on your computer because there are way too many calculations that need to be made to send up via the interwebbles.

So in more detail:

  1.	The number of childcare places available (supply)

I have this data from ACECQA. I have adjusted it and can send it through. The supply is the variable called “RevisedPlaces”

2.	The number of children by SA1 area (demand)

I have this data from the census and have adjusted it to exclude children attending primary school and attached to the email.

3.	The geolocation of childcare places
I have the addresses for the childcare places. These need to be turned into longitude and latitude coordinates.

OpenStreetMap would be fine, but with about 7,000 locations using web-based requests will be slow and usually doesn’t work. Also, OpenStreetMap is really not intuitive. I find that if the address is not completely correct it won’t work properly. For instance, anything with “corner of” in the address title will return an error. Still, it works about 90% of the time. The package “tidygeocoder” seems to work well. If you can set up an Open Street Map server (see here and here) you might be able to do most of this.

Google, again is much, much better. I think the packages “ggmap” or “googleway” work well. You can also use the title of the childcare centre in a google request and you are more likely to get an accurate result. I think you can get about 30,000 free geocode request each month on google.


4.	The location of children

This one is pretty easy. Use the centroid of the sa1 area. I use the “absmapsdata” package. You need to get the object sa12021. I can’t remember if this object has the centroid in long / lat format, but if it doesn’t you can use sf::st_centroid().

5.	A matrix that shows the driving time between the demand of places (number of children by SA1) and location of places (supply)

This is where it starts to get messy. You need to build a server to calculate driving time between demand and supply. I basically just followed this how-to guide last time here. I tried to follow this for the mac version but it didn’t work for me. If you can get a server up and running, I think I used the “osrm” package last time and the command osrmTable(). The other complication is you need to separate metro and regional areas. Metro areas have different drive time parameters later on for reasons I can explain later. I would suggest creating 3 driving time matrices in this instance. One that includes Melbourne SA1’s, one that includes Sydney SA1s and one that includes all regional SA1s for NSW and VIC areas (we are not looking at the other states at this stage, but we will later).

6.	A program that calculates the relative supply and demand using a process known as a ‘floating catchment area’

The final step!!! The process known as a ‘floating catchment area’ and there are several programs that can be used, most of which use python. I used the package SpatialAcc last time I did this work, and the command ac(). I remember it being very difficult. NAs caused problems from memory. I see there is another package called fca which I think might be interesting to use. There are a couple of parameters that need to be decided upon, such as the decay function and also the drive time parameters. There needs to be different parameters for regional and metro areas (which is why it is separated out at an earlier point) because Open StreetMap doesn’t really take into account traffic, so a 30 minute parameter in a metro area is unrealistic because it will end up including almost the whole of Melbourne.

Anyway, perhaps if you get to this point, we can discuss in a bit more detail what the approach might be.


