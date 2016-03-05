ped <- read.csv("pedigrees.txt", stringsAsFactors = F)
fixes <- read.delim("../output/pedigree_parents.txt", head=T, stringsAsFactors = F)

for (i in 1:dim(fixes)[1]) {
  add_row <- F
  sample_id <- fixes$id[i]
  relationship <- fixes$relationship[i]
  updated_id <- fixes$updated_id[i]
  if (relationship == "Pedigree") {
    if (sample_id %in% ped$PATIENT) {
      ped$FAMILY[ped$PATIENT == sample_id] <- updated_id
    } else {
      new_row <- data.frame(PATIENT=sample_id,
                            FAMILY=updated_id,
                            FATHER=0,
                            MOTHER=0,
                            SEX=1,
                            TWINSTAT=NA,
                            MZPAIR=NA,
                            DZPAIR=NA)
      ped <- rbind(ped, new_row)
    }
  } else {
    if (is.na(updated_id)) {
      fid <- ped$FAMILY[ped$PATIENT == sample_id]
      updated_id <- max(ped$PATIENT[ped$FAMILY == fid]) + 1
      add_row <- T
    }
    if (relationship == "Father") {
      ped$FATHER[ped$PATIENT == sample_id] <- updated_id
      if (add_row) {
        new_row <- data.frame(PATIENT=updated_id,
                              FAMILY=ped$FAMILY[which(ped$PATIENT == sample_id)],
                              FATHER=0,
                              MOTHER=0,
                              SEX=1,
                              TWINSTAT=NA,
                              MZPAIR=NA,
                              DZPAIR=NA)
        ped <- rbind(ped, new_row)
      }
    }
    if (relationship == "Mother") {
      ped$MOTHER[ped$PATIENT == sample_id] <- updated_id
      if (add_row) {
        new_row <- data.frame(PATIENT=updated_id,
                              FAMILY=ped$FAMILY[which(ped$PATIENT == sample_id)],
                              FATHER=0,
                              MOTHER=0,
                              SEX=2,
                              TWINSTAT=NA,
                              MZPAIR=NA,
                              DZPAIR=NA)
        ped <- rbind(ped, new_row)
      }
    }
  }
}

ped <- ped[order(ped$FAMILY, ped$PATIENT),]

sex.fixes <- read.table("../output/pedigree_sex.txt")
for (id in sex.fixes$V1) {
    ped$SEX[ped$PATIENT == id] <- sex.fixes$V2[sex.fixes$V1 == id]
}

write.csv(ped, "../input/fixed_pedigrees.txt", quote=F, row.names=F, na="")
