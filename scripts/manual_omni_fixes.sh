#!/bin/bash

#Omni discordant sample that could not be resolved (15225001)
echo -e LP6008064-DNA_H10'\t650_omni_no_solution' >> ../data/output/omni_delete.txt

#pedigree errors that cannot be resolved - delete
echo -e LP6008086-DNA_F10'\t'pedigree >> ../data/output/omni_delete.txt	#15004017
echo -e LP6008084-DNA_H08'\t'pedigree >> ../data/output/omni_delete.txt	#15004503
echo -e LP6008057-DNA_F06'\t'pedigree >> ../data/output/omni_delete.txt	#15018019
echo -e LP6008083-DNA_E03'\t'pedigree >> ../data/output/omni_delete.txt	#15037070
echo -e LP6008083-DNA_E04'\t'pedigree >> ../data/output/omni_delete.txt	#15040070
echo -e LP6008083-DNA_E05'\t'pedigree >> ../data/output/omni_delete.txt	#15040071
echo -e LP6008059-DNA_G04'\t'pedigree >> ../data/output/omni_delete.txt	#15046005
echo -e LP6008063-DNA_D09'\t'pedigree >> ../data/output/omni_delete.txt	#15161002
echo -e LP6008063-DNA_B11'\t'pedigree >> ../data/output/omni_delete.txt	#15189002
echo -e LP6008063-DNA_D11'\t'pedigree >> ../data/output/omni_delete.txt	#15191005
echo -e LP6008064-DNA_F02'\t'pedigree >> ../data/output/omni_delete.txt	#15198004
echo -e LP6008064-DNA_B03'\t'pedigree >> ../data/output/omni_delete.txt	#15207002
echo -e LP6008064-DNA_C03'\t'pedigree >> ../data/output/omni_delete.txt	#15210003
echo -e LP6008064-DNA_H03'\t'pedigree >> ../data/output/omni_delete.txt	#15264003
echo -e LP6008087-DNA_C06'\t'pedigree >> ../data/output/omni_delete.txt	#15357003
echo -e LP6008065-DNA_G03'\t'pedigree >> ../data/output/omni_delete.txt	#15378003
echo -e LP6008065-DNA_F05'\t'pedigree >> ../data/output/omni_delete.txt	#15378007
echo -e LP6008083-DNA_G03'\t'pedigree >> ../data/output/omni_delete.txt	#15546002
echo -e LP6008086-DNA_H06'\t'pedigree >> ../data/output/omni_delete.txt	#15556001 - sex discrepancy


#pedigree errors that can be resolved - swap
echo -e 15111004'\t'15022050'\t'pedigree >> ../data/output/omni_swaps.txt
echo -e 15161013'\t'15162001'\t'pedigree >> ../data/output/omni_swaps.txt
echo -e 15537019'\t'15537020'\t'pedigree >> ../data/output/omni_swaps.txt
echo -e 15537020'\t'15537021'\t'pedigree >> ../data/output/omni_swaps.txt
echo -e 15539005'\t'15539004'\t'pedigree >> ../data/output/omni_swaps.txt
echo -e 15539004'\t'15539005'\t'pedigree >> ../data/output/omni_swaps.txt
