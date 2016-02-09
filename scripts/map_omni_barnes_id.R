args <- commandArgs(trailingOnly = TRUE)
in.filename <- args[1]
out.filename <- args[2]
sample.info.filename <- args[3]

#Merge the barcode and sample information
in.fam <- read.table(in.filename)
map <- read.csv(sample.info.filename)[,c(1,2)]
names(in.fam)[1] <- "plate_well"
in.fam$ORDER <- 1:(dim(in.fam)[1])
merged.fam <- merge(in.fam, map)
while(sum(duplicated(merged.fam$barnes_id)) > 0) {
  merged.fam$barnes_id[duplicated(merged.fam$barnes_id)] <- 
    paste0(merged.fam$barnes_id[duplicated(merged.fam$barnes_id)], "_dup")
}

#Create the output file
merged.fam <- merged.fam[order(merged.fam$ORDER),]
out.fam <- data.frame(
  merged.fam$plate_well, 
  merged.fam$barnes_id,
  merged.fam$V3,
  merged.fam$V4,
  merged.fam$V5,
  merged.fam$V6
)
write.table(out.fam, out.filename,
            sep=" ", quote=F, row.names=F, col.names=F)