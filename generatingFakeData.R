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

### generate lat/long data that are more evenly distributed, without a strong latitudinal diversity gradient
### will still result in beta diversity because of intraspecific clustering generated lower down
fakeFakeLat = runif(50000, min = -70, max = 70)
fakeFakeLong = runif(50000, min = -170, max = 170)

fakeGenera = sample(100000:200000, 50000, replace = FALSE)

### use meteR library to generate a species-abundance distribution informed by Maximum Entropy Theory of Ecology
### see https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.12625
fakeSAD = meteESF(N0 = 5000000, S0 = 50000, E0 = NULL, minE = 1)
fakeSAD = sad(fakemeteSAD)
fakeSADrepValues = fakeSAD$q(seq(0, 1, length = 50001))

### use that species abundance distribution to repeat genus names
fakeGeneraOccurrences = rep(fakeGenera, c(fakeSADrepValues[1:50000]))
### lat & long data are repeated, but random values are added so not all conspecific occurrences are right on top of each other
### cauchy distribution has some good outliers occasionally (including some that will be off the grid)
fakeLatOccurrences = rep(fakeLats, c(fakeSADrepValues[1:50000])) + rcauchy(length(fakeGeneraOccurrences), location = 0, scale = 0.5)
fakeLongOccurrences = rep(fakeLongs, c(fakeSADrepValues[1:50000])) + rcauchy(length(fakeGeneraOccurrences), location = 0, scale = 0.5)

fakeFakeLatOccurences = rep(fakeFakeLat, c(fakeSADrepValues[1:50000])) + rcauchy(length(fakeGeneraOccurrences), location = 0, scale = 0.5)
fakeFakeLongOccurrences = rep(fakeFakeLong, c(fakeSADrepValues[1:50000])) + rcauchy(length(fakeGeneraOccurrences), location = 0, scale = 0.5)

randomLat = runif(length(fakeGeneraOccurrences), min = -90, max = 90)
randomLong = runif(length(fakeGeneraOccurrences), min = -180, max = 180)

fakeOccurrenceData = data.frame(fakeGeneraOccurrences, fakeLatOccurrences, fakeLongOccurrences, fakeFakeLatOccurences, fakeFakeLongOccurrences, randomLat, randomLong)

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


