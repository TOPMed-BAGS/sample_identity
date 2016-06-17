#Get the input information
genome <- read.table("plink.genome", head=T, stringsAsFactors = F)
dupl.frame <-  genome[genome$PI_HAT > 0.9,c(2,4)]
qc.report <- read.table("../input/illumina_qc_report.txt", head=T)[,c(1,5)]

#For each IID1, get its duplicate version, and remove the sample with the most missing genotype call
remove.ids <- c()
for (i in 1:dim(dupl.frame)[1]) {
  iid1 <- dupl.frame$IID1[i]
  iid2 <- dupl.frame$IID2[i]
  nsnps.1 <- qc.report[qc.report == iid1]
  nsnps.2 <- qc.report[qc.report == iid2]
  if (nsnps.1 < nsnps.2) {
    remove.ids <- c(remove.ids, iid1)
  } else {
    remove.ids <- c(remove.ids, iid2)
  }
}

out.frame <- data.frame(plate_well_id = remove.ids[!duplicated(remove.ids)])
out.frame$reason <- "duplicates"
write.table(out.frame, "../output/omni_delete.txt",  sep="\t", quote=F, row.names=F, col.names=F, append=T)
write.table(out.frame, "../output/omni_duplicates.txt",  sep="\t", quote=F, row.names=F, col.names=F, append=T)
