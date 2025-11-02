#organellome analysis multi-organelle Units

# merges all files of bait-org interactions per cell
# calculates/counts booleans for types of bait-org interactions (n^k --> 48 booleans)
# summarizes all booleans in 1 Table 
#Col names should be in alphabetical order 
#ALL ORGANELLE NAMING SHOULD BE IN ALPHABETICAL ORDER 

current_wd <-"/Users/chahatbadhan/Desktop/DATA/Imaging/2024-02-21 Orgaplex/With N"
current_wd_slash <-"/Users/chahatbadhan/Desktop/DATA/Imaging/2024-02-21 Orgaplex/With N/"
setwd(current_wd)

#install+load packages
install.packages("xlsx")
library(xlsx)
install.packages("plyr")
library("plyr")
install.packages("expss")
library(expss)

######## ER

Orglist <-list.files(pattern = "_ER_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in Orglist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "ER_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("LD","Ly","M","N","N2","P")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B2=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B3=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B4=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B5=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B6=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  
  #2-way
  B7=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B8=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B9=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B10=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B11=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B12=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B13=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B14=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B15=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B16=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B17=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B18=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B19=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B20=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##3-way
  B21=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B22=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B23=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B24=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B25=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B26=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B27=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B28=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B29=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B30=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B31=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B32=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B33=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B34=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B35=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B36=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
 
   ##4-way
  B37=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B38=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B39=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B40=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B41=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B42=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B43=sum(MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B44=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B45=sum(MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##5-way
  B46=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B47=sum(MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ## no interaction
  B48=sum(MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)

  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32,B33,B34,B35,B36,B37,B38,B39,B40,B41,B42,B43,B44,B45,B46,B47,B48)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/chahatbadhan/Desktop/DATA/R codes_Chahat/6 way interaction/For Efferocytic Cells /with LD/boolean list bait-ER clusters 6 organelles.xlsx")
  
  CName=BList
  tCName=t(CName)
  CNameVector=as.character(tCName [2,]) #vector containing colnames
  colnames(ResultsCell) <-CNameVector
  ##
  result <- rbind (result,ResultsCell)
}
rownames(result) <- Orglist
setwd(current_wd)
write.xlsx(result,"cluster analysis_bait-ER.xlsx")


#######LD

Orglist <-list.files(pattern = "_LD_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in LDlist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "LD_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("ER","Ly","M","N","N2","P")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B2=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B3=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B4=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B5=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B6=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  
  #2-way
  B7=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B8=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B9=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B10=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B11=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B12=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B13=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B14=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B15=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B16=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B17=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B18=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B19=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B20=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##3-way
  B21=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B22=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B23=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B24=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B25=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B26=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B27=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B28=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B29=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B30=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B31=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B32=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B33=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B34=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B35=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B36=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##4-way
  B37=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B38=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B39=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B40=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B41=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B42=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B43=sum(MyTable$ER <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B44=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B45=sum(MyTable$ER > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##5-way
  B46=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B47=sum(MyTable$ER <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ## no interaction
  B48=sum(MyTable$ER > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32,B33,B34,B35,B36,B37,B38,B39,B40,B41,B42,B43,B44,B45,B46,B47,B48)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/chahatbadhan/Desktop/DATA/R codes_Chahat/6 way interaction/For Efferocytic Cells /with LD/boolean list bait-LD clusters 6 organelles.xlsx")
  CName=BList
  tCName=t(CName)
  CNameVector=as.character(tCName [2,]) #vector containing colnames
  colnames(ResultsCell) <-CNameVector
  ##
  result <- rbind (result,ResultsCell)
}
rownames(result) <- Orglist
setwd(current_wd)
write.xlsx(result,"cluster analysis_bait-LD.xlsx")



##########Ly

Orglist <-list.files(pattern = "_Ly_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in LDlist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "Ly_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("ER","LD","M","N","N2","P")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B2=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B3=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B4=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B5=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B6=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  
  #2-way
  B7=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B8=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B9=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B10=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B11=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B12=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B13=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B14=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B15=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B16=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B17=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B18=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B19=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B20=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##3-way
  B21=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B22=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B23=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B24=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B25=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B26=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B27=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B28=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B29=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B30=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B31=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B32=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B33=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B34=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B35=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B36=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##4-way
  B37=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B38=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B39=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B40=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B41=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B42=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B43=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B44=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B45=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##5-way
  B46=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B47=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ## no interaction
  B48=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  
  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32,B33,B34,B35,B36,B37,B38,B39,B40,B41,B42,B43,B44,B45,B46,B47,B48)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/chahatbadhan/Desktop/DATA/R codes_Chahat/6 way interaction/For Efferocytic Cells /with LD/boolean list bait-Ly clusters 6 organelles.xlsx")
  CName=BList
  tCName=t(CName)
  CNameVector=as.character(tCName [2,]) #vector containing colnames
  colnames(ResultsCell) <-CNameVector
  ##
  result <- rbind (result,ResultsCell)
}
rownames(result) <- Orglist
setwd(current_wd)
write.xlsx(result,"cluster analysis_bait-Ly.xlsx")


########## M

Orglist <-list.files(pattern = "_M_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in LDlist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "M_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("ER","LD","Ly","N","N2","P")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B2=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B3=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B4=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B5=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B6=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  
  #2-way
  B7=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B8=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B9=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B10=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B11=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B12=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B13=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B14=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B15=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B16=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B17=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B18=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B19=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B20=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##3-way
  B21=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B22=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B23=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B24=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B25=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B26=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B27=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B28=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B29=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B30=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B31=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B32=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B33=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B34=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B35=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B36=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##4-way
  B37=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B38=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B39=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B40=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B41=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B42=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B43=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B44=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B45=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##5-way
  B46=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B47=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$N > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ## no interaction
  B48=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$N > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  
  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32,B33,B34,B35,B36,B37,B38,B39,B40,B41,B42,B43,B44,B45,B46,B47,B48)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("//Users/chahatbadhan/Desktop/DATA/R codes_Chahat/6 way interaction/For Efferocytic Cells /with LD/boolean list bait-M clusters 6 organelles.xlsx")
  CName=BList
  tCName=t(CName)
  CNameVector=as.character(tCName [2,]) #vector containing colnames
  colnames(ResultsCell) <-CNameVector
  ##
  result <- rbind (result,ResultsCell)
}
rownames(result) <- Orglist
setwd(current_wd)
write.xlsx(result,"cluster analysis_bait-M.xlsx")

########## N 
Orglist <-list.files(pattern = "_N_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in LDlist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "N_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("ER","LD","Ly","M","N2","P")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B2=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B3=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B4=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B5=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B6=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  
  #2-way
  B7=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B8=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B9=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B10=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B11=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B12=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B13=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B14=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B15=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B16=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B17=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B18=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B19=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B20=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##3-way
  B21=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B22=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B23=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B24=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B25=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B26=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B27=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B28=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B29=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B30=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B31=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B32=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B33=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B34=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B35=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B36=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##4-way
  B37=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P > 0)
  B38=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P > 0)
  B39=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B40=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B41=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B42=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B43=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  B44=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B45=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ##5-way
  B46=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N2 > 0 & MyTable$P <= 0)
  B47=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N2 <= 0 & MyTable$P <= 0)
  
  ## no interaction
  B48=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N2 > 0 & MyTable$P > 0)
  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32,B33,B34,B35,B36,B37,B38,B39,B40,B41,B42,B43,B44,B45,B46,B47,B48)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/chahatbadhan/Desktop/DATA/R codes_Chahat/6 way interaction/For Efferocytic Cells /with LD/boolean list bait-N clusters 6 organelles.xlsx")
  CName=BList
  tCName=t(CName)
  CNameVector=as.character(tCName [2,]) #vector containing colnames
  colnames(ResultsCell) <-CNameVector
  ##
  result <- rbind (result,ResultsCell)
}
rownames(result) <- Orglist
setwd(current_wd)
write.xlsx(result,"cluster analysis_bait-N.xlsx")

