### this file is to make a list of taxa we can query, and then use that in rgbif 

### download taxonomy datasets for all specimen-based GBIF occurrence data for plants and animals with decimal lat/long

### in R, subset those datasets, so you only have species with at least 20 occurrences, and families with at least 20 species (each species with at least 20 occurrences)

library(tidyverse)

### there are some steps before this I can add later) 

plantFamilies = read.table(file = "atLeast20SpeciesPlantFamilies_atLeast20Occ.csv", sep = ",", header = T)
plantMoreData = read.table(file = "gbifPlantTaxonomy20orMoreOcc.csv", header = T, sep = ",")

plantTheseData = data.frame(family = plantMoreData$family, familyKey = plantMoreData$familyKey, order = plantMoreData$order, class = plantMoreData$class, phylum = plantMoreData$phylum)
plantGoodTheseData = distinct(plantTheseData)

plantGoodFamilyList = plantFamilies %>% left_join(plantGoodTheseData, by = "family")

