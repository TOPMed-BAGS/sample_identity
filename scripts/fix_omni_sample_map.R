in.map <- read.csv("../data/input/sample_map.txt", head=T, stringsAsFactors = F)
del.ids <- read.table("../data/output/omni_delete.txt", stringsAsFactors = F)
swap.ids <- read.table("../data/output/omni_swaps.txt", head=T, stringsAsFactors = F)

#Remove IDs marked for deletion
out.map <- in.map[!(in.map$plate_well %in% del.ids$V1),1:3]

#Update barnes IDs with their new swapped versions
out.map <- merge(out.map, swap.ids, by.x="barnes_id", by.y="prev.id", all.x=T)
out.map$barnes_id[!is.na(out.map$new.id)] <- out.map$new.id[!is.na(out.map$new.id)] 

#Write the output file - barnes_id, plate_well, topmed_id
out.map <- out.map[1:3,]
write.table(out.map, "../data/output/fixed_sample_map.txt", sep="\t", quote=F, row.names=F, col.names=T)

