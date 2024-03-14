### example using beetles, repeated on each major dataset

library(dplyr)
library(tidyr)
library(groupdata2)

beetlesAll = read.table(file = "subset_GBIF_coleoptera.csv", header = T, sep = ",")

beetlesSummary = read.table(file = "GBIF_coleoptera_summary.csv", header = T, sep = ",")


beetlesAllPlusSummary = beetlesAll %>% left_join(beetlesSummary)


beetlesAllPlusSummary_20plus = subset(beetlesAllPlusSummary, beetlesAllPlusSummary$nrow >19)



beetlesAllPlusSummary_20plus_ds = downsample(beetlesAllPlusSummary_20plus, cat_col = "acceptedTaxonKey")

write.table(beetlesAllPlusSummary_20plus_ds, "14.iii.2024_beetlesAllPlusSummary_20plus_ds.txt", quote = FALSE, row.names = FALSE, sep = "\t")


beetlesAllPlusSummary_5plus = subset(beetlesAllPlusSummary, beetlesAllPlusSummary$nrow > 4)



beetlesAllPlusSummary_5plus_ds = downsample(beetlesAllPlusSummary_5plus, cat_col = "acceptedTaxonKey")

write.table(beetlesAllPlusSummary_5plus_ds, "14.iii.2024_beetlesAllPlusSummary_5plus_ds.txt", quote = FALSE, row.names = FALSE, sep = "\t")



beetleFamilies20SpeciesCount = as.vector(tapply(beetlesAllPlusSummary_20plus_ds $lat_range, beetlesAllPlusSummary_20plus_ds $family, length))
beetleFamily20List = sort(unique(beetlesAllPlusSummary_20plus_ds $family))

beetleFamilies20DF = data.frame(family = beetleFamily20List, taxonCount = beetleFamilies20SpeciesCount)
head(beetleFamilies20DF)

beetleFamilies20DF_100taxaPlus = subset(beetleFamilies20DF, beetleFamilies20DF$taxonCount > 1999)

write.table(beetleFamilies20DF_100taxaPlus, "14.iii.2024_beetleFamilies20DF_100taxaPlus.txt", quote = FALSE, row.names = FALSE, sep = "\t")



beetleFamilies5SpeciesCount = as.vector(tapply(beetlesAllPlusSummary_5plus_ds $lat_range, beetlesAllPlusSummary_5plus_ds $family, length))
beetleFamily5List = sort(unique(beetlesAllPlusSummary_5plus_ds $family))

beetleFamilies5DF = data.frame(family = beetleFamily5List, taxonCount = beetleFamilies5SpeciesCount)
head(beetleFamilies5DF)

beetleFamilies5DF_100taxaPlus = subset(beetleFamilies5DF, beetleFamilies5DF$taxonCount > 499)

write.table(beetleFamilies5DF_100taxaPlus, "14.iii.2024_beetleFamilies5DF_100taxaPlus.txt", quote = FALSE, row.names = FALSE, sep = "\t")


beetlesAllPlusSummary_20plus_ds_100taxaPlus = beetlesAllPlusSummary_20plus_ds %>% inner_join(beetleFamilies20DF_100taxaPlus)
write.table(beetlesAllPlusSummary_20plus_ds_100taxaPlus, "14.iii.2024_beetlesAllPlusSummary_20plus_ds_100taxaPlus.txt", quote = FALSE, row.names = FALSE, sep = "\t")



beetlesAllPlusSummary_5plus_ds_100taxaPlus = beetlesAllPlusSummary_5plus_ds %>% inner_join(beetleFamilies5DF_100taxaPlus)
write.table(beetlesAllPlusSummary_5plus_ds_100taxaPlus, "14.iii.2024_beetlesAllPlusSummary_5plus_ds_100taxaPlus.txt", quote = FALSE, row.names = FALSE, sep = "\t")



