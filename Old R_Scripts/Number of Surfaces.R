library(readr)
library(openxlsx)
library(tools)

# Set working directory to "Chahat"
setwd("/Users/chahatbadhan/Desktop/DATA/Imaging/2024-02-21 Orgaplex/For LD count and Volume ")

# List all CSV files in "Chahat" with "_Overall" in their names
csv_files <- list.files(pattern = "_LD_Overall.csv", full.names = TRUE, recursive = TRUE, include.dirs = TRUE)


# Initialize data frame to store total surfaces information
total_surfaces_df <- data.frame(Filename = character(), Total_Surfaces = numeric())

# Iterate over each CSV file
for (file in csv_files) {
  # Read the CSV file with row name and column name 
  csv_data <- read.csv(file, skip=3, row.names = "Variable")
  total_surface_value <- csv_data["Total Number of Surfaces", "Value"]
  
  # Get the filename without extension
  filename <- tools::file_path_sans_ext(basename(file))
  
  # Add filename and total surfaces to data frame
  total_surfaces_df <- rbind(total_surfaces_df, data.frame(Filename = filename, Total_Surfaces = total_surface_value))
}

# Write data frame to Excel file in the working directory
write.xlsx(total_surfaces_df, "total_surfaces.xlsx",)

# Print a message indicating the file has been saved
cat("Total surfaces information has been saved in 'total_surfaces.xlsx' in the working directory.\n")

