### notes on post-processing GBIF range data in R; visualizing the data, etc. 

### read in output from Julia

scleractiniaWorld = read.table(file = "GBIF_coral_world_summaryStats.csv", header = T, sep = ",")
echinoWorld = read.table(file = "subset_GBIF_echino_world.csv", header = T, sep = ",")
diplopodaWorld = read.table(file = "GBIF_diplopoda_world_summaryStats.csv", header = T, sep = ",")
stylommatophoraWorld = read.table(file = "GBIF_stylo_world_summaryStats.csv", header = T, sep = ",")
scleractiniaWorld = read.table(file = "GBIF_insects_world_summaryStats.csv", header = T, sep = ",")
insectWorld = read.table(file = "GBIF_arach_world_summaryStats.csv", header = T, sep = ",")

###put 'em all together
invertWorld = rbind(insectWorld, arachnoworld, stylommatophoraWorld, diplopodaWorld, echinoWorld, scleractiniaWorld)

### make subsets by occurrence (nrow) range: 
invertWorld10plus = subset(invertWorld, nrow > 9)
invertWorld10to50 = subset(invertWorld10plus, nrow < 51)

invertWorld5to9 = subset(invertWorld, nrow > 4)
invertWorld5to9 = subset(invertWorld5to9, nrow < 10)

invertWorld2only = subset(invertWorld, nrow == 2)

invertWorld50to500 = subset(invertWorld, nrow > 49)
invertWorld50to500 = subset(invertWorld50to500, nrow < 501)

library(ggplot2)
library(lattice)
library(groupdata2)

### downsample so taxa are evenly represented in the different occurrence subsets
invertWorld10plusBalanced = downsample(invertWorld10plus, cat_col = "taxon")
invertWorldAllbalanced = downsample(invertWorld, cat_col = "taxon")
invertWorld10to50balanced = downsample(invertWorld10to50, cat_col = "taxon")

### explore the data: 
bwplot(log2(invertWorld10plus$lat_range) ~ invertWorld10plus$taxon)

### generate loess curves of latitudinal range as a function of latitudinal midpoint: 
ggplot(invertWorld10plusBalanced, aes(x= lat_mid, y= log2(lat_range+1), color=taxon, shape=taxon)) +
	geom_point() + 
	geom_smooth(method= loess, aes(fill= taxon))

