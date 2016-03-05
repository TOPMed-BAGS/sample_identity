#Before any changes
####################################################################################

sample.map <- read.csv("../data/input/sample_map.txt", stringsAsFactors = F)
names(sample.map)[12] <- "q_sex"

qc <- read.table("../data/input/illumina_qc_report.txt", head=T, stringsAsFactors = F)[,c(1,2)]
qc$ill_sex <- 1
qc$ill_sex[qc$sex == "F"] <- 2
names(qc)[c(1,2)] <- c("plate_well", "illumina_raw_sex")

pedigree <- read.csv("../data/input/fixed_pedigrees.txt", stringsAsFactors = F)[,c(1,5)]
names(pedigree) <- c("barnes_id", "ped_sex")

manifest <- read.csv("../data/input/manifest.txt")[,c(2,5)]   #Use the manifest to get the pedigree sex since according to Nick this is most recent
manifest$man_sex <- NA
manifest$man_sex[manifest$Gender == "Male"] <- 1
manifest$man_sex[manifest$Gender == "Female"] <- 2
manifest <- manifest[,c(1,3)]
names(manifest)[1] <- c("barnes_id")

merged <- merge(sample.map, qc)
merged <- merge(merged, pedigree)
merged <- merge(merged, manifest)

(sum(merged$ill_sex != merged$ped_sex))
(sum((merged$ill_sex != merged$ped_sex) | merged$ill_sex != merged$man_sex))
(merged[(merged$ill_sex != merged$ped_sex) |(merged$ill_sex != merged$man_sex) ,
        c(1,2,8,12,14,15,16)])

#After changes
####################################################################################

sample.map <- read.csv("../data/output/fixed_sample_map.txt", stringsAsFactors = F)

merged <- merge(sample.map, qc)
merged <- merge(merged, pedigree)
merged <- merge(merged, manifest)

(sum(merged$ill_sex != merged$ped_sex))
(sum((merged$ill_sex != merged$ped_sex) | merged$ill_sex != merged$man_sex))
(merged[(merged$ill_sex != merged$ped_sex) |(merged$ill_sex != merged$man_sex) , -3])

write.table(merged[(merged$ill_sex != merged$ped_sex) |(merged$ill_sex != merged$man_sex) , -3],
  "../data/output/sex_mismatches.txt", sep="\t", quote=F, row.names=F, col.names=T)
