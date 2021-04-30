### starting off with some of the subset datasets generated from the Julia script, do further subsetting and reshaping of the diversity data

### starting this with the 10k mollusc occurrence subsample
### lower down, you'll need the libraries "vegan" and "stringr"

molluscs10k = read.table(file = "~/Desktop/2021_extinctionsCourse_IUCNdata/GBIF_occurenceData/GBIF_molluscsData.csv", header = T, sep = ",")

### we can generate an assemblage matrix of genus occurrences per (x) grid size
### example below generates 20 x 20 degree samples of the global dataset
### gives corner of long, lat as first two values for each row

molluscGBIFspatialSamples = rep(NA, length(unique(molluscs10k$genus))+2)

for (h in -9:8){
	for (i in -4:4){
		latLongSubX = c(20*h, 20*i)
		subX = molluscs10k[which(molluscs10k$long >= (h *20)  & molluscs10k$long <= (h * 20 + 19) & molluscs10k$lat >= (i * 20) & molluscs10k$lat <= (i * 20 + 19)), ]
		for (i in 1:length(unique(molluscs10k$genus))){
			latLongSubX = c(latLongSubX, sum(unique(molluscs10k$genus)[i] == subX$genus))
			}
		latLongSubX = na.omit(latLongSubX)
		molluscGBIFspatialSamples = rbind(molluscGBIFspatialSamples, latLongSubX)
	}
}


molluscGBIFspatialSamples = na.omit(molluscGBIFspatialSamples)

molluscGBIFspatialSubsampleDF = data.frame(molluscGBIFspatialSamples)

library(stringr)
latLongNames = str_glue_data(molluscGBIFspatialSubsampleDF, "lat{molluscGBIFspatialSubsampleDF[, 2]}_long{molluscGBIFspatialSubsampleDF[, 1]}")

write.table(molluscGBIFspatialSamples, file = "molluscGBIFspatialSamples.csv", sep = ",", col.names = c("long", "lat", unique(molluscs10k$genus)), row.names = latLongNames , quote = FALSE)

molluscCommunitySubsample = read.table(file = "molluscGBIFspatialSamples.csv", header = T, sep = ",")

library(vegan)

### need to omit lat/long for species count analyses [ , 3: dim(molluscGBIFspatialSamplesSppMatrix)[2]]

### report species richness of each grid sample (row in molluscGBIFspatialSamplesSppMatrix)
specnumber(molluscGBIFspatialSamplesSppMatrix[ , 3: dim(molluscGBIFspatialSamplesSppMatrix)[2]], MARGIN = 1)

specpool(molluscGBIFspatialSamplesSppMatrix[ , 3: dim(molluscGBIFspatialSamplesSppMatrix)[2]])
pool <- poolaccum(molluscGBIFspatialSamplesSppMatrix)
summary(pool, display = "chao")
dev.new()
plot(pool, main = "20d Lat x 20d Long Geographical subsamples of 10k GBIF Mollusc subsample")
estimateR(molluscGBIFspatialSamplesSppMatrix[1:9,])

### gotta add some iNEXT stuff at some point.. that would be cool
### in Julia, I should do the random sorters and random uniform variables, so there would be an alternative way of generating the community matrix... 


###can make additional taxon matrix subsets at various taxonomic levels and either spatial subsets, or random subsets

### make both spatial and non-spatial samples at both the genus and species levels

### species (acceptedTaxonKey), spatial, in 20 x 20 lat/long blocks

molluscGBIFspatialSamplesSpecies = rep(NA, length(unique(betterMolluscSubset$acceptedTaxonKey))+2)

for (h in -9:8){
	for (i in -4:4){
		latLongSubX = c(20*h, 20*i)
		subX = betterMolluscSubset[which(betterMolluscSubset$long >= (h *20)  & betterMolluscSubset$long <= (h * 20 + 19) & betterMolluscSubset$lat >= (i * 20) & betterMolluscSubset$lat <= (i * 20 + 19)), ]
		for (i in 1:length(unique(betterMolluscSubset$acceptedTaxonKey))){
			latLongSubX = c(latLongSubX, sum(unique(betterMolluscSubset$acceptedTaxonKey)[i] == subX$acceptedTaxonKey))
			}
		latLongSubX = na.omit(latLongSubX)
		molluscGBIFspatialSamplesSpecies = rbind(molluscGBIFspatialSamplesSpecies, latLongSubX)
	}
}


molluscGBIFspatialSamplesSpecies = na.omit(molluscGBIFspatialSamplesSpecies)

molluscGBIFspatialSubsampleSpeciesDF = data.frame(molluscGBIFspatialSamplesSpecies)


latLongNames = str_glue_data(molluscGBIFspatialSubsampleSpeciesDF, "lat{molluscGBIFspatialSubsampleSpeciesDF[, 2]}_long{molluscGBIFspatialSubsampleSpeciesDF[, 1]}")

write.table(molluscGBIFspatialSubsampleSpeciesDF, file = "molluscGBIFspatialSamplesSpecies.csv", sep = ",", col.names = c("long", "lat", unique(betterMolluscSubset$acceptedTaxonKey)),  row.names = latLongNames , quote = FALSE)



molluscCommunitySubsample = read.table(file = "molluscGBIFspatialSamples.csv", header = T, sep = ",")


### species (acceptedTaxonKey), non-spatial, in 20 x 20 randomsorter blocks
### using randomsorter (range ~ -90:90) and randomsorter2 (range ~ -180:180)

molluscGBIFrandomSamplesSpecies = rep(NA, length(unique(betterMolluscSubset$acceptedTaxonKey))+2)

