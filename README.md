# GBIFdataWranglingFun
Just some scripts to wrangle GBIF datasets for fun and entertainment :)

These are some scripts in R and Julia that I'm playing around with to manipulate datasets that can be downloaded from https://www.gbif.org/ 
For example, this one: 
https://www.gbif.org/occurrence/download/0253699-200613084148143

Because the initial dataset is large, I do some of the initial data processing in Julia https://julialang.org/ using packages like DataFrames and CSV

Then I switch over to R for visualization and some ecological statistics (e.g., from the vegan and iNEXT libraries). 
