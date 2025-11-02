setwd("/Users/chahatbadhan/Desktop/DATA/Imaging/2025-05-22_Single Stains Neutrophils LPS 2h 4h")

#install+load packages
install.packages("xlsx")
library(xlsx)
install.packages("plyr")
library("plyr")
install.packages("expss")
library(expss)
library(tidyverse)
library(matrixStats)

setwd("/Users/chahatbadhan/Desktop/Malin thesis /statistics for analysis /Statistics_ER")
Cell_list <-list.files(pattern = "ER_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

library(xlsx)
df_toAdd <-read.xlsx("/Users/chahatbadhan/Desktop/DATA/R codes_Chahat/Radial distribution /tableToAdd_absolute dist_neutrophils.xlsx", sheetIndex = 1)
bins=df_toAdd$Dist

resultER <- NULL
#Loop for each cell

for (i in Cell_list) {
  setwd(paste("/Users/chahatbadhan/Desktop/Malin thesis /statistics for analysis /Statistics_ER/",i,sep=""))
  #Make sure you have a backslash after the directory name. Apparently it is very important
  
  # merges surface volume sheets of all organelles
  Volume <-list.files(pattern = "ER_Volume.csv", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
  VectorList1 <-lapply(Volume, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  alldfs1 <-rbind.fill(lapply(VectorList1,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
  VolumeTable=t(alldfs1)
  colnames(VolumeTable) <- c("ER_Volume")
  
  # merges surface distance to origin reference frame sheets
  Distance <-list.files(pattern = "_ER_Distance_from_Origin_Reference_Frame", full.names = FALSE, recursive = TRUE)
  VectorList2 <-lapply(Distance, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
  alldfs2 <-rbind.fill(lapply(VectorList2,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
  DistTable = t(as.matrix(alldfs2))
  colnames(DistTable) <- Distance 
  
  
  ###merges for each organelle normalized_distance and Volume sheet
  #bins the distances in 0,01 um intervals
  #sums up Volume of organelle in each bin. 
  #Volume is normalized to bin with max Volume
  
  #ER
  dfER <- data.frame(VolumeTable[,c(1)], DistTable[,c(1)])
  colnames(dfER) <- c("Vol","Dist")
  dfER_toBin <- rbind(dfER, df_toAdd)
  dfER_Binned <-dfER_toBin %>% mutate(Dist_bin = cut(Dist, breaks=c(bins)))
  ER_bin <-aggregate(Vol ~ Dist_bin, data=dfER_Binned, sum)
  colnames(ER_bin) <- c("Dist_bin","Vol_ER")
  
  resultER <- cbind (resultER,ER_bin$Vol_ER)
  
  
  #merges all _binned tables on bin intervals by left join and saves it as excel sheet in Cells's folder
  ListFinal <-list(ER_bin)
  FinalTable <-ListFinal %>% reduce(full_join, by='Dist_bin')
  write.xlsx(FinalTable,"ER_Org_Distribution_absVol_absDist_.xlsx")
  
}

setwd("/Users/chahatbadhan/Desktop/Malin thesis /statistics for analysis /Statistics_ER")
List_OrgDist <-list.files(pattern = "ER_Org_Distribution_absVol_absDist", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)

###for i in List get Column1 merge it with c1 of all other tables, get C2, merge with c2 of all other tables etc


colnames(resultER) <- List_OrgDist
write.xlsx(resultER,"Volume_Distribution_absVol_absDist_ER.xlsx")


#average rows for resultOrg and combine all averages
avg_ER <-rowMeans(resultER)

allavg<-grep("avg_",names(.GlobalEnv),value=TRUE)
allavglist<-do.call("list",mget(allavg))
results_avg <-as.data.frame(do.call(rbind, allavglist))

#SD per row
SD_ER <-rowSds(resultER)

allSD<-grep("SD_",names(.GlobalEnv),value=TRUE)
SDlist<-do.call("list",mget(allSD))
results_SD <-as.data.frame(do.call(rbind, SDlist))

avg_with_SD <-rbind(results_avg, results_SD)
write.xlsx(avg_with_SD,"Volume_Distribution_absVol_absDist_ER_average with SD.xlsx")