###### N2

Orglist <-list.files(pattern = "_N2_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in LDlist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "N2_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("ER","LD","Ly","M","N","P")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P > 0)
  B2=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P > 0)
  B3=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P > 0)
  B4=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P > 0)
  B5=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P > 0)
  B6=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P <= 0)
  
  #2-way
  B7=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P > 0)
  B8=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P > 0)
  B9=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P > 0)
  B10=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P > 0)
  B11=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P <= 0)
  B12=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P > 0)
  B13=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P > 0)
  B14=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P > 0)
  B15=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P <= 0)
  B16=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P > 0)
  B17=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P > 0)
  B18=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P <= 0)
  B19=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P <= 0)
  B20=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P <= 0)
  
  ##3-way
  B21=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P > 0)
  B22=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P > 0)
  B23=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P > 0)
  B24=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P <= 0)
  B25=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P > 0)
  B26=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P > 0)
  B27=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P <= 0)
  B28=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P <= 0)
  B29=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P <= 0)
  B30=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P > 0)
  B31=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P > 0)
  B32=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P <= 0)
  B33=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P <= 0)
  B34=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P <= 0)
  B35=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P <= 0)
  B36=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P <= 0)
  
  ##4-way
  B37=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P > 0)
  B38=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P > 0)
  B39=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P <= 0)
  B40=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P <= 0)
  B41=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P <= 0)
  B42=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P <= 0)
  B43=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P <= 0)
  B44=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P <= 0)
  B45=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P <= 0)
  
  ##5-way
  B46=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$P <= 0)
  B47=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$P <= 0)
  
  ## no interaction
  B48=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$P > 0)
  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32,B33,B34,B35,B36,B37,B38,B39,B40,B41,B42,B43,B44,B45,B46,B47,B48)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/chahatbadhan/Desktop/DATA/R codes_Chahat/6 way interaction/For Efferocytic Cells /with LD/boolean list bait-N2 clusters 6 organelles.xlsx")
  CName=BList
  tCName=t(CName)
  CNameVector=as.character(tCName [2,]) #vector containing colnames
  colnames(ResultsCell) <-CNameVector
  ##
  result <- rbind (result,ResultsCell)
}
rownames(result) <- Orglist
setwd(current_wd)
write.xlsx(result,"cluster analysis_bait-N2.xlsx")



