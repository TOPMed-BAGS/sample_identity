#Get the input information
genome <- read.table("plink.genome", head=T, stringsAsFactors = F)
dupl.frame <-  genome[genome$PI_HAT > 0.9,c(2,4)]
miss.frame <- read.table("miss.imiss", head=T, stringsAsFactors = F)[,c(2,4)]
miss.frame <- miss.frame[(miss.frame$IID %in% dupl.frame$IID1) | (miss.frame$IID %in% dupl.frame$IID2),]

#For each IID1, get its duplicate version, and remove the sample with the most missing genotype call
remove.ids <- c()
for (i in 1:dim(dupl.frame)[1]) {
  iid1 <- dupl.frame$IID1[i]
  iid2 <- dupl.frame$IID2[i]
  nmiss.1 <- miss.frame$N_MISS[miss.frame$IID == iid1]
  nmiss.2 <- miss.frame$N_MISS[miss.frame$IID == iid2]
  if (nmiss.1 > nmiss.2) {
    remove.ids <- c(remove.ids, iid1)
  } else {
    remove.ids <- c(remove.ids, iid2)
  }
}

out.frame <- data.frame(plate_well_id = remove.ids[!duplicated(remove.ids)])
out.frame$reason <- "duplicates"
write.table(out.frame, "../output/omni_delete.txt",  sep="\t", quote=F, row.names=F, col.names=F, append=T)
