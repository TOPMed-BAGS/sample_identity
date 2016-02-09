bim.parent <- read.table("../data/input/650_clean.bim")
bim.omni <- read.table("../data/input/omni_clean.bim")

snps.parent <- as.character(bim.parent$V2)
snps.omni <- as.character(bim.omni$V2)

snps.overlap <- intersect(snps.parent, sub("rs", "RS",snps.omni))

write.table(snps.overlap, "../data/working/overlap_snps_650_omni.txt",
            quote=F, row.names=F, col.names=F)