#######P

Orglist <-list.files(pattern = "_P_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in LDlist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "P_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("ER","LD","Ly","M","N","N2")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B2=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B3=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B4=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B5=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B6=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  
  #2-way
  B7=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B8=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B9=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B10=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B11=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  B12=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B13=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B14=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B15=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  B16=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B17=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B18=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  B19=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 <= 0)
  B20=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  
  ##3-way
  B21=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B22=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B23=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B24=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  B25=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B26=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B27=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  B28=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B29=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  B30=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B31=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B32=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  B33=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B34=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  B35=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B36=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  
  ##4-way
  B37=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 > 0)
  B38=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B39=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  B40=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B41=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly > 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  B42=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B43=sum(MyTable$ER <= 0 & MyTable$LD > 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  B44=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B45=sum(MyTable$ER > 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  
  ##5-way
  B46=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N <= 0 & MyTable$N2 > 0)
  B47=sum(MyTable$ER <= 0 & MyTable$LD <= 0 & MyTable$Ly <= 0 & MyTable$M <= 0 & MyTable$N > 0 & MyTable$N2 <= 0)
  
  ## no interaction
  B48=sum(MyTable$ER > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$N > 0 & MyTable$N2 > 0)
  
  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32,B33,B34,B35,B36,B37,B38,B39,B40,B41,B42,B43,B44,B45,B46,B47,B48)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/chahatbadhan/Desktop/DATA/R codes_Chahat/6 way interaction/For Efferocytic Cells /with LD/boolean list bait-P clusters 6 organelles.xlsx")
  tCName=t(CName)
  CNameVector=as.character(tCName [2,]) #vector containing colnames
  colnames(ResultsCell) <-CNameVector
  ##
  result <- rbind (result,ResultsCell)
}
rownames(result) <- Orglist
setwd(current_wd)
write.xlsx(result,"cluster analysis_bait-P.xlsx")

#Test

  