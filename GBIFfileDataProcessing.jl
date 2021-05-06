### in Julia, navigate to the directory with the "occurrences.txt" tab-delimited data file downloaded from GBIF
### in this example, files are named as if we're using the mollusc dataset
### e.g., https://www.gbif.org/occurrence/download/0253699-200613084148143 
### the initial text file is pretty big (10GB), 
### here we just reduce the number of columns, so we still have >7million occurrences, but with fewer columns so the text file is < 1GB
### and also generate smaller subsets so we can work with a random subsample of 10k occurrences (closer to a 1Mb file)

using DataFrames, CSV, Impute, Random

GBIF_mollusc = CSV.read("occurrence.txt", DataFrame; header = true);

rnum = size(GBIF_mollusc)[1]

### reduce number of columns to just the data we're interested in, 
### and add two columns of random numbers we can use to sort the data into different subsets

subset_molluscGBIF = DataFrame(lat = GBIF_mollusc.decimalLatitude, 
               long = GBIF_mollusc.decimalLongitude,
               order = GBIF_mollusc.order, 
               family = GBIF_mollusc.family, 
               genus = GBIF_mollusc.genus, 
               genusKey = GBIF_mollusc.genusKey,
		species = GBIF_mollusc.specificEpithet,
		acceptedTaxonKey = GBIF_mollusc.acceptedTaxonKey,
               gbifID = GBIF_mollusc.gbifID, 
               iucnCat = GBIF_mollusc.iucnRedListCategory, 
               randomsorter = (randn(rnum) .+ rand(-90:90,rnum)),
               randomsorter2 = (randn(rnum) .+ rand(-180:180,rnum)),
		randomsorter3 = (randn(rnum) .+ rand(1000:9999,rnum))); 

### the first two random sorters have similar ranges to lat/long data
### this seemed nice for making a separate, spatially shuffled subset later on
### 3rd random sorter is just for subsetting the data 

### remove missing values from rows we care about
subset_molluscGBIF_goodData = dropmissing(subset_molluscGBIF, [:lat, :long, :genusKey, :genus, :acceptedTaxonKey]);

### write out entire subsetted dataset 
CSV.write("subsetGBIF_molluscDataSorted.csv", DataFrame(sort!(subset_molluscGBIF_generaIDs_goodLatLong, :randomsorter)), bufsize = 4194304000);

### only write out a subset of 10k occurrences (rows)
CSV.write("subSubsetGBIF_molluscDataSorted.csv", DataFrame((subset_molluscGBIF_generaIDs_goodLatLong[1:10000, :])), bufsize = 4194304000);

### only keep occurrences of taxa that have been ranked by the IUCN
subset_molluscGBIF_generaIDs_goodLatLong_IUCN = dropmissing(subset_molluscGBIF_generaIDs_goodLatLong, :iucnCat); 

### use the other random sorter column so this subset won't necessarily contain many species from the previous 10k subset
sort!(subset_molluscGBIF_generaIDs_goodLatLong_IUCN, :randomsorter2); 

### write out just the IUCN data
CSV.write("subSubsetGBIF_molluscDataSorted_IUCN.csv", DataFrame((subset_molluscGBIF_generaIDs_goodLatLong_IUCN[1:10000, :])), bufsize = 4194304000);

### potentially try to write a loop for spatial subsetting in Julia instead of R: 

### spatial subsetting in Julia

genusKeyList = unique(subset_protistGBIF_goodData.genusKey); 
### this is super-important; speeds thinks up literally ~500x on the protist dataset
spatialGenusSample = ["latSample"; "longSample"; genusKeyList];


for h = -9:8
	for i = -4:4
		latLongSubX = [20*h 20*i]
		subX = filter(row -> row.long >= (h *20)  && row.long <= (h * 20 + 19) && row.lat >= (i * 20) && row.lat <= (i * 20 + 19), subset_protistGBIF_goodData)
			for j = 1:length(genusKeyList)
				latLongSubX = [latLongSubX sum(subX.genusKey .== genusKeyList[j])]
			end
		spatialGenusSample = hcat(spatialGenusSample, latLongSubX')
	end
end

CSV.write("spatialGenusSample.CSV", Tables.table(spatialGenusSample), header = false);

### write-out random(non-spatial) sample: 

genusKeyList = unique(molluscsGBIF.genusKey); 

randomGenusSample = ["rand1Sample"; "rand2Sample"; genusKeyList];


for h = -9:8
	for i = -4:4
		randomSubX = [20*h 20*i]
		subX = filter(row -> row.randomsorter2 >= (h *20)  && row.randomsorter2 <= (h * 20 + 19) && row.randomsorter >= (i * 20) && row.randomsorter <= (i * 20 + 19), molluscsGBIF)
			for j = 1:length(genusKeyList)
				randomSubX = [randomSubX sum(subX.genusKey .== genusKeyList[j])]
			end
		randomGenusSample = hcat(randomGenusSample, randomSubX')
	end
end

CSV.write("randomGenusSample.CSV", Tables.table(randomGenusSample), header = false);


