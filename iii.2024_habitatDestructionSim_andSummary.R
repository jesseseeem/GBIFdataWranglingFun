library(dggridR)


cellSize = c(4:6)
habitatLeft = 1/c(2:5)
### needs to be 1/integer...this is the proportion of habitat retained, not habitat lost (starts at 1/2 because 1/1 would be all habitat retained)

umbrellaList = unique(occ_20plus$umbrellaTaxon)
umbrellaLength = length(unique(occ_20plus$umbrellaTaxon))
familyList = unique(occ_20plus$family)
familyLength = length(familyList)


HLES_colNames = c("uniqueThing", "cellSize", "habitatLeft", umbrellaList, familyList)

write.table(t(HLES_colNames), "15.iii.2024_HLES_practice.txt", quote = FALSE, row.names = FALSE, sep = "\t", append = TRUE, col.names = FALSE)


for (j in 1:3){
	for (k in 1:4){
		dggs = dgconstruct(res = cellSize[j])
		occ_20plus$cell <- dgGEO_to_SEQNUM(dggs, occ_20plus$long, occ_20plus$lat)$seqnum
		randomSorter = rep(1:(1/habitatLeft[k]), length(unique(occ_20plus$cell)))[1:length(unique(occ_20plus$cell))]
			for (i in 1:10){
				thisSeed = sample(100000:999999, 1)
				notThisSeed = sample(0:thisSeed, 1)
				set.seed = thisSeed
				occ_20plusScrambler = data.frame(cell = unique(occ_20plus$cell), randomSorter = sample(randomSorter, length(randomSorter), replace = FALSE))
				occ_20plusCellScramble = left_join(occ_20plus, occ_20plusScrambler, by = "cell")
				subsetOcc_20plus = subset(occ_20plusCellScramble, occ_20plusCellScramble$randomSorter==1)
				
				uniqueThing = paste(thisSeed, notThisSeed, sep = "_")

					HLES = c(uniqueThing, cellSize[j], habitatLeft[k])

					for (h in 1:umbrellaLength){
						taxonSubsetOcc_20plus = subset(subsetOcc_20plus, subsetOcc_20plus$umbrellaTaxon == umbrellaList[h])
						taxonOcc_20plus = subset(occ_20plus, occ_20plus$umbrellaTaxon == umbrellaList[h])
						percentExtant = 100 * length(unique(taxonSubsetOcc_20plus$acceptedTaxonKey))/length(unique(taxonOcc_20plus$acceptedTaxonKey))
						HLES = c(HLES, percentExtant)

					}

					for (f in 1:familyLength){
						taxonSubsetOcc_20plus = subset(subsetOcc_20plus, subsetOcc_20plus$family == familyList[f])
						taxonOcc_20plus = subset(occ_20plus, occ_20plus$family == familyList[f])
						percentExtant = 100 * length(unique(taxonSubsetOcc_20plus$acceptedTaxonKey))/length(unique(taxonOcc_20plus$acceptedTaxonKey))
						HLES = c(HLES, percentExtant)

					}

					
					write.table(t(HLES), "15.iii.2024_HLES_practice.txt", quote = FALSE, row.names = FALSE, sep = "\t", append = TRUE, col.names = FALSE)
						
					}

					

			}
		
	}




library(dplyr)

min_max <- list(
  min = ~min(.x, na.rm = TRUE), 
  max = ~max(.x, na.rm = TRUE)
)

by_species_occ_20plus  = occ_20plus %>% 
  group_by(acceptedTaxonKey) %>%  
  summarise(across((lat), min_max)) 
  

taxonomyTable = data.frame(umbrellaTaxon = occ_20plus$umbrellaTaxon, family = occ_20plus$family, genus = occ_20plus$genus, acceptedTaxonKey = occ_20plus$acceptedTaxonKey)


by_species_occ_20plus = by_species_occ_20plus %>% left_join(taxonomyTable, multiple = "first")


by_species_occ_20plus = by_species_occ_20plus%>% select(acceptedTaxonKey, umbrellaTaxon, family, genus, lat_max, lat_min) %>%
  mutate(
    lat_range = lat_max - lat_min
  )


by_family_occ_20plus  = by_species_occ_20plus %>% 
  group_by(family) %>%  
  summarise(across((lat_range), median)) 
  

by_umbrella_occ_20plus  = by_species_occ_20plus %>% 
  group_by(umbrellaTaxon) %>%  
  summarise(across((lat_range), median)) 
  


write.table(by_species_occ_20plus, "15.iii.2024_by_species_occ_20plus_latRange.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(by_family_occ_20plus, "15.iii.2024_by_family_occ_20plus_latRange.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(by_umbrella_occ_20plus, "15.iii.2024_by_umbrella_occ_20plus_latRange.txt", quote = FALSE, row.names = FALSE, sep = "\t")


### read back in data from spatial subsamples so we can get summary data

HLES_final = read.table(file = "16.iii.2024_HLES_practice.txt", header = T, sep = "\t")


library(tidyr)

HLES_final_longer = HLES_final %>% pivot_longer(cols = familyList[1]:familyList[familyLength], names_to = "family", values_to = "percentSppSurvive")



