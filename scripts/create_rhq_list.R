new.rhq <- read.table("new_rhq.txt")  #A text file containing all the new RHQ IDs
new.rhq$V2 <- "new_rhq"

adult.rhqs <- read.delim("adult_rhq.txt")[,1]   #Extracted from BC Gene
adult.rhqs <- adult.rhqs[!duplicated(adult.rhqs)]
adult.rhqs <- gsub("-","", adult.rhqs)
adult.rhq <- data.frame(V1=adult.rhqs)
adult.rhq$V2 <- "old_adult_rhq"

child.rhqs <- read.delim("child_rhq.txt")[,1]   #Extracted from BC Gene
child.rhqs <- child.rhqs[!duplicated(child.rhqs)]
child.rhq <- data.frame(V1=child.rhqs)
child.rhq$V2 <- "old_child_rhq"

out.frame <- rbind(new.rhq, adult.rhq, child.rhq)
out.frame$V1[out.frame$V1 == "155022001"] <- "15022001"
out.frame$V1[out.frame$V1 == "5372002"] <- "15372002"
write.table(out.frame, "rhqs.txt", sep="\t", quote=F, row.names=F, col.names=F)