for (h in -9:8){
	for (i in -5:4){
		latLongSubX = c(20*h, 20*i)
		subX = betterMolluscSubset[which(betterMolluscSubset$randomsorter2 >= (h *20)  & betterMolluscSubset$randomsorter2 <= (h * 20 + 19) & betterMolluscSubset$randomsorter >= (i * 20) & betterMolluscSubset$randomsorter <= (i * 20 + 19)), ]
		for (i in 1:length(unique(betterMolluscSubset$acceptedTaxonKey))){
			latLongSubX = c(latLongSubX, sum(unique(betterMolluscSubset$acceptedTaxonKey)[i] == subX$acceptedTaxonKey))
			}
		latLongSubX = na.omit(latLongSubX)
		molluscGBIFrandomSamplesSpecies = rbind(molluscGBIFrandomSamplesSpecies, latLongSubX)
	}
}


molluscGBIFrandomSamplesSpecies = na.omit(molluscGBIFrandomSamplesSpecies)

molluscGBIFrandomSubsampleSpeciesDF = data.frame(molluscGBIFrandomSamplesSpecies)


randSampleNames = str_glue_data(molluscGBIFrandomSubsampleSpeciesDF, "rand{molluscGBIFrandomSubsampleSpeciesDF[, 2]}_rand2{molluscGBIFrandomSubsampleSpeciesDF[, 1]}")

write.table(molluscGBIFrandomSubsampleSpeciesDF, file = "molluscGBIFrandomSubsampleSpeciesDF.csv", sep = ",", col.names = c("rand2", "rand", unique(betterMolluscSubset$acceptedTaxonKey)),  row.names = randSampleNames , quote = FALSE)



molluscRandomCommunitySubsample = read.table(file = "molluscGBIFrandomSubsampleSpeciesDF.csv", header = T, sep = ",")


### now for genera: 
### spatial subset at the genus level


molluscGBIFspatialSamplesGenera = rep(NA, length(unique(betterMolluscSubset$genus))+2)

for (h in -9:8){
	for (i in -4:4){
		latLongSubX = c(20*h, 20*i)
		subX = betterMolluscSubset[which(betterMolluscSubset$long >= (h *20)  & betterMolluscSubset$long <= (h * 20 + 19) & betterMolluscSubset$lat >= (i * 20) & betterMolluscSubset$lat <= (i * 20 + 19)), ]
		for (i in 1:length(unique(betterMolluscSubset$genus))){
			latLongSubX = c(latLongSubX, sum(unique(betterMolluscSubset$genus)[i] == subX$genus))
			}
		latLongSubX = na.omit(latLongSubX)
		molluscGBIFspatialSamplesGenera = rbind(molluscGBIFspatialSamplesGenera, latLongSubX)
	}
}


molluscGBIFspatialSamplesGenera = na.omit(molluscGBIFspatialSamplesGenera)

molluscGBIFspatialSamplesGeneraDF = data.frame(molluscGBIFspatialSamplesGenera)


latLongNames = str_glue_data(molluscGBIFspatialSamplesGeneraDF, "lat{molluscGBIFspatialSamplesGeneraDF[, 2]}_long{molluscGBIFspatialSamplesGeneraDF[, 1]}")

write.table(molluscGBIFspatialSamplesGeneraDF, file = "molluscGBIFspatialSamplesGenera.csv", sep = ",", col.names = c("long", "lat", unique(betterMolluscSubset$genus)),  row.names = latLongNames , quote = FALSE)



molluscGenusSpatialSubsample = read.table(file = "molluscGBIFspatialSamplesGenera.csv", header = T, sep = ",")


### genus-level non-spatial subsamples, in 20 x 20 randomsorter blocks
### using randomsorter (range ~ -90:90) and randomsorter2 (range ~ -180:180)

molluscGBIFrandomSamplesGenus = rep(NA, length(unique(betterMolluscSubset$genus))+2)

for (h in -9:8){
	for (i in -5:4){
		latLongSubX = c(20*h, 20*i)
		subX = betterMolluscSubset[which(betterMolluscSubset$randomsorter2 >= (h *20)  & betterMolluscSubset$randomsorter2 <= (h * 20 + 19) & betterMolluscSubset$randomsorter >= (i * 20) & betterMolluscSubset$randomsorter <= (i * 20 + 19)), ]
		for (i in 1:length(unique(betterMolluscSubset$genus))){
			latLongSubX = c(latLongSubX, sum(unique(betterMolluscSubset$genus)[i] == subX$genus))
			}
		latLongSubX = na.omit(latLongSubX)
		molluscGBIFrandomSamplesGenus = rbind(molluscGBIFrandomSamplesGenus, latLongSubX)
	}
}
acceptedTaxonKey

molluscGBIFrandomSamplesGenus = na.omit(molluscGBIFrandomSamplesGenus)

molluscGBIFrandomSubsampleGenusDF = data.frame(molluscGBIFrandomSamplesGenus)


randSampleNames = str_glue_data(molluscGBIFrandomSubsampleGenusDF, "rand{molluscGBIFrandomSubsampleGenusDF[, 2]}_rand2{molluscGBIFrandomSubsampleGenusDF[, 1]}")

write.table(molluscGBIFrandomSubsampleGenusDF, file = "molluscGBIFrandomSubsampleGenusDF.csv", sep = ",", col.names = c("rand2", "rand", unique(betterMolluscSubset$genus)),  row.names = randSampleNames , quote = FALSE)



molluscRandomCommunitySubsampleGenus = read.table(file = "molluscGBIFrandomSubsampleGenusDF.csv", header = T, sep = ",")


