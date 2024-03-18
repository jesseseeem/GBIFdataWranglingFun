### combine files for analyses: 

arachnid_20plus = read.table(file = "14.iii.2024_arachnidsAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

beetle_20plus = read.table(file = "14.iii.2024_beetlesAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

copepod_20plus = read.table(file = "14.iii.2024_copepodsAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

diptera_20plus = read.table(file = "14.iii.2024_dipterasAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")


hymenoptera_20plus = read.table(file = "14.iii.2024_hymenopterasAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

hemiptera_20plus = read.table(file = "15.iii.2024_hemipteransAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

odonates_20plus = read.table(file = "15.iii.2024_odonatesAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

leps_20plus = read.table(file = "14.iii.2024_lepsAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")



arthropodCombined_20plus = rbind(arachnid_20plus, beetle_20plus, copepod_20plus, diptera_20plus, hymenoptera_20plus, hemiptera_20plus, odonates_20plus, leps_20plus)


write.table(arthropodCombined_20plus, "17.iii.2024_arthropodsCombinedAllPlusSummary_20plus_ds_100taxaPlus.txt", quote = FALSE, row.names = FALSE, sep = "\t")


asperagales_20plus = read.table(file = "14.iii.2024_asperagalessAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

asterales_20plus = read.table(file = "15.iii.2024_asteralessAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

bryophyte_20plus = read.table(file = "15.iii.2024_bryophytesAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

conifer_20plus = read.table(file = "15.iii.2024_conifersAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

fabales_20plus = read.table(file = "15.iii.2024_fabalessAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

ferns_20plus = read.table(file = "15.iii.2024_fernsAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

lamiales_20plus = read.table(file = "15.iii.2024_lamialessAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

malpighiales_20plus = read.table(file = "15.iii.2024_malpighialessAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")


plantsCombined_20plus = rbind(asperagales_20plus, asterales_20plus, bryophyte_20plus, conifer_20plus, fabales_20plus, ferns_20plus, lamiales_20plus, malpighiales_20plus)

write.table(plantsCombined_20plus, "17.iii.2024_plantsCombinedAllPlusSummary_20plus_ds_100taxaPlus.txt", quote = FALSE, row.names = FALSE, sep = "\t")


bivalves_20plus = read.table(file = "14.iii.2024_bivalvesAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

sponges_20plus = read.table(file = "14.iii.2024_spongesAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

annelids_20plus = read.table(file = "15.iii.2024_annelidsAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

cnidarians_20plus = read.table(file = "15.iii.2024_cnidariansAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

echinoderms_20plus = read.table(file = "15.iii.2024_echinodermsAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")



invertsCombined_20plus = rbind(bivalves_20plus, sponges_20plus, annelids_20plus, cnidarians_20plus, echinoderms_20plus)

write.table(invertsCombined_20plus, "17.iii.2024_invertsCombinedAllPlusSummary_20plus_ds_100taxaPlus.txt", quote = FALSE, row.names = FALSE, sep = "\t")


chromists_20plus = read.table(file = "15.iii.2024_chromistsAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")
fungi_20plus = read.table(file = "15.iii.2024_fungisAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

rhodophytes_20plus = read.table(file = "15.iii.2024_rhodophytesAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

otherEuks_20plus = rbind(chromists_20plus, fungi_20plus, rhodophytes_20plus)


write.table(otherEuks_20plus, "17.iii.2024_otherEuksCombinedAllPlusSummary_20plus_ds_100taxaPlus.txt", quote = FALSE, row.names = FALSE, sep = "\t")

chordates_20plus = read.table(file = "15.iii.2024_chordatesAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")

gastropod_20plus = read.table(file = "17.iii.2024_gastropodsAllPlusSummary_20plus_ds_100taxaPlus.txt", header = T, sep = "\t")


everythingCombined_20plus = rbind(arthropodCombined_20plus, plantsCombined_20plus, invertsCombined_20plus, otherEuks_20plus, chordates_20plus, gastropod_20plus)


write.table(everythingCombined_20plus, "17.iii.2024_everythingCombinedAllPlusSummary_20plus_ds_100taxaPlus.txt", quote = FALSE, row.names = FALSE, sep = "\t")









