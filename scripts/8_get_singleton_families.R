sample.map <- read.table("../data/output/fixed_sample_map.txt", head=T, stringsAsFactors = F)
pedigrees <- read.csv("../data/input/fixed_pedigrees.txt", head=T, stringsAsFactors = F)

merged <- merge(sample.map, pedigrees, by.x="barnes_id", by.y="PATIENT")
