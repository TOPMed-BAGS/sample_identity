sample.map <- read.csv("../data/output/fixed_sample_map.txt", head=T, stringsAsFactors = F)
pedigrees <- read.csv("../data/input/fixed_pedigrees.txt", head=T, stringsAsFactors = F)

merged <- merge(sample.map, pedigrees, by.x="barnes_id", by.y="PATIENT", all.x=T)
singleton.families <- names(table(merged$FAMILY)[table(merged$FAMILY)==1])
out.frame <- merged[is.na(merged$FAMILY) | (
  !is.na(merged$FAMILY) & (merged$FAMILY %in% singleton.families)
),1:4]

#Write the list of singletons
write.table(out.frame, "../data/output/singletons.txt", sep="\t", quote=F, row.names=F, col.names=T)

#Write output for flow diagram
del.frame <- merged[!(merged$plate_well %in% out.frame$plate_well),]
p_ped_fixed_omni <- length(unique(merged$FAMILY))
n_final_omni <- dim(del.frame)[1]
p_final_omni <- length(unique(del.frame$FAMILY))

cat("p_ped_fixed_omni", p_ped_fixed_omni, "\n", file="../data/output/flow_nrs.txt", append = T)
cat("n_final_omni", n_final_omni, "\n", file="../data/output/flow_nrs.txt", append = T)
cat("p_final_omni", p_final_omni, "\n", file="../data/output/flow_nrs.txt", append = T)