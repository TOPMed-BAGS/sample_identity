#Read in the list created by the pipeline
list <- read.csv("../data/output/fixed_sample_map.txt", head=T)
list$delete <- 0
list$delete_reason <- "NA"

##Add back all the samples that was removed, with the reasons to do so
del.list <- read.table("../data/output/omni_delete.txt", stringsAsFactors = F)
old.map <- read.csv("../data/input/sample_map.txt")[,c(1:3)]
add.list <- merge(del.list, old.map, by.x="V1", by.y="plate_well")
names(add.list)[c(1,2)] <- c("plate_well", "delete_reason")
add.list$delete <- 1
add.list <- add.list[,c(3,1,4,5,2)]
##Do QC sample swaps
add.list$barnes_id[add.list$barnes_id == 15103003] <- 15103005
add.list$barnes_id[add.list$plate_well == "LP6008062-DNA_G11"] <- 15165005
##QC samples that were duplicates should be annotated as such
add.list$delete_reason[add.list$plate_well %in% c("LP6008061-DNA_G11", "LP6008087-DNA_B04")] <- "Omni QC and IBD duplicate"
##Clean up delete reason
add.list$delete_reason[add.list$delete_reason == "650_omni_no_solution"] <- "650 Omni IBD discordance no solution"
add.list$delete_reason[add.list$delete_reason == "duplicates"] <- "IBD duplicate"
add.list$delete_reason[add.list$delete_reason == "no_rhq"] <- "New sample with no RHQ"
add.list$delete_reason[add.list$delete_reason == "pedigree"] <- "Family IBD inconsistencies"
add.list$delete_reason[add.list$delete_reason == "qc"] <- "Omni QC"  #This would be the only samples we can still retain for analysis
add.list$delete_reason[add.list$plate_well %in% c("LP6008058-DNA_B02", "LP6008063-DNA_B10", "LP6008063-DNA_D07", "LP6008065-DNA_C11")] <- "Het/Hom WGS ratio > 4"
add.list$delete_reason[add.list$plate_well %in% c("LP6008058-DNA_G09", "LP6008062-DNA_B11", "LP6008063-DNA_F08", "LP6008065-DNA_E07")] <- "VCF file size very small"
list <- rbind(list, add.list)


write.table(list, "barbados_wgs_list.txt",  sep="\t", quote=F, row.names=F, col.names=T)

