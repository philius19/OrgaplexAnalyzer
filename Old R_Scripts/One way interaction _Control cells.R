#organellome analysis 4-Plex - for Control (with and without LD).

# merges all files of 1-way org interaction
# calculates avg/sample and distance =0/sample for all 1-way interactions
# label all surfaces LD, M, ER, P before exporting data from imaris

# LD-org and org-LD interactions must be computed seperately if samples are included that do not all contain LDs e.g. M0 or DGATi

setwd("/Users/chahatbadhan/Desktop/DATA/Imaging/2024-02-21 Orgaplex/Control ")

#install+load packages
install.packages("xlsx")
library(xlsx)
install.packages("plyr")
library("plyr")
install.packages("expss")
library(expss)

#####analysis for org-org interactions that do NOT contain LDs or N or N2 
# ER to M
Myfiles <-list.files(pattern = "ER_Shortest_Distance_to_Surfaces_Surfaces=M", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_ER_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"E-to-M.xlsx")
avg_E_to_M=colMeans(asColumns, na.rm = TRUE)
cIF_E_to_M <-count_col_if(le(0), asColumns)

# ER to P
Myfiles <-list.files(pattern = "ER_Shortest_Distance_to_Surfaces_Surfaces=P", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_ER_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"E-to-P.xlsx")
avg_E_to_P=colMeans(asColumns, na.rm = TRUE)
cIF_E_to_P <-count_col_if(le(0), asColumns)

# ER to Ly
Myfiles <-list.files(pattern = "ER_Shortest_Distance_to_Surfaces_Surfaces=Ly", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_ER_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"E-to-Ly.xlsx")
avg_E_to_Ly=colMeans(asColumns, na.rm = TRUE)
cIF_E_to_Ly <-count_col_if(le(0), asColumns)

# M to E
Myfiles <-list.files(pattern = "M_Shortest_Distance_to_Surfaces_Surfaces=E", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_M_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"M-to-E.xlsx")
avg_M_to_E=colMeans(asColumns, na.rm = TRUE)
cIF_M_to_E <-count_col_if(le(0), asColumns)

# M to P
Myfiles <-list.files(pattern = "M_Shortest_Distance_to_Surfaces_Surfaces=P", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_M_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"M-to-P.xlsx")
avg_M_to_P=colMeans(asColumns, na.rm = TRUE)
cIF_M_to_P <-count_col_if(le(0), asColumns)

# M to Ly
Myfiles <-list.files(pattern = "M_Shortest_Distance_to_Surfaces_Surfaces=Ly", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_M_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"M-to-Ly.xlsx")
avg_M_to_Ly=colMeans(asColumns, na.rm = TRUE)
cIF_M_to_Ly <-count_col_if(le(0), asColumns)


# P to E
Myfiles <-list.files(pattern = "P_Shortest_Distance_to_Surfaces_Surfaces=E", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_P_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"P-to-E.xlsx")
avg_P_to_E=colMeans(asColumns, na.rm = TRUE)
cIF_P_to_E <-count_col_if(le(0), asColumns)

# P to M
Myfiles <-list.files(pattern = "P_Shortest_Distance_to_Surfaces_Surfaces=M", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_P_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"P-to-M.xlsx")
avg_P_to_M=colMeans(asColumns, na.rm = TRUE)
cIF_P_to_M <-count_col_if(le(0), asColumns)

# P to Ly
Myfiles <-list.files(pattern = "P_Shortest_Distance_to_Surfaces_Surfaces=Ly", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_P_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"P-to-Ly.xlsx")
avg_P_to_Ly=colMeans(asColumns, na.rm = TRUE)
cIF_P_to_Ly <-count_col_if(le(0), asColumns)

# Ly to E
Myfiles <-list.files(pattern = "Ly_Shortest_Distance_to_Surfaces_Surfaces=E", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_Ly_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"Ly-to-E.xlsx")
avg_Ly_to_E=colMeans(asColumns, na.rm = TRUE)
cIF_Ly_to_E <-count_col_if(le(0), asColumns)

# Ly to M
Myfiles <-list.files(pattern = "Ly_Shortest_Distance_to_Surfaces_Surfaces=M", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_Ly_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"Ly-to-M.xlsx")
avg_Ly_to_M=colMeans(asColumns, na.rm = TRUE)
cIF_Ly_to_M <-count_col_if(le(0), asColumns)

# Ly to P
Myfiles <-list.files(pattern = "Ly_Shortest_Distance_to_Surfaces_Surfaces=P", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_Ly_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"Ly-to-P.xlsx")
avg_Ly_to_P=colMeans(asColumns, na.rm = TRUE)
cIF_Ly_to_P <-count_col_if(le(0), asColumns)



