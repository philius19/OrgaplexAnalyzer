#organellome analysis multi-organelle Units

# merges all files of bait-org interactions per cell
# calculates/counts booleans for types of bait-org interactions (n^k --> 32 booleans)
# summarizes all booleans in 1 Table 

current_wd <-"/Users/zimmermann/Documents/Experiments JZ/4 Imaging/IF/Organellome Experiments/JZ450 org M1 TC/perinuclear/M0/with LD"
current_wd_slash <-"/Users/zimmermann/Documents/Experiments JZ/4 Imaging/IF/Organellome Experiments/JZ450 org M1 TC/perinuclear/M0/with LD/"
setwd(current_wd)

#install+load packages
install.packages("xlsx")
library(xlsx)
install.packages("plyr")
library("plyr")
install.packages("expss")
library(expss)

########ER

Orglist <-list.files(pattern = "_ER_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in Orglist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "ER_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("G","LD","Ly","M","P")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$G<=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  B2=sum(MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B3=sum(MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  B4=sum(MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B5=sum(MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  #2-way
  B6=sum(MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B7=sum(MyTable$G<=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  B8=sum(MyTable$G<=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B9=sum(MyTable$G<=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  B10=sum(MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B11=sum(MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B12=sum(MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B13=sum(MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B14=sum(MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  B15=sum(MyTable$G >0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  ##3-way
  B16=sum(MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  B17=sum(MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  B18=sum(MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  B19=sum(MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B20=sum(MyTable$G<=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B21=sum(MyTable$G<=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B22=sum(MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B23=sum(MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B24=sum(MyTable$G<=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B25=sum(MyTable$G<=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  ##4-way
  B26=sum(MyTable$G<=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  B27=sum(MyTable$G<=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B28=sum(MyTable$G<=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B29=sum(MyTable$G<=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  B30=sum(MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  ##5-way
  B31=sum(MyTable$G<=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  ## no interaction
  B32=sum(MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/zimmermann/Desktop/R scripts orgaplex/6Plex/all multi org clusters/with LD/boolean list bait-ER clusters 6 organelles.xlsx")
  
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


#########Golgi

Orglist <-list.files(pattern = "_G_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in LDlist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "G_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("E","LD","Ly","M","P")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$E<=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  B2=sum(MyTable$E > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B3=sum(MyTable$E > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  B4=sum(MyTable$E > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B5=sum(MyTable$E > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  #2-way
  B6=sum(MyTable$E <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B7=sum(MyTable$E<=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  B8=sum(MyTable$E<=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B9=sum(MyTable$E<=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  B10=sum(MyTable$E > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B11=sum(MyTable$E > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B12=sum(MyTable$E > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B13=sum(MyTable$E > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B14=sum(MyTable$E > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  B15=sum(MyTable$E >0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  ##3-way
  B16=sum(MyTable$E <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  B17=sum(MyTable$E > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  B18=sum(MyTable$E > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  B19=sum(MyTable$E <=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B20=sum(MyTable$E<=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B21=sum(MyTable$E<=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B22=sum(MyTable$E > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B23=sum(MyTable$E > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B24=sum(MyTable$E<=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B25=sum(MyTable$E<=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  ##4-way
  B26=sum(MyTable$E<=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  B27=sum(MyTable$E<=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B28=sum(MyTable$E<=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B29=sum(MyTable$E<=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  B30=sum(MyTable$E > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  ##5-way
  B31=sum(MyTable$E<=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  ## no interaction
  B32=sum(MyTable$E > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/zimmermann/Desktop/R scripts orgaplex/6Plex/all multi org clusters/with LD/boolean list bait-G clusters 6 organelles.xlsx")
  CName=BList
  tCName=t(CName)
  CNameVector=as.character(tCName [2,]) #vector containing colnames
  colnames(ResultsCell) <-CNameVector
  ##
  result <- rbind (result,ResultsCell)
}
rownames(result) <- Orglist
setwd(current_wd)
write.xlsx(result,"cluster analysis_bait-G.xlsx")


#######LD

Orglist <-list.files(pattern = "_LD_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in LDlist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "LD_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("E","G","Ly","M","P")
  LDnumber <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  B2=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B3=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  B4=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B5=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  #2-way
  B6=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B7=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  B8=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B9=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  B10=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B11=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B12=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B13=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B14=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  B15=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  ##3-way
  B16=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  B17=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  B18=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  B19=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B20=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B21=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P > 0)
  B22=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B23=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B24=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P > 0)
  B25=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P <=0)
  ##4-way
  B26=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  B27=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$Ly <=0 & MyTable$M > 0 & MyTable$P <=0)
  B28=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P > 0)
  B29=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$Ly > 0 & MyTable$M <=0 & MyTable$P <=0)
  B30=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  ##5-way
  B31=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$Ly <=0 & MyTable$M <=0 & MyTable$P <=0)
  ## no interaction
  B32=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$Ly > 0 & MyTable$M > 0 & MyTable$P > 0)
  ##
  BooleanList=list(LDnumber,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/zimmermann/Desktop/R scripts orgaplex/6Plex/all multi org clusters/with LD/boolean list bait-LD clusters 6 organelles.xlsx")
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
  colnames(MyTable) <- c("E","G","LD","M","P")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$P > 0)
  B2=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$M <=0 & MyTable$P > 0)
  B3=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$P <=0)
  B4=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$M > 0 & MyTable$P > 0)
  B5=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$P > 0)
  #2-way
  B6=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$M <=0 & MyTable$P > 0)
  B7=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$P <=0)
  B8=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$M > 0 & MyTable$P > 0)
  B9=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$P > 0)
  B10=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$M <=0 & MyTable$P > 0)
  B11=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$M > 0 & MyTable$P <=0)
  B12=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$M > 0 & MyTable$P > 0)
  B13=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$M <=0 & MyTable$P > 0)
  B14=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$P <=0)
  B15=sum(MyTable$E >0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$M <=0 & MyTable$P <=0)
  ##3-way
  B16=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$M <=0 & MyTable$P <=0)
  B17=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$M <=0 & MyTable$P <=0)
  B18=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$M <=0 & MyTable$P <=0)
  B19=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$M <=0 & MyTable$P > 0)
  B20=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$M > 0 & MyTable$P <=0)
  B21=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$M > 0 & MyTable$P > 0)
  B22=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$M <=0 & MyTable$P > 0)
  B23=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$M > 0 & MyTable$P <=0)
  B24=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$M <=0 & MyTable$P > 0)
  B25=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$P <=0)
  ##4-way
  B26=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$M <=0 & MyTable$P <=0)
  B27=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$M > 0 & MyTable$P <=0)
  B28=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$M <=0 & MyTable$P > 0)
  B29=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$M <=0 & MyTable$P <=0)
  B30=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$M <=0 & MyTable$P <=0)
  ##5-way
  B31=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$M <=0 & MyTable$P <=0)
  ## no interaction
  B32=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$M > 0 & MyTable$P > 0)
  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/zimmermann/Desktop/R scripts orgaplex/6Plex/all multi org clusters/with LD/boolean list bait-Ly clusters 6 organelles.xlsx")
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


##########M

Orglist <-list.files(pattern = "_M_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in LDlist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "M_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("E","G","LD","Ly","P")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$P > 0)
  B2=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$P > 0)
  B3=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$P <=0)
  B4=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$P > 0)
  B5=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$P > 0)
  #2-way
  B6=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$P > 0)
  B7=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$P <=0)
  B8=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$P > 0)
  B9=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$P > 0)
  B10=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$P > 0)
  B11=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$P <=0)
  B12=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$P > 0)
  B13=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$P > 0)
  B14=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$P <=0)
  B15=sum(MyTable$E >0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$P <=0)
  ##3-way
  B16=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$P <=0)
  B17=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$P <=0)
  B18=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$P <=0)
  B19=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$P > 0)
  B20=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$P <=0)
  B21=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$P > 0)
  B22=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$P > 0)
  B23=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$P <=0)
  B24=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$P > 0)
  B25=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$P <=0)
  ##4-way
  B26=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$P <=0)
  B27=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$P <=0)
  B28=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$P > 0)
  B29=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$P <=0)
  B30=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$P <=0)
  ##5-way
  B31=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$P <=0)
  ## no interaction
  B32=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$P > 0)
  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/zimmermann/Desktop/R scripts orgaplex/6Plex/all multi org clusters/with LD/boolean list bait-M clusters 6 organelles.xlsx")
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



