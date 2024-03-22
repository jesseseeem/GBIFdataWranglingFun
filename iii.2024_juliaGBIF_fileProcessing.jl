### for different taxa, find-replace "magnoliopsid" to taxon of your choice

### first, get rid of the single and double quotes from the occurrence.txt file
### using the shell/zsh scripting
### sed 's/\"//g' occurrence.txt > magnoliopsid_world_occurrence_1.txt
### sed "s/\'//g" magnoliopsid_world_occurrence_1.txt > magnoliopsid_world_occurrence_noQuotes.txt

using DataFrames, CSV, Tables, Random
### change file names to match which taxa you're actually filtering... 

### assuming tab-delimited file, which is how GBIF downloads things by default
GBIF_magnoliopsid = CSV.read("magnoliopsid_world_occurrence_noQuotes.txt", DataFrame; delim = "\t", header = true);

rnum = size(GBIF_magnoliopsid)[1]

### reduce number of columns to just the data we're interested in, 


subset_GBIF_magnoliopsid = DataFrame(lat = GBIF_magnoliopsid.decimalLatitude,
	long = GBIF_magnoliopsid.decimalLongitude,
	umbrellaTaxon = repeat(["magnoliopsid"], rnum),
	order = GBIF_magnoliopsid.order,
	family = GBIF_magnoliopsid.family,
	genus = GBIF_magnoliopsid.genus,
	genusKey = GBIF_magnoliopsid.genusKey,
	species = GBIF_magnoliopsid.specificEpithet,
	acceptedTaxonKey = GBIF_magnoliopsid.acceptedTaxonKey,
	gbifID = GBIF_magnoliopsid.gbifID,
	iucnCat = GBIF_magnoliopsid.iucnRedListCategory,
	taxonRank = GBIF_magnoliopsid.taxonRank,
	occurrenceStatus = GBIF_magnoliopsid.occurrenceStatus,
	yearCollected = GBIF_magnoliopsid.year); 

### get rid of missing values
subsubset_magnoliopsid = dropmissing(subset_GBIF_magnoliopsid, [:lat, :long, :genusKey, :genus, :acceptedTaxonKey, :taxonRank]);
### filter for only taxa identified to species
subsubSUBset_magnoliopsid = subset(subsubset_magnoliopsid, :taxonRank => ByRow(taxonRank -> taxonRank == "SPECIES"));
### write it out! 
CSV.write("subset_GBIF_magnoliopsid.csv", DataFrame(subsubSUBset_magnoliopsid), bufsize = 4194304000);


### sometimes when the initial DataFrame is made, columns get misclassified (e.g., "String" instead of "Float64", etc
### presumably because some messy data ending up in the wrong columns

### so at this point it can be helpful to just read in the DataFrame we just wrote out
### that way, usually the lat/long columns will be correctly Float64 for the calculations below
subsubSUBset_magnoliopsid = CSV.read("subset_GBIF_magnoliopsid.csv", DataFrame; delim = ",", header = true);

### make dataframe with the lat min, lat max, and count for each species (accepted taxon key)
GBIF_magnoliopsid_summary = combine(groupby(subsubSUBset_magnoliopsid, :acceptedTaxonKey), :lat => maximum, :lat => minimum, nrow);

### add other columns

insertcols!(GBIF_magnoliopsid_summary, 5,  :taxon => repeat(["magnoliopsid"], size(GBIF_magnoliopsid_summary)[1]));

insertcols!(GBIF_magnoliopsid_summary, 6,  :lat_range => GBIF_magnoliopsid_summary.lat_maximum - GBIF_magnoliopsid_summary.lat_minimum);

insertcols!(GBIF_magnoliopsid_summary, 7,  :lat_mid => (GBIF_magnoliopsid_summary.lat_maximum + GBIF_magnoliopsid_summary.lat_minimum)/2);

### write out summary stats file
CSV.write("GBIF_magnoliopsid_summary.csv", DataFrame(GBIF_magnoliopsid_summary), bufsize = 4194304000);


### have been going into R for subsequent subsetting, but probably fastest just to do in Julia
### check out https://discourse.julialang.org/t/upsampling-and-downsampling-in-julia-for-unbalanced-classes/16856
### also https://juliadata.org/DataTables.jl/stable/man/getting_started.html 
### might see if DataFrames vs. DataTables can do different dplyr/tidyr type things... 
### also check out: https://github.com/queryverse/Query.jl 
### this one might be the right package for downsampling/undersampling: https://juliaml.github.io/MLUtils.jl/stable/api/#MLUtils.undersample 




