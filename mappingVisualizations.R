### read in files that resulted from initial dataprocessing in Julia 
### setwd() to directory where the files are

reallyBigMolluscs = read.table(file = "subsetGBIF_molluscsDataSorted.csv", sep = ",", header = T)

### in this case, this should be a ~7.35 million row by 10 column data.frame with about 8.7k unique genera
dim(reallyBigMolluscs)
length(unique(reallyBigMolluscs$genus))

### because the latitude and longitude data are in decimal format (negative values are south of the equator, or west of the Prime Meridian)
### we can just plot the data in base R as a scatterplot to see the distribution of the points: 

plot(reallyBigMolluscs$lat ~ reallyBigMolluscs$long, xlim = c(-185, 185), ylim = c(-95, 95), col = rgb(0.3, 0, 0.7, 0.1), pch = 20)

### even using some transparancy (4th value in the rgb(), alpha) and small point sizes, though, there are a lot of points on top of each other
### using the ggplot2 library, we can create a hex heatmap to better visualize the density of sampling
### use log() because the occurrence density varies from 0 - ~1000, so better for visualizations

library(ggplot2)
library(viridis)

hexMol <- ggplot(reallyBigMolluscs, aes(x = long, y = lat)) +
	theme_minimal() +
	geom_hex(aes(fill = stat(log(count))), binwidth = c(1, 1))+ 
	scale_fill_viridis() +
	labs(title = "Mollusc occurrence data from GBIF")

plot(hexMol)

### to use a similar approach to represent genus- (or other taxonomic grouping) richness, need to use the numeric genus key ("genusKey") GBIF provides: 

dev.new()
ggplot(reallyBigMolluscs, aes(x = long, y = lat, z = genusKey))+
	stat_summary_hex(
		fun = function(z){log10(length(unique(z)))}, 
		binwidth = c(0.25, 0.25))+
		scale_fill_distiller(palette="YlGnBu")+
	theme_minimal() +
	labs(title = "Total Mollusc data from GBIF, genus richness per 0.25 x 0.25 degree")


### if we want to view richness of families or orders, we need to create our own keys from scratch: 

library(dplyr)
library(tibble)

### create random numbers that have a 1-1 correspondence with the unique taxa in the reallyBigMolluscs data.frame
familyLookupTable = data.frame(family = unique(reallyBigMolluscs$family), familyNumber = sample(20000:30000, replace = FALSE, length(unique(reallyBigMolluscs$family))))
orderLookupTable = data.frame(order = unique(reallyBigMolluscs$order), orderNumber = sample(40000:50000, replace = FALSE, length(unique(reallyBigMolluscs$order))))

### using those data.frames, create new columns so there are equivalents to the GBIF "genusKey" for higher taxa
bigMolluscsFamCode = reallyBigMolluscs %>% inner_join(familyLookupTable)
bigMolluscsCodes = bigMolluscsFamCode %>% inner_join(orderLookupTable)

dev.new()
ggplot(bigMolluscsCodes, aes(x = long, y = lat, z = familyNumber))+
	stat_summary_hex(
		fun = function(z){log10(length(unique(z)))}, 
		binwidth = c(1, 1))+
		scale_fill_distiller(palette="YlGnBu")+
	theme_minimal() +
	labs(title = "Total Mollusc data from GBIF, point family richness in 1 x 1 degree hexes")


dev.new()
ggplot(bigMolluscsCodes, aes(x = long, y = lat, z = orderNumber))+
	stat_summary_hex(
		fun = function(z){log10(length(unique(z)))}, 
		binwidth = c(0.2, 0.2))+
		scale_fill_distiller(palette="YlGnBu")+
	theme_minimal() +
	labs(title = "Total Mollusc data from GBIF, point order richness" in 0.2 x 0.2 degree hexes")

