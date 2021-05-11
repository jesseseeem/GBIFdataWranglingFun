### just generate some fake species data that has properties of species distributions? 

library(meteR)
library(ggplot2)
library(viridis)

maxLat = runif(50000, min = -70, max = 90)
minLat = runif(50000, min = -30, max = 30)
fakeLats = (maxLat + minLat)/2 + rcauchy(50000, location = 0, scale = 1)


longCauchy = sample(c(125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 125, 0, -125, -60, 45), 1000000, replace = TRUE) + rcauchy(1000000, location = 0, scale = 5)

longCauchySubset = longCauchy[ which(longCauchy < 180 & longCauchy > -180)]
fakeLongs = sample(longCauchySubset, 50000, replace = TRUE)

### generate lat/long data that are more evenly distributed, without a strong latitudinal diversity gradient, but will still result in beta diversity because of intraspecific clustering
fakeFakeLat = runif(50000, min = -70, max = 70)
fakeFakeLong = runif(50000, min = -170, max = 170)

fakeGenera = sample(100000:200000, 50000, replace = FALSE)

fakeSAD = meteESF(N0 = 5000000, S0 = 50000, E0 = NULL, minE = 1)
fakeSAD = sad(fakemeteSAD)
fakeSADrepValues = fakeSAD$q(seq(0, 1, length = 50001))


fakeGeneraOccurrences = rep(fakeGenera, c(fakeSADrepValues[1:50000]))
fakeLatOccurrences = rep(fakeLats, c(fakeSADrepValues[1:50000])) + rcauchy(length(fakeGeneraOccurrences), location = 0, scale = 0.5)
fakeLongOccurrences = rep(fakeLongs, c(fakeSADrepValues[1:50000])) + rcauchy(length(fakeGeneraOccurrences), location = 0, scale = 0.5)

fakeOccurrenceData = data.frame(fakeGeneraOccurrences, fakeLatOccurrences, fakeLongOccurrences)


fakeOccurrenceData = fakeOccurrenceData[which(fakeOccurrenceData$fakeLatOccurrences >-80 & fakeOccurrenceData$fakeLatOccurrences < 90 & fakeOccurrenceData$fakeLongOccurrences > -180 & fakeOccurrenceData$fakeLongOccurrences < 180), ]




# hexFake <- ggplot(fakeOccurrenceData, aes(x = fakeLongOccurrences, y = fakeLatOccurrences)) +
#	theme_minimal() +
#	geom_hex(aes(fill = stat(log(count))), binwidth = c(1, 1))+ 
#	scale_fill_viridis() +
#	labs(title = "Fake Occurrences")
#
# plot(hexFake)



dev.new()
ggplot(fakeOccurrenceData, aes(x = fakeLongOccurrences, y = fakeLatOccurrences, z = fakeGeneraOccurrences))+
	stat_summary_hex(
		fun = function(z){log10(length(unique(z)))}, 
		binwidth = c(1, 1))+
		scale_fill_distiller(palette="YlGnBu")+
	theme_minimal() +
	labs(title = "Fake genus richness per 1 x 1 degree")


