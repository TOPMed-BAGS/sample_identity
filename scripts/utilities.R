library('kinship2')

genome <- read.table("../data/output/initial.genome", head=T, stringsAsFactors = F)
pedigree <- read.csv("../data/input/pedigrees.txt")
qc.frame <- read.table("../data/input/illumina_qc_report.txt", head=T, stringsAsFactors = F)
sample.map <- read.csv("../data/input/sample_map.txt")
fam.650 <- read.table("../data/input/650.fam")
fam.omni <- read.table("../data/input/orig_omni.fam")



###############################################################################
drawFamily <- function(fid) {
  sub.pedigree <- pedigree[pedigree$FAMILY == fid,]
  
  #Add age and Illumina sex if in Omni
  #Create an ID column: sample_id:sex:age if in Omni, else just sample_id
  #Create a colour column: red if in omni, blue if in 650, purple if in both
  #Create a mismatch column: 1 if the 650 and omni version of the sample mismatches
  sub.pedigree$illumina_sex <- NA
  sub.pedigree$age <- NA
  sub.pedigree$id <- sub.pedigree$PATIENT
  sub.pedigree$col <- "black"
  sub.pedigree$mismatch <- 0
  for (iid in sub.pedigree$PATIENT) {
    if (iid %in% fam.omni$V2) {
      plate_well <- sample.map$plate_well[sample.map$barnes_id == iid]
      illumina_sex <- qc.frame$sex[qc.frame$sample.id == plate_well]
      age <- sample.map$questionnaire_age[sample.map$barnes_id == iid]
      sub.pedigree$illumina_sex[sub.pedigree$PATIENT == iid] <- illumina_sex
      sub.pedigree$age[sub.pedigree$PATIENT == iid] <- age
      sub.pedigree$id[sub.pedigree$PATIENT == iid] <- paste(iid, illumina_sex, age, sep=":")
      sub.pedigree$col[sub.pedigree$PATIENT == iid] <- "red"
    }
    if (iid %in% fam.650$V2) {
      sub.pedigree$col[sub.pedigree$PATIENT == iid] <- "blue"
    }
    if (sum((genome$IID1 == iid) & (genome$IID2 == iid)) > 0)  {
      sub.pedigree$col[sub.pedigree$PATIENT == iid] <- "purple"
      pi_hat <- genome$PI_HAT[(genome$IID1 == iid) & (genome$IID2 == iid)]
      if (pi_hat < 0.9) {
        sub.pedigree$mismatch[sub.pedigree$PATIENT == iid] <- 1
      }
    }
  }
  
  ped <- pedigree(sub.pedigree$PATIENT, sub.pedigree$FATHER, 
                  sub.pedigree$MOTHER, sub.pedigree$SEX)
  plot(ped, 
       id = sub.pedigree$id,
       status = sub.pedigree$mismatch,
       col = sub.pedigree$col,
       cex= 0.8, srt=90)

}

###############################################################################
getAnnotatedFrame <- function(frame) {
  frame$data_set1 <- 
    unlist(strsplit(frame$FID1, "_"))[seq(1, length(frame$FID1)*2, 2)]
  frame$data_set2 <- 
    unlist(strsplit(frame$FID2, "_"))[seq(1, length(frame$FID2)*2, 2)]
  frame$family1 <- 
    unlist(strsplit(frame$FID1, "_"))[seq(2, length(frame$FID1)*2, 2)]
  frame$family2 <- 
    unlist(strsplit(frame$FID2, "_"))[seq(2, length(frame$FID2)*2, 2)]
  frame$sample1 <- paste(frame$data_set1, frame$IID1, sep=":")
  frame$sample2 <- paste(frame$data_set2, frame$IID2, sep=":")
  frame$expected <- frame$RT
  frame$actual <- NA
  frame$actual[(frame$Z2 > 0.95)] <- "MZ"
  frame$actual[(frame$Z0 < 0.05) & (frame$Z1 > 0.95) & (frame$Z2 < 0.05)] <- "PO"
  frame$actual[(frame$Z0 < 0.4) & (frame$Z1 > 0.4) & (frame$Z2 > 0.15)] <- "FS"
  frame$actual[(frame$Z0 < 0.6) & (frame$Z1 < 0.6) & (frame$Z2 < 0.05)] <- "HS"
  frame$actual[is.na(frame$actual)] <- "OT"
  frame <- frame[,c(13:18,7:10)] 
  frame[,c(7:10)] <- round(frame[,c(7:10)],2)
  return (frame)
}

###############################################################################
getRelationship <- function(iid1, iid2) {
  out.frame <- genome[(genome$IID1 %in% c(iid1, iid2)) & 
                        (genome$IID2 %in% c(iid1, iid2)),1:10]
  out.frame$EZ[is.na(out.frame$EZ)] <- 0
  return (getAnnotatedFrame(out.frame)[,-c(1,2,5)])
}

###############################################################################
getUnexpectedFamilyRelationships <- function(fid) {
  out.frame <- genome[(genome$FID1 == fid) & (genome$FID2 == fid),1:10]
  out.frame <- getAnnotatedFrame(out.frame)
  out.frame <- out.frame[out.frame$expected != out.frame$actual,]
  return (out.frame[,-c(1,2)])
}

###############################################################################
getNonFamilyRelationships <- function(iid) {
  out.frame <- genome[(genome$IID1 == iid) | (genome$IID2 == iid),c(1:10)]
  out.frame <- getAnnotatedFrame(out.frame)
  out.frame <- out.frame[out.frame$family1 != out.frame$family2,]
  out.frame <- out.frame[out.frame$PI_HAT > 0.2,]
  return (out.frame)
}

###############################################################################
getNewSampleId <- function(fid) {
  fam <- pedigree[pedigree$FAMILY == fid,]
  return (max(fam$PATIENT) + 1)
}