install.packages("xlsx")
library(xlsx)
install.packages("plyr")
library("plyr")
install.packages("expss")
library(expss)


# Set working directory to "Chahat"
setwd("/Users/chahatbadhan/Desktop/DATA/Imaging/2024-02-21 Orgaplex/For LD count and Volume ")

# List all CSV files with patter _LD_Volume.csv (put .csv for more specificity)
csv_files <-list.files(pattern = "_LD_Volume.csv", full.names = TRUE, recursive = TRUE)

# Initialize data frame to store total surfaces information
total_volume_df <- data.frame(Filename = character(), Total_Surfaces = numeric())

# Iterate over each CSV file
for (file in csv_files) {
  # Read the CSV file with row name and column name 
  csv_data <- read.csv(file, skip=3)
  
  # Calculate the sum of all numbers in the "Volume" column
  volume_sum <- sum(csv_data[,1], na.rm = TRUE)
  
  # Get the filename without extension
  filename <- tools::file_path_sans_ext(basename(file))
  
  # Add filename and total volume to data frame
  total_volume_df <- rbind(total_volume_df, data.frame(Filename = filename, Total_Volume = volume_sum))
}

# Write data frame to Excel file in the working directory
write.xlsx(total_volume_df, "total_Volume.xlsx", row.names = FALSE)

# Print a message indicating the file has been saved
cat("Total surfaces information has been saved in 'total_Volume.xlsx' in the working directory.\n")
