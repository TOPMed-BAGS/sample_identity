import sys

in_file = open(sys.argv[1])
out_file = open(sys.argv[2], "w")
prev_chr = 0
update_count = 0

for line in in_file:
    e = line.strip().split()
    chr = e[0]

    #If we are processing a new chromosome, read the SNP position map from the dbSNP files
    if chr != prev_chr:
        print("Processing chr " + chr)
        prev_chr = chr
        snp_map = {}
        db_snp_file = open("../input/uscs.hg19.snp142.chr" + chr)
        for snp_line in db_snp_file:
            snp_e = snp_line.strip().split()
            key = snp_e[0] + ":" + snp_e[1]
            val = snp_e[2]
            snp_map[key] = val
        db_snp_file.close()

    #Check if this is an rs ID or not; write as is to new output if it is an rs ID, else look it up
    snp_id = e[1]
    if snp_id[0:2] == 'rs':
        out_file.write(line)
    else:
        key = "chr" + e[0] + ":" + e[3]
        if key in snp_map:
            update_count = update_count + 1
            snp_name = snp_map[key]
            out_file.write(e[0] + "\t" + snp_name + "\t" + e[2] + "\t" + e[3] + "\t" + e[4] + "\t" + e[5] + "\n")
        else:
            out_file.write(line)

in_file.close()
out_file.close()

print("Nr SNPs updated from dbSNP: " + str(update_count))
