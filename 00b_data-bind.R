############## Bind raw data ####################-
# 231116 Alfonso Garmendia algarsal(at)upv(dot)es
##################################################
library(WriteXLS)

## Raw data --------------------------------------
# dir()
# source("00a_data-download.R")
# dir("data/raw", full.names = TRUE)
load("data/raw/raw-data.Rdata")

### Include year in *Group* and *PlantId* --------
data2022$Group <- paste0(data2022$Group, "_22")
if (length(data2023$Group) > 0)
  data2023$Group <- 
    paste0(data2023$Group, "_23")

data2022$PlantId <- 
  paste0(data2022$PlantId, "_22")
if (length(data2023$Group) > 0)
  data2023$PlantId <- 
    paste0(data2023$PlantId, "_23")

### Join data frames -----------------------------
dl <- ls(pattern = "data")
datab <- rbind(get(dl[1]), get(dl[2]))

### Join legends ---------------------------------
legendb <- legend2023

tf <- legend2022$Variable %in% legend2023$Variable
if (!all(tf)) {
  legendb <- rbind(legendb, legend2022[which(!tf), ])
}

### Group description in legend ------------------
tf <- which(legendb$Variable == "Group")
legendb$Description[tf] <- 
  paste0("Group name with year (two digits): ",
    paste(levels(as.factor(datab$Group)), 
      collapse = ", "),
    ".")

### PlantId description in legend ----------------
tf <- which(legendb$Variable == "PlantId")
legendb$Description[tf] <- 
  paste0("Code to identify each plant. Two letters for the species, one letter for treatment (c, control; i, intermediate; s, water stress), one digit for the number of plant and two more digits for the year: ",
    paste(levels(as.factor(datab$PlantId))[1:4], 
      collapse = ", "),
    ", etc.")

### Dates ----------------------------------------
### Include year in *Action* in dates
dates2022$Action <- 
  paste0(dates2022$Action, "_22")
dates2023$Action <- 
  paste0(dates2023$Action, "_23")

### Join dates 
datesb <- rbind(dates2022, dates2023)

## Export data -----------------------------------
### Save as rdata 
df.names <- c("datab", "datesb", "legendb")

save(list = df.names, 
  file = "data/bound-data.Rdata")

### Save as Excel
# WriteXLS(df.names, 
#   ExcelFileName = "data/xls/bound-data.xlsx",
#   AdjWidth = TRUE, BoldHeaderRow = TRUE,
#   FreezeRow = 1)

### Clean environment ----------------------------
#rm(list = ls())

