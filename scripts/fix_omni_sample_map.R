in.map <- read.csv("../data/input/sample_map.txt", head=T, stringsAsFactors = F)
del.ids <- read.table("../data/output/omni_delete.txt", stringsAsFactors = F)
swap.ids <- read.table("../data/output/omni_swaps.txt", head=T, stringsAsFactors = F)
rhq.ids <- read.table("../data/input/rhqs.txt", stringsAsFactors = F)
fam.650 <- read.table("../data/input/650.fam", stringsAsFactors = F)

#Add the 650 IDs to the list of rhq IDs - we should have phenotypes for them somewhere!
ids.650 <- data.frame(V1=fam.650$V2) 
ids.650$V2 <- "650"
rhq.ids <- rbind(rhq.ids, ids.650)

#Remove IDs marked for deletion
out.map <- in.map[!(in.map$plate_well %in% del.ids$V1),1:3]

#Update barnes IDs with their new swapped versions
out.map <- merge(out.map, swap.ids, by.x="barnes_id", by.y="prev.id", all.x=T)
out.map$barnes_id[!is.na(out.map$new.id)] <- out.map$new.id[!is.na(out.map$new.id)] 

#Write to file which sample IDs we have no RHQs for
missing.ids <- out.map[!(out.map$barnes_id %in% rhq.ids$V1),1]
missing.frame <- data.frame(barnes_id = missing.ids)
missing.frame <- merge(missing.frame, out.map)
del.frame <- data.frame(V1=missing.frame[,2])
del.frame$V2 <- "no_rhq"
write.table(del.frame, "../data/output/omni_delete.txt", append=T, 
            sep="\t", quote=F, row.names=F, col.names=F)

#Delete samples with no RHQs
out.map <- out.map[(out.map$barnes_id %in% rhq.ids$V1),]

#Write the output file - barnes_id, plate_well, topmed_id
out.map <- out.map[,1:3]
write.csv(out.map, "../data/output/fixed_sample_map.txt", quote=F, row.names=F, col.names=T)

