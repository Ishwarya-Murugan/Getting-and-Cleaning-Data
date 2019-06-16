getwd()
setwd("C://Users/Ishwa/Downloads")
housing <- read.csv("getdata_data_ss06hid.csv")
summary(housing)
head(housing$VAL)
na.omit(housing[housing$VAL==24,"VAL"])
install.packages("readxl")
dat <- read.xlsx("getdata_data_DATA.gov_NGAP.xlsx", rows=c(18:23), cols=c(7:15))
library("readxl")


dat <- read.xlsx("getdata_data_DATA.gov_NGAP.xlsx", sheetName='NGAP Sample Data', , rowIndex=(18:23), colIndex=(7:15))
dat
sum(dat$Zip*dat$Ext,na.rm=T)

install.packages("XML")
library(XML)
library(data.table)

library("methods")

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

doc <- xmlTreeParse(sub("s","",url))
doc
xmltop <- xmlRoot(doc)
xmltop
xpathApply(xmltop, "//zipcode")


nodes = getNodeSet(xmltop, "//zipcode"="21231")

xpathSApply(xmltop,"/response//row[zipcode=21231]",xmlValue)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"



doc <- xmlTreeParse(sub("s","",fileUrl), useInternal=TRUE)
rootNode<- xmlRoot(doc)
xpathSApply(rootNode,"/response//row[zipcode=21231]",xmlValue)
