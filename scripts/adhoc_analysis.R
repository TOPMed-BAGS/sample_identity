source("utilities.R")

drawFamily(15004)
getUnexpectedFamilyRelationships("650_15004")
getUnexpectedFamilyRelationships("omni_15004")
getRelationship("15004016", "15004026")
getRelationship("15004010", "15004026")
getRelationship("15004007", "15004026")
getNonFamilyRelationships("15004026")


getNonFamilyRelationships("15004010")


drawFamily(15111)
drawFamily(15022)

getNonFamilyRelationships("15040070")
getUnexpectedFamilyRelationships("omni_15040")
genome[((genome$IID1 == 15040070) | (genome$IID2 == 15040070)) & (genome$PI_HAT > 0.2),1:10  ]

drawFamily(15050)
getUnexpectedFamilyRelationships("650_15050")

drawFamily(15161)
genome[((genome$IID1 == 15161013) | (genome$IID2 == 15161013)) & (genome$PI_HAT > 0.2),1:10  ]
drawFamily(15162)

getUnexpectedFamilyRelationships("omni_15191")

getNonFamilyRelationships("15210003")

drawFamily(15539)

getRelationship("15558011", "15558002")


getRelationship("15009001", "15009013")


#Remaining issues
fixed <- read.table("../data/output/fixed.genome", head=T, stringsAsFactors = T)
fixed.650 <- read.table("../data/working/fixed_650.genome", head=T, stringsAsFactors = T)
fixed.omni <- read.table("../data/working/fixed_omni.genome", head=T, stringsAsFactors = T)
#Unknown parent-offspring
fixed.650[(fixed.650$Z1 > 0.9) & (fixed.650$RT != "PO"),1:10]
fixed.omni[(fixed.omni$Z1 > 0.9) & (fixed.omni$RT != "PO"),1:10]
#Half-siblings that should be full siblings
fixed.650[(fixed.650$PI_HAT > 0.4) & (fixed.650$RT == "HS"),1:10]
fixed.omni[(fixed.omni$PI_HAT > 0.4) & (fixed.omni$RT == "HS"),1:10]


