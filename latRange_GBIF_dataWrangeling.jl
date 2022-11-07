### if necessary, can use bash to convert occurrence datafile into csv 
### first remove all commas from the .txt file (there are often commas)
### sed 's/,//g'  basidios_world_occurrence.txt > basidios_world_occurrenceNoCommas.txt
### then replace tab-delimiters with commas to make it a CSV file
### cat basidios_world_occurrenceNoCommas.txt | tr "\\t" "," > basidios_world_occurrence.csv


using DataFrames, CSV, Tables, Random
### change file names to match which taxa you're actually filtering... 

### assuming tab-delimited file, which is how GBIF downloads things by default
GBIF_basidio_NA = CSV.read("basidios_world_occurrence.txt", DataFrame; delim = "\t", header = true);

rnum = size(GBIF_basidio_NA)[1]

### reduce number of columns to just the data we're interested in, 
### and add two columns of random numbers we can use to sort the data into different subsets

subset_GBIF_basidio_NA = DataFrame(lat = GBIF_basidio.decimalLatitude, 
               long = GBIF_basidio.decimalLongitude,
               umbrellaTaxon = repeat(["basidio"], rnum),
               order = GBIF_basidio_NA.order, 
               family = GBIF_basidio_NA.family, 
               genus = GBIF_basidio_NA.genus, 
               genusKey = GBIF_basidio_NA.genusKey,
		species = GBIF_basidio_NA.specificEpithet,
		acceptedTaxonKey = GBIF_basidio_NA.acceptedTaxonKey,
               gbifID = GBIF_basidio_NA.gbifID, 
               iucnCat = GBIF_basidio_NA.iucnRedListCategory, 
               taxonRank = GBIF_basidio_NA.taxonRank, 
               occurrenceStatus = GBIF_basidio_NA.occurrenceStatus, 
               randomsorter = (randn(rnum) .+ rand(-90:90,rnum)),
               randomsorter2 = (randn(rnum) .+ rand(-180:180,rnum)),
		randomsorter3 = (randn(rnum) .+ rand(1000:9999,rnum))); 

### get rid of missing values
subsubset = dropmissing(subset_GBIF_basidio_NA, [:lat, :long, :genusKey, :genus, :acceptedTaxonKey, :taxonRank]);
### filter for only taxa identified to species
subsubSUBset = subset(subsubset, :taxonRank => ByRow(taxonRank -> taxonRank == "SPECIES"));
### write it out! 
CSV.write("subset_GBIF_basidio.csv", DataFrame(subsubSUBset), bufsize = 4194304000);

### make dataframe with the lat min, lat max, and count for each species (accepted taxon key)
GBIF_basidio_summary = combine(groupby(subsubSUBset, :acceptedTaxonKey), :lat => maximum, :lat => minimum, nrow);

### add other columns

insertcols!(GBIF_basidio_summary, 5,  :taxon => repeat(["basidio"], size(GBIF_basidio_summary)[1]));

insertcols!(GBIF_basidio_summary, 6,  :lat_range => GBIF_basidio_summary.lat_maximum - GBIF_basidio_summary.lat_minimum);

insertcols!(GBIF_basidio_summary, 7,  :lat_mid => (GBIF_basidio_summary.lat_maximum + GBIF_basidio_aus_summary.lat_minimum)/2);

### write out summary stats file
CSV.write("GBIF_basidio_summary.csv", DataFrame(GBIF_basidio_summary), bufsize = 4194304000);
