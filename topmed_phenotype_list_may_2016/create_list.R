#Read in the list created by the pipeline
list <- read.csv("../data/output/fixed_sample_map.txt", head=T, stringsAsFactors = F)
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

#Change the column names to denote new Barnes IDs and old Barnes IDs
names(list)[1] <- c("new_barnes_id")
old.map <- read.csv("../data/input/sample_map.txt", head=T, stringsAsFactors = F)[,c(1,2)]
names(old.map)[1] <- c("old_barnes_id")
list <- merge(list, old.map)

#Update the identities of duplicate samples that were deleted
dupl.frame <- read.table("../data/output/omni_duplicates.txt")
del.dupl <- list[list$delete_reason == "IBD duplicate",]
for (plate.well in del.dupl$plate_well) {
  if (plate.well %in% c("LP6008087-DNA_C01", "LP6008059-DNA_D09")){  #special case for the triples
    dupl.plate.well <- "LP6008087-DNA_D01"
  } else if (plate.well %in% dupl.frame$V1) {
    dupl.plate.well <- dupl.frame$V2[dupl.frame$V1 == plate.well]
  } else  if (plate.well %in% dupl.frame$V2) {
    dupl.plate.well <- dupl.frame$V1[dupl.frame$V2 == plate.well]
  } 
  new.barnes.id <- list$new_barnes_id[(list$plate_well == dupl.plate.well)]
  list$new_barnes_id[list$plate_well == plate.well] <- new.barnes.id
}

#Write table to inspect duplicates
dupl.ids <- list$new_barnes_id[duplicated(list$new_barnes_id)]
dupl.list <- list[list$new_barnes_id %in% dupl.ids,]
write.table(dupl.list[order(dupl.list$new_barnes_id, dupl.list$delete),], "duplicate_barnes_ids.txt", 
            sep="\t", quote=F, row.names=F, col.names=T)

#Samples that are deleted for the following reasons should get new dummy IDs and also be updated in the pedigree:
## Omni IBD discordance no solution
## Family IBD inconsistencies
## New sample with no RHQ
ped <- read.csv("../data/input/fixed_pedigrees.txt", stringsAsFactors = F)
dummy.frame <- list[(list$delete == 1) & 
                      (list$delete_reason %in% c("Omni IBD discordance no solution", 
                                                 "Family IBD inconsistencies", 
                                                 "New sample with no RHQ")),]
dummy.i <- 900
for (id in dummy.frame$old_barnes_id) {
  new.id <- paste0(substr(list$old_barnes_id[list$old_barnes_id == id],1,5), dummy.i)
  list$new_barnes_id[list$old_barnes_id == id] <- new.id
  ped$PATIENT[ped$PATIENT == id] <- new.id
  ped$FATHER[ped$FATHER == id] <- new.id
  ped$MOTHER[ped$MOTHER == id] <- new.id
  dummy.i <- dummy.i + 1  
} 

#See email to Meher, "Re: missing pedigrees", sent 6 July 2016, for the following manual updates:
dummy.id <- 15161904 
list$new_barnes_id[list$new_barnes_id == dummy.id] <- list$old_barnes_id[list$new_barnes_id == dummy.id] 
ped$PATIENT[ped$PATIENT == dummy.id] <- 15161002
id <- 15004502
new.id <- paste0(substr(list$old_barnes_id[list$old_barnes_id == id],1,5), dummy.i)
list$new_barnes_id[list$old_barnes_id == id] <- new.id
ped$PATIENT[ped$PATIENT == id] <- new.id
ped$FATHER[ped$FATHER == id] <- new.id
ped$MOTHER[ped$MOTHER == id] <- new.id

#Annotate the output with Topmed failures
topmed.failed <- read.delim("topmed_failed_annotation.txt", stringsAsFactors = F)
list <- merge(list, topmed.failed)

#Write the output
write.table(list$new_barnes_id[(list$delete == 1) & 
                                 (list$delete_reason %in% c("Omni IBD discordance no solution", 
                                                            "Family IBD inconsistencies", 
                                                            "New sample with no RHQ"))], "new_dummy_ids.txt", quote=F, row.names=F, col.names = F)
write.csv(ped, "fixed_pedigrees.txt", quote=F, row.names=F)
write.table(list, "barbados_wgs_list.txt",  sep="\t", quote=F, row.names=F, col.names=T)

