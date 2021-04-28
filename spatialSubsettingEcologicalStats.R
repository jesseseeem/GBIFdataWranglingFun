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

write.table(molluscGBIFspatialSamples, file = "molluscGBIFspatialSamples.csv", sep = ",", col.names = c("long", "lat", unique(molluscs10k$genus)), , row.names = latLongNames , quote = FALSE)

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
