args <- commandArgs(trailingOnly = TRUE)
in.filename <- args[1]
out.filename <- args[2]

kgp.map <- read.delim("../input/HumanOmni2-5-8-v1-2-A-b138-rsIDs.txt")
array.bim <- read.delim(in.filename, head=F)
merged.bim <- merge(array.bim, kgp.map, by.x="V2", by.y="Name", all.x = T)
merged.bim$RsID <- as.character(merged.bim$RsID)
merged.bim$RsID[is.na(merged.bim$RsID)] <-
  as.character(merged.bim$V2[is.na(merged.bim$RsID)])
merged.bim$RsID[which(merged.bim$RsID == ".")] <-
  as.character(merged.bim$V2[which(merged.bim$RsID == ".")])
new.bim <- data.frame(
  chr=merged.bim$V1,
  snp_id=merged.bim$RsID,
  cm=merged.bim$V3,
  bp=merged.bim$V4,
  a1=merged.bim$V5,
  a2=merged.bim$V6
)
new.bim <- new.bim[order(new.bim$chr, new.bim$bp),]
write.table(new.bim, out.filename,
  sep="\t", quote=F, row.names=F, col.names=F)
