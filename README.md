# sample_identity
Scripts used to check the sample identity of BAGS subjects that were whole genome sequenced.

## Server location

This project is located on Michelle's tower at /Volumes/Promise Pegasus/barbados_sample_identity.

A copy of the input files can also be found in the OneDrive <i>TOPMed_BAGS/analyses/sample_identity/input_files/</i> folder. SNP files should also downloaded from USCS (http://genome.ucsc.edu/cgi-bin/hgTables - fields chrom + chromEnd +	name) and named uscs.hg19.snp142.chr\<chr\>

## Steps

<code>bash run_pipeline.sh</code>

After running this script, the R report <i>doc/barbados_sample_identity.Rmd</i> should be generated. 
