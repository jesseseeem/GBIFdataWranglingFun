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


### further adventures in subsetting 
library(tibble)
library(dplyr)
library(groupdata2)


### read in the summary statistics (lat range, lat midpoint, etc for each taxon)
### each row is a taxon (unique "acceptedTaxonKey")
### nrow column is how many occurrences per taxon
echinoWorld = read.table(file = "GBIF_echino_world_summaryStats.csv", sep = ",", header = T)

### read in the occurrence data 
### each row is one observation
echinoWorldOcc = read.table(file = "subset_GBIF_echino_world.csv", sep = ",", header = T)

### subset of rare taxa (between 5 and 20 occurrences)
echinoWorld_5to20 = subset(echinoWorld, nrow > 4)
echinoWorld_5to20 = subset(echinoWorld_5to20, nrow < 21)

### subset of moderately rare taxa (20 to 100 occurrences)
echinoWorld_20to100 = subset(echinoWorld, nrow < 101)
echinoWorld_20to100 = subset(echinoWorld_20to100, nrow > 19) 

### I don't know if it's necessary to convert to tibble for the rest of the stuff to work
### might be able to skip
echinoWorldOcc_tib = as_tibble(echinoWorldOcc)

echinoWorld_5to20_tib = as_tibble(echinoWorld_5to20)

### pull out the occurrences from the taxa that only occur 5 to 20 times
echinoWorldOcc_5to20 = semi_join(echinoWorldOcc_tib, echinoWorld_5to20_tib, by = "acceptedTaxonKey")

echinoWorld_20to100_tib = as_tibble(echinoWorld_20to100)

### pull out the occurrences from the taxa that occur 20 to 100 times
echinoWorldOcc_20to100 = semi_join(echinoWorldOcc_tib, echinoWorld_20to100_tib, by = "acceptedTaxonKey")

### downsample the occurrence data so that each taxon occurs the least number of times (20 or 5, respectively)
### I think it might be important to standarize occurrence number per taxon, in case e.g., lepidoptera are biased 
### towards more 100 occurrences, stylommatophora are biased towards more 20 occurrences, etc

echinoWorldOcc_20to100_downsampled = downsample(echinoWorldOcc_20to100, cat_col="acceptedTaxonKey")
echinoWorldOcc_5to20_downsampled = downsample(echinoWorldOcc_5to20, cat_col="acceptedTaxonKey")

### write it out! 
write.csv(echinoWorldOcc_5to20_downsampled, "echinoWorldOcc_5to20_downsampled.csv", quote = FALSE, row.names = FALSE)
write.csv(echinoWorldOcc_5to20, "echinoWorldOcc_5to20.csv", quote = FALSE, row.names = FALSE)
write.csv(echinoWorldOcc_20to100_downsampled, "echinoWorldOcc_20to100_downsampled.csv", quote = FALSE, row.names = FALSE)
write.csv(echinoWorldOcc_20to100, "echinoWorldOcc_20to100.csv", quote = FALSE, row.names = FALSE)
