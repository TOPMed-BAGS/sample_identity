args <- commandArgs(trailingOnly = TRUE)
in.prefix <- args[1]
out.prefix <- args[2]
data.set.id <- args[3]
ped.file.name <- args[4]

#Merge the barcode and sample information 
in.fam <- read.table(paste0(in.prefix, ".fam"))
in.fam$V2_orig <- in.fam$V2
in.fam$V2 <- substr(in.fam$V2, 0, 8)
in.fam$ORDER <- 1:(dim(in.fam)[1])

#Merge the sample information and pedigree information
pedigree <- read.csv(ped.file.name)
merged.fam <- merge(in.fam, pedigree, by.x = "V2", by.y = "PATIENT", all.x=T)

#Assign dummy family IDs to patients with NA family IDs
na.patient.ids <- as.character(merged.fam$V2[is.na(merged.fam$FAMILY)])
na.fam.id <- 20000
for (id in na.patient.ids) {
  merged.fam$FAMILY[merged.fam$V2 == id] <- na.fam.id
  na.fam.id <- na.fam.id + 1
  merged.fam$FATHER[merged.fam$V2 == id] <- 0
  merged.fam$MOTHER[merged.fam$V2 == id] <- 0
  merged.fam$SEX[merged.fam$V2 == id] <- 0
}

#Create the output file
merged.fam <- merged.fam[order(merged.fam$ORDER),]
out.fam <- data.frame(
  paste0(data.set.id, "_", merged.fam$FAMILY), 
  merged.fam$V2_orig,
  merged.fam$FATHER,
  merged.fam$MOTHER,
  merged.fam$SEX,
  merged.fam$V6
)
write.table(out.fam, paste0(out.prefix, ".fam"),
            sep=" ", quote=F, row.names=F, col.names=F)