#######P

Orglist <-list.files(pattern = "_P_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

#Loop for each directory in LDlist

result <- NULL

for (i in Orglist) {
  setwd(paste(current_wd_slash,i,sep=""))
  Myfiles <-list.files(pattern = "P_Shortest_Distance_to_Surfaces_Surfaces", full.names = FALSE, recursive = TRUE)
  VectorList <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  MyTable <-cbind.data.frame(VectorList)
  colnames(MyTable) <- c("E","G","LD","Ly","M")
  Surface_number <- nrow(MyTable)
  #1-way
  B1=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0)
  B2=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0)
  B3=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0)
  B4=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0)
  B5=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0)
  #2-way
  B6=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0)
  B7=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0)
  B8=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0)
  B9=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0)
  B10=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0)
  B11=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0)
  B12=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0)
  B13=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0)
  B14=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0)
  B15=sum(MyTable$E >0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0)
  ##3-way
  B16=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0)
  B17=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0)
  B18=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0)
  B19=sum(MyTable$E <=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0)
  B20=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0)
  B21=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M > 0)
  B22=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0)
  B23=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0)
  B24=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M > 0)
  B25=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M <=0)
  ##4-way
  B26=sum(MyTable$E<=0 & MyTable$G > 0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0)
  B27=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly > 0 & MyTable$M <=0)
  B28=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M > 0)
  B29=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD > 0 & MyTable$Ly <=0 & MyTable$M <=0)
  B30=sum(MyTable$E > 0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0)
  ##5-way
  B31=sum(MyTable$E<=0 & MyTable$G <=0 & MyTable$LD <=0 & MyTable$Ly <=0 & MyTable$M <=0)
  ## no interaction
  B32=sum(MyTable$E > 0 & MyTable$G > 0 & MyTable$LD > 0 & MyTable$Ly > 0 & MyTable$M > 0)
  ##
  BooleanList=list(Surface_number,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31,B32)
  ResultsCell <-cbind.data.frame(BooleanList)
  ##
  library(readxl)
  BList <- read_excel("/Users/zimmermann/Desktop/R scripts orgaplex/6Plex/all multi org clusters/with LD/boolean list bait-P clusters 6 organelles.xlsx")
  tCName=t(CName)
  CNameVector=as.character(tCName [2,]) #vector containing colnames
  colnames(ResultsCell) <-CNameVector
  ##
  result <- rbind (result,ResultsCell)
}
rownames(result) <- Orglist
setwd(current_wd)
write.xlsx(result,"cluster analysis_bait-P.xlsx")
