args <- commandArgs(trailingOnly = TRUE)
fam.prefix <- args[1]
#fam.prefix <- "650" #650 or omni
prest.file.name <- paste0("../data/working/", fam.prefix, "_prest_results_results")

prest <- read.table(prest.file.name, head=T, stringsAsFactors = F)[,1:5]
genome <- read.table("../data/output/fixed.genome", head=T, stringsAsFactors = F)[,1:5]

#Filter prest to contain only nuclear family relationships
#Add column PREST_RT
prest <- prest[prest$reltype %in% c(1,2,10),]
prest$PREST_RT <- NA
prest$PREST_RT[prest$reltype == 1] <- "FS"
prest$PREST_RT[prest$reltype == 2] <- "HS"
prest$PREST_RT[prest$reltype == 10] <- "PO"

#Filter genome to contain only within dataset relationships, and nuclear family relationships
genome <- genome[grep(fam.prefix, genome$FID1),]
genome <- genome[grep(fam.prefix, genome$FID2),]
genome <- genome[which(genome$RT %in% c("FS", "HS", "PO")),]

#Merge prest and genome
merged <- merge(prest, genome)

#Which relationships do not match up?
mismatched <- merged[merged$PREST_RT != merged$RT,-5]
names(mismatched)[5] <- "ESTIMATED_RT"
names(mismatched)[6] <- "ACTUAL_RT"
mismatched$FID <- sub(paste0(fam.prefix, "_"),"", mismatched$FID1)
mismatched <- mismatched[,c(7,2,4,5,6)]

#Write the output file
write.table(merged[merged$PREST_RT != merged$RT,],
            paste0("../data/output/", fam.prefix, "_relationship_mismatches.txt"),
            sep="\t", quote=F, row.names=F, col.names=T)