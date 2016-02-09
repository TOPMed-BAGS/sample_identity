#Identify swaps based on the 650 data
genome.out <- read.table("../data/working/ibd_650_omni_pairs.genome", head=T, stringsAsFactors = F)

#Get the nr of discordant samples (same ID but are not IBD duplicates)
discordant <- genome.out[which(genome.out$IID1 == genome.out$IID2),]
discordant <- discordant[discordant$PI_HAT < 0.95,]
cat("n_discordant", dim(discordant)[1], "\n", file="../data/output/flow_nrs.txt", append = T)

#Get the nr of crossmatched samples (different IDs that are IBD duplicates)
crossmatched <- genome.out[-which(genome.out$IID1 == genome.out$IID2),]
crossmatched  <- crossmatched[crossmatched$PI_HAT >= 0.95,]
cat("n_crossmatched", dim(crossmatched )[1], "\n", file="../data/output/flow_nrs.txt", append = T)

#How many samples that are discordant do we have a better identity for in the 650 data?
#How many samples do not?
cat("n_disc_resolved", sum(discordant$IID2 %in% crossmatched$IID1), "\n", file="../data/output/flow_nrs.txt", append = T)
cat("n_disc_unresolved", sum(!(discordant$IID2 %in% crossmatched$IID1)), "\n", file="../data/output/flow_nrs.txt", append = T)

prev.id <- c(crossmatched $IID2[(substr(crossmatched $FID2, 0, 5) == "omni_")],
             crossmatched $IID1[(substr(crossmatched $FID1, 0, 5) == "omni_")])
new.id <- c(crossmatched $IID1[(substr(crossmatched $FID1, 0, 4) == "650_")],
            crossmatched $IID2[(substr(crossmatched $FID2, 0, 4) == "650_")])
swap.frame <- data.frame(prev.id, new.id)
swap.frame$reason <- "650_omni"

#Write the omni_swap file
write.table(swap.frame, "../data/output/omni_swaps.txt",  sep="\t", quote=F, row.names=F, col.names=T)

#Write the unresolved discordant samples
unresolved.ids <- discordant$IID2[!(discordant$IID2 %in% crossmatched$IID1)]
write.table(unresolved.ids, "../data/output/650_omni_unresolved_ids.txt",  sep="\t", quote=F, row.names=F, col.names=F)