##############
#analysis for LD-org interactions
#for LD-org interactions a different list of column names is called and also the results are saved seperately later
# in this case make a custom list of column names, that can be called for these operations. Cells without LD data are skipped so delete them in colName List


# ER to LD
Myfiles <-list.files(pattern = "ER_Shortest_Distance_to_Surfaces_Surfaces=LD", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_LD_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"E-to-LD.xlsx")
LDavgE_to_LD=colMeans(asColumns, na.rm = TRUE)
LDcIFE_to_LD <-count_col_if(le(0), asColumns)

# M to LD
Myfiles <-list.files(pattern = "M_Shortest_Distance_to_Surfaces_Surfaces=LD", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_LD_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"M-to-LD.xlsx")
LDavgM_to_LD=colMeans(asColumns, na.rm = TRUE)
LDcIFM_to_LD <-count_col_if(le(0), asColumns)

# P to LD
Myfiles <-list.files(pattern = "P_Shortest_Distance_to_Surfaces_Surfaces=LD", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_LD_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"P-to-LD.xlsx")
LDavgP_to_LD=colMeans(asColumns, na.rm = TRUE)
LDcIFP_to_LD <-count_col_if(le(0), asColumns)

# Ly to LD
Myfiles <-list.files(pattern = "Ly_Shortest_Distance_to_Surfaces_Surfaces=LD", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_LD_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"Ly-to-LD.xlsx")
LDavgLy_to_LD=colMeans(asColumns, na.rm = TRUE)
LDcIFLy_to_LD <-count_col_if(le(0), asColumns)


# LD to E
Myfiles <-list.files(pattern = "LD_Shortest_Distance_to_Surfaces_Surfaces=ER", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_LD_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"LD-to-E.xlsx")
LDavgLD_to_E=colMeans(asColumns, na.rm = TRUE)
LDcIFLD_to_E <-count_col_if(le(0), asColumns)


# LD to M
Myfiles <-list.files(pattern = "LD_Shortest_Distance_to_Surfaces_Surfaces=M", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_LD_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"LD-to-M.xlsx")
LDavgLD_to_M=colMeans(asColumns, na.rm = TRUE)
LDcIFLD_to_M <-count_col_if(le(0), asColumns)

# LD to P
Myfiles <-list.files(pattern = "LD_Shortest_Distance_to_Surfaces_Surfaces=P", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_LD_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"LD-to-P.xlsx")
LDavgLD_to_P=colMeans(asColumns, na.rm = TRUE)
LDcIFLD_to_P <-count_col_if(le(0), asColumns)


# LD to Ly
Myfiles <-list.files(pattern = "LD_Shortest_Distance_to_Surfaces_Surfaces=Ly", full.names = FALSE, recursive = TRUE)
C1Table <-lapply(Myfiles, function(x) {read.table(file = x, header = FALSE, sep =",", skip = 4)[,c(1)]})
alldfs <-rbind.fill(lapply(C1Table,function(y){as.data.frame(t(y),stringsAsFactors=FALSE)}))
asColumns=t(alldfs)
colnames(asColumns) <- list.files(pattern = "_LD_Statistics", full.names = FALSE, recursive = TRUE, include.dirs = TRUE)
write.xlsx(asColumns,"LD-to-Ly.xlsx")
LDavgLD_to_Ly=colMeans(asColumns, na.rm = TRUE)
LDcIFLD_to_Ly <-count_col_if(le(0), asColumns)


#combining all avg and cIF 

# distinguish again between LD and no LD

#noLD interactions:
#combine all avg
allavg<-grep("avg_",names(.GlobalEnv),value=TRUE)
allavg_list<-do.call("list",mget(allavg))
results_avg <-as.data.frame(do.call(rbind, allavg_list))
write.xlsx(results_avg,"Average_Distance_NoLD.xlsx")

#combine all countIFs
allcIF<-grep("cIF_",names(.GlobalEnv),value=TRUE)
allcIF_list<-do.call("list",mget(allcIF))
results_cIF <-as.data.frame(do.call(rbind, allcIF_list))
write.xlsx(results_cIF,"Count_NoLD.xlsx")

#LD-org interactions
#combine all avg
allavg<-grep("LDavg",names(.GlobalEnv),value=TRUE)
allavg_list<-do.call("list",mget(allavg))
results_avg <-as.data.frame(do.call(rbind, allavg_list))
write.xlsx(results_avg,"Average_Distance_WithLD.xlsx")
#
#combine all countIFs
allcIF<-grep("LDcIF",names(.GlobalEnv),value=TRUE)
allcIF_list<-do.call("list",mget(allcIF))
results_cIF <-as.data.frame(do.call(rbind, allcIF_list))
write.xlsx(results_cIF,"Count_WithLD.xlsx")

