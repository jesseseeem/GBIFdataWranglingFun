### if necessary, can use bash to convert occurrence datafile into csv 
### cat australia_echinoderms_occurrence.txt | tr "\\t" "," > australia_echinoderms_occurrence.csv


using DataFrames, CSV, Tables, Random
### change file names to match which taxa you're actually filtering... 

GBIF_coleo_NA = CSV.read("coleoptera_northAmerica_occurrence.txt", DataFrame; header = true);

rnum = size(GBIF_coleo_NA)[1]

### reduce number of columns to just the data we're interested in, 
### and add two columns of random numbers we can use to sort the data into different subsets

subset_GBIF_coleo_NA = DataFrame(lat = GBIF_coleo_NA.decimalLatitude, 
               long = GBIF_coleo_NA.decimalLongitude,
               order = GBIF_coleo_NA.order, 
               family = GBIF_coleo_NA.family, 
               genus = GBIF_coleo_NA.genus, 
               genusKey = GBIF_coleo_NA.genusKey,
		species = GBIF_coleo_NA.specificEpithet,
		acceptedTaxonKey = GBIF_coleo_NA.acceptedTaxonKey,
               gbifID = GBIF_coleo_NA.gbifID, 
               iucnCat = GBIF_coleo_NA.iucnRedListCategory, 
               taxonRank = GBIF_coleo_NA.taxonRank, 
               occurrenceStatus = GBIF_coleo_NA.occurrenceStatus, 
               randomsorter = (randn(rnum) .+ rand(-90:90,rnum)),
               randomsorter2 = (randn(rnum) .+ rand(-180:180,rnum)),
		randomsorter3 = (randn(rnum) .+ rand(1000:9999,rnum))); 

### get rid of missing values
subsubset = dropmissing(subset_GBIF_coleo_NA, [:lat, :long, :genusKey, :genus, :acceptedTaxonKey, :taxonRank]);
### filter for only taxa identified to species
subsubSUBset = subset(subsubset, :taxonRank => ByRow(taxonRank -> taxonRank == "SPECIES"));
### write it out! 
CSV.write("subset_GBIF_coleo_NA.csv", DataFrame(subsubSUBset), bufsize = 4194304000);

### make dataframe with the lat min, lat max, and count for each species (accepted taxon key)
GBIF_coleo_aus_summary = combine(groupby(subsubSUBset, :acceptedTaxonKey), :lat => maximum, :lat => minimum, nrow);

### add other columns
insertcols!(GBIF_coleo_aus_summary, 5,  :continent => repeat(["australia"], size(GBIF_coleo_aus_summary)[1]));

insertcols!(GBIF_coleo_aus_summary, 6,  :taxon => repeat(["coleoptera"], size(GBIF_coleo_aus_summary)[1]));

insertcols!(GBIF_coleo_aus_summary, 7,  :lat_range => GBIF_coleo_aus_summary.lat_maximum - GBIF_coleo_aus_summary.lat_minimum);

insertcols!(GBIF_coleo_aus_summary, 8,  :lat_mid => (GBIF_coleo_aus_summary.lat_maximum + GBIF_coleo_aus_summary.lat_minimum)/2);

### write out summary stats file
CSV.write("GBIF_coleo_aus_summaryStats.csv", DataFrame(GBIF_coleo_aus_summary), bufsize = 4194304000);
