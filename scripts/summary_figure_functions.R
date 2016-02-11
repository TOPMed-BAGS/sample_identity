###############################################################################
plotDuplicates <- function(genome, out.file.name) {

  png(out.file.name)
  par(mfrow=c(1,2))
  
  dupl.rows <- which(substr(genome$IID1,0,8) == substr(genome$IID2,0,8))
  
  duplicates <- genome[dupl.rows,]
  duplicates[,7:10] <- round(duplicates[,7:10],2)

  non.duplicates <- genome[-dupl.rows,]
  non.duplicates[,7:10] <- round(non.duplicates[,7:10],2)

  plot(non.duplicates$Z0, non.duplicates$Z2, xlab="Z0", ylab="Z2",
       xlim=c(0,1), ylim=c(0,1), pch=19, col="black")
  legend("topright", legend=c("Non-duplicate IDs"), pch=19, col=c("black"))
  plot(duplicates$Z0, duplicates$Z2, xlab="Z0", ylab="Z2",
       xlim=c(0,1), ylim=c(0,1), pch=19, col="blue")
  legend("topright", legend=c("Duplicate IDs"), pch=19, col=c("blue"))
  
  dev.off()

}  
  
###############################################################################
plotRelationships <- function(genome, out.file.name) {
  
  png(out.file.name)
  
  #Subset according to estimated IBD sharing
  duplicates <- genome[(genome$Z2 > 0.95),]
  parent.offspring <- genome[(genome$Z0 < 0.05) & (genome$Z1 > 0.95) & (genome$Z2 < 0.05),]
  full.sibs <- genome[(genome$Z0 < 0.4) & (genome$Z1 > 0.4) & (genome$Z2 > 0.15),]
  half.sibs <- genome[(genome$Z0 < 0.6) & (genome$Z1 < 0.6) & (genome$Z2 < 0.05),]
  cousins <- genome[(genome$Z0 > 0.6) & (genome$Z1 < 0.4) & (genome$Z2 < 0.02),]
  unrelated <- genome[(genome$Z0 > 0.8),]
  
  #Plot IBD 0 and 1 by estimated relationship 
  par(mfrow=c(2,2))
  plot(genome$Z0, genome$Z1, xlab="Z0", ylab="Z1", xlim=c(0,1), ylim=c(0,1), main="Estimated relationships")
  points(duplicates$Z0, duplicates$Z1, col="green3", pch=19)
  points(parent.offspring$Z0, parent.offspring$Z1, col="blue", pch=19)
  points(full.sibs$Z0, full.sibs$Z1, col="red", pch=19)
  points(half.sibs$Z0, half.sibs$Z1, col="magenta", pch=19)
  points(cousins$Z0, cousins$Z1, col="gray", pch=19)
  points(unrelated$Z0, unrelated$Z1, col="gray", pch=19)
  abline(h = 1:0, v = 1:0, col = "gray", lty=3)
  abline(h = 0.75, v=0.75, col = "gray", lty=3)
  abline(h = 0.5:0,v=0.5, col = "gray", lty=3)
  abline(h = 0.25:0,v=0.25, col = "gray", lty=3)
  legend("topright",legend=c("Duplicates", "Parent-Offspring", "Full Sibs", "Half Sibs", "Other"),
         pch=19, col=c("green3","blue","red","magenta", "gray"), cex=0.8 )
  
  #Subset according to pedigree relationship
  parent.offspring <- genome[genome$RT == "PO",]
  full.sibs <- genome[genome$RT == "FS",]
  half.sibs <- genome[genome$RT == "HS",]
  cousins <- genome[genome$RT == "OT",]
  unrelated <- genome[genome$RT == "UN",]
  
  #Plot IBD 0 and 1 by nuclear family relationship 
  plot(genome$Z0, genome$Z1, xlab="Z0", ylab="Z1", xlim=c(0,1), ylim=c(0,1), main="Nuclear family relationships")
  points(parent.offspring$Z0, parent.offspring$Z1, col="blue", pch=19)
  points(full.sibs$Z0, full.sibs$Z1, col="red", pch=19)
  points(half.sibs$Z0, half.sibs$Z1, col="magenta", pch=19)
  abline(h = 1:0, v = 1:0, col = "gray", lty=3)
  abline(h = 0.75, v=0.75, col = "gray", lty=3)
  abline(h = 0.5:0,v=0.5, col = "gray", lty=3)
  abline(h = 0.25:0,v=0.25, col = "gray", lty=3)
  legend("topright", legend=c("Parent-Offspring", "Full Sibs", "Half Sibs"),
         pch=19, col=c("blue","red","magenta"), cex=0.8 )
  
  #Plot IBD 0 and 1 for cousins and others
  other <- data.frame(Z0=c(cousins$Z0, unrelated$Z0),
                      Z1=c(cousins$Z1, unrelated$Z1),
                      Z2=c(cousins$Z2, unrelated$Z2))
  plot(other$Z0, other$Z1, xlab="Z0", ylab="Z1", xlim=c(0,1), ylim=c(0,1), 
       pch=19, col="gray", main="Other relationships")
  abline(h = 1:0, v = 1:0, col = "gray", lty=3)
  abline(h = 0.75, v=0.75, col = "gray", lty=3)
  abline(h = 0.5:0,v=0.5, col = "gray", lty=3)
  abline(h = 0.25:0,v=0.25, col = "gray", lty=3)
  legend("topright", legend="Other", pch=19, col="gray", cex=0.8 )
  
  dev.off()
}

###############################################################################