# ============================================================================
# AUTOMATED ORGANELLE INTERACTION ANALYSIS
# ============================================================================
#
# PURPOSE:
# This script processes Imaris-generated organelle segmentation data to analyze
# interactions between different organelles within cells. It automatically:
# - Detects whether the dataset contains Lipid Droplets (LD)
# - Groups data by individual cells
# - Calculates mean distances and counts for all organelle interactions
# - Exports results as Excel files (one per cell)
#
# AUTHOR: Philipp Kaintoch 
# DATE: 2025-10-09
# Version: beta 0.5
# ============================================================================

# Load required library for Excel export
library(openxlsx)

# ============================================================================
# STEP 0: USER INPUT - SET YOUR PARENT DIRECTORY HERE
# ============================================================================
#
# IMPORTANT: This is the ONLY line you need to change!
#
# Examples:
# - For datasets WITH LD (direct structure):
#   "/Users/philippkaintoch/Documents/Projects/07_R-Scripts_Chahat/Raw_data_for_Orgaplex_Test/Cells_without_N_but_with_LD"
#
# - For datasets WITHOUT LD (nested structure with Control folder):
#   "/Users/philippkaintoch/Documents/Projects/07_R-Scripts_Chahat/Raw_data_for_Orgaplex_Test/Cells_without_N_and_without_LD"
#
parent_dir <- "/Users/philippkaintoch/Documents/Projects/07_R-Scripts_Chahat/Raw_data_for_Orgaplex_Test/Cells_without_N_but_with_LD"

# ============================================================================
# STEP 1: DETECT FOLDER STRUCTURE (LD vs. Non-LD Dataset)
# ============================================================================
#
# The script automatically detects two possible data structures:
#
# STRUCTURE 1 (with LD): Folders are DIRECTLY in parent_dir
#   parent_dir/
#     ├── control_1_ER_Statistics/
#     ├── control_1_LD_Statistics/
#     ├── control_1_Ly_Statistics/
#     └── ...
#
# STRUCTURE 2 (without LD): Folders are in SUBDIRECTORIES
#   parent_dir/
#     ├── Control/
#     │   ├── control_1_ER_Statistics/
#     │   ├── control_1_Ly_Statistics/
#     │   └── ...
#     └── ...
#
cat("\n")
cat("================================================================================\n")
cat("          ORGANELLE INTERACTION ANALYSIS - STARTING ANALYSIS\n")
cat("================================================================================\n\n")

cat("STEP 1: Analyzing folder structure...\n")
cat("------------------------------------------------------------------------\n")

# Get all items in the parent directory
all_items <- list.files(parent_dir, full.names = TRUE)

# Filter to keep only directories (not files)
all_dirs <- all_items[file.info(all_items)$isdir]

# Check if any directory name ends with "_Statistics"
# This pattern indicates that cell folders are directly in parent_dir
has_statistics_dirs <- any(grepl("_Statistics$", basename(all_dirs)))

# Determine the structure based on the presence of "_Statistics" folders
if (has_statistics_dirs) {
  # STRUCTURE 1: Direct structure (WITH LD)
  cat("✓ Structure detected: Cell folders are DIRECTLY in parent directory\n")
  cat("✓ LD Status: Dataset CONTAINS Lipid Droplets (LD)\n")
  search_dir <- parent_dir
  has_LD <- TRUE

} else {
  # STRUCTURE 2: Nested structure (WITHOUT LD)
  cat("✓ Structure detected: Cell folders are in SUBDIRECTORIES\n")
  cat("✓ LD Status: Dataset does NOT contain Lipid Droplets (LD)\n")

  # Search for subdirectories that contain "_Statistics" folders
  search_dirs <- c()
  for (subdir in all_dirs) {
    subdir_contents <- list.files(subdir, full.names = TRUE)
    subdir_dirs <- subdir_contents[file.info(subdir_contents)$isdir]

    # Check if this subdirectory contains "_Statistics" folders
    if (any(grepl("_Statistics$", basename(subdir_dirs)))) {
      search_dirs <- c(search_dirs, subdir)
    }
  }

  # Error handling: No valid subdirectories found
  if (length(search_dirs) == 0) {
    stop("ERROR: No valid cell folders found! Please check your parent_dir path.")
  }

  cat("✓ Found", length(search_dirs), "subdirectories with cell data\n")

  # Display all found subdirectories
  for (dir in search_dirs) {
    cat("  - ", basename(dir), "\n", sep = "")
  }

  # Use the first subdirectory (typically "Control")
  search_dir <- search_dirs[1]
  has_LD <- FALSE

  cat("✓ Using subdirectory:", basename(search_dir), "\n")
}

cat("\n")

# ============================================================================
# STEP 2: IDENTIFY ALL CELL FOLDERS AND ORGANELLES
# ============================================================================
#
# This step scans the search directory for all folders ending with "_Statistics"
# and extracts:
# - Cell IDs (e.g., "control_1", "control_3")
# - Organelle names (e.g., "ER", "LD", "Ly", "M", "P")
#
cat("STEP 2: Identifying cell folders and organelles...\n")
cat("------------------------------------------------------------------------\n")

# Get all directories ending with "_Statistics"
all_stat_dirs <- list.files(search_dir,
                            pattern = "_Statistics$",
                            full.names = TRUE)

# Error handling: No folders found
if (length(all_stat_dirs) == 0) {
  stop("ERROR: No folders ending with '_Statistics' found!")
}

# Create a data frame to organize folder information
# Each row represents one organelle folder for one cell
cell_folders <- data.frame(
  full_path = all_stat_dirs,          # Full path to the folder
  folder_name = basename(all_stat_dirs), # Just the folder name
  stringsAsFactors = FALSE
)

# Extract cell ID from folder name
# Example: "control_1_ER_Statistics" -> "control_1"
# This regex removes the organelle and "_Statistics" suffix
# The pattern [A-Z][A-Z0-9a-z]* allows for organelles like "ER", "LD", "Ly", "M", "P", "N", "N2", "G"
cell_folders$cell_id <- gsub("_[A-Z][A-Z0-9a-z]*_Statistics$", "", cell_folders$folder_name)

# Extract organelle name from folder name
# Example: "control_1_ER_Statistics" -> "ER"
# This regex captures the text between the last underscore and "_Statistics"
# The pattern [A-Z][A-Z0-9a-z]* allows for organelles like "ER", "LD", "Ly", "M", "P", "N", "N2"
cell_folders$organelle <- gsub(".*_([A-Z][A-Z0-9a-z]*)_Statistics$", "\\1", cell_folders$folder_name)

# Display summary of what was found
cat("✓ Found", length(unique(cell_folders$cell_id)), "unique cells\n")
cat("✓ Found", length(unique(cell_folders$organelle)), "unique organelles\n\n")

# Display detailed cell summary
cell_summary <- table(cell_folders$cell_id)
cat("Cells detected:\n")
for (cell in names(cell_summary)) {
  cat("  - ", cell, ": ", cell_summary[cell], " organelle folder(s)\n", sep = "")
}

# Display organelle summary
cat("\nOrganelles detected across all cells:\n")
organelle_list <- unique(cell_folders$organelle)
for (org in organelle_list) {
  count <- sum(cell_folders$organelle == org)
  cat("  - ", org, " (found in ", count, " folder(s))\n", sep = "")
}

cat("\n")

# ============================================================================
# STEP 3: CREATE OUTPUT DIRECTORY
# ============================================================================
#
# Create a dedicated folder for all output Excel files
# This keeps the results organized and separate from raw data
#
cat("STEP 3: Creating output directory...\n")
cat("------------------------------------------------------------------------\n")

# Define output directory name with timestamp
output_dir <- file.path(search_dir, "Organelle_Interaction_Results")

# Create the directory if it doesn't exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
  cat("✓ Created new output directory: ", basename(output_dir), "\n", sep = "")
} else {
  cat("✓ Using existing output directory: ", basename(output_dir), "\n", sep = "")
}

cat("✓ Full path: ", output_dir, "\n\n", sep = "")

# ============================================================================
# STEP 4: PROCESS EACH CELL
# ============================================================================
#
# This is the main processing loop. For each cell:
# 1. Find all organelle folders belonging to that cell
# 2. Load distance data from each folder
# 3. Calculate mean distance and count for each interaction
# 4. Export results as an Excel file
#
cat("STEP 4: Processing data for each cell...\n")
cat("------------------------------------------------------------------------\n\n")

# Get list of unique cell IDs
unique_cells <- unique(cell_folders$cell_id)

# Get all unique organelles for pattern matching
all_organelles <- unique(cell_folders$organelle)

# Track overall processing statistics
total_interactions <- 0
cells_processed <- 0

# MAIN LOOP: Process each cell individually
for (cell_id in unique_cells) {

  cat("Processing cell: ", cell_id, "\n", sep = "")
  cat("  ", rep("-", 70), "\n", sep = "")

  # Get all organelle folders for this specific cell
  cell_data <- cell_folders[cell_folders$cell_id == cell_id, ]

  cat("  Found ", nrow(cell_data), " organelle folder(s) for this cell:\n", sep = "")
  for (i in 1:nrow(cell_data)) {
    cat("    • ", cell_data$folder_name[i], "\n", sep = "")
  }
  cat("\n")

  # Create empty data frame to store all interaction results for this cell
  # Columns: Source, Target, Interaction, Mean_Distance, Count
  results <- data.frame(
    Source = character(),           # Source organelle (e.g., "ER")
    Target = character(),           # Target organelle (e.g., "LD")
    Interaction = character(),      # Combined name (e.g., "ER_to_LD")
    Mean_Distance = numeric(),      # Average distance in µm
    Count = integer(),              # Number of distance measurements
    stringsAsFactors = FALSE
  )

  # Loop through each source organelle folder
  for (i in 1:nrow(cell_data)) {

    source_org <- cell_data$organelle[i]
    source_folder <- cell_data$full_path[i]

    # Find all distance files in this organelle folder
    # Pattern: "Shortest_Distance_to_Surfaces_Surfaces"
    distance_files <- list.files(source_folder,
                                 pattern = "Shortest_Distance_to_Surfaces_Surfaces",
                                 full.names = TRUE,
                                 recursive = FALSE)

    # Skip if no distance files found
    if (length(distance_files) == 0) {
      cat("  ⚠ Warning: No distance files found for ", source_org, "\n", sep = "")
      next
    }

    # Process each distance file (each represents one interaction with a target organelle)
    for (file_path in distance_files) {

      filename <- basename(file_path)

      # Extract target organelle from filename
      # Filename format: "control_1_ER_Shortest_Distance_to_Surfaces_Surfaces=LD.csv"
      # We need to extract "LD" after "Surfaces="
      target_org <- NA
      for (org in all_organelles) {
        # Check if this organelle appears after "Surfaces=" in the filename
        if (grepl(paste0("Surfaces=", org), filename)) {
          target_org <- org
          break  # Stop once we find a match
        }
      }

      # Skip if target organelle couldn't be identified
      if (is.na(target_org)) {
        cat("  ⚠ Warning: Could not identify target organelle in: ", filename, "\n", sep = "")
        next
      }

      # Read the CSV file
      # Structure: First 4 rows are headers, actual data starts at row 5
      # We only need the first column (distance values)
      df <- read.csv(file_path,
                     sep = ",",      # Comma-separated
                     skip = 4,       # Skip first 4 header rows
                     header = FALSE) # Don't treat row 5 as header

      # Calculate statistics
      # mean() computes the average of all distance values
      # na.rm = TRUE ensures NA values are ignored
      mean_value <- mean(df[, 1], na.rm = TRUE)

      # Count non-NA values (actual measurements)
      count_value <- sum(!is.na(df[, 1]))

      # Create interaction name (e.g., "ER_to_LD")
      interaction <- paste0(source_org, "_to_", target_org)

      # Add this interaction to the results data frame
      results <- rbind(results, data.frame(
        Source = source_org,
        Target = target_org,
        Interaction = interaction,
        Mean_Distance = mean_value,
        Count = count_value,
        stringsAsFactors = FALSE
      ))

      # Print progress for this interaction
      cat("  ✓ ", interaction, " | Mean: ", round(mean_value, 3), " µm | Count: ", count_value, "\n", sep = "")

      total_interactions <- total_interactions + 1
    }
  }

  # ============================================================================
  # STEP 5: EXPORT RESULTS FOR THIS CELL
  # ============================================================================
  #
  # Save all interactions for this cell to an Excel file
  #
  if (nrow(results) > 0) {

    # Create filename: "control_1_Organelle_Interactions.xlsx"
    output_filename <- paste0(cell_id, "_Organelle_Interactions.xlsx")
    output_path <- file.path(output_dir, output_filename)

    # Write to Excel
    # rowNames = FALSE prevents row numbers from being included
    write.xlsx(results, output_path, rowNames = FALSE)

    cat("\n  Exported: ", output_filename, "\n", sep = "")
    cat("  Total interactions: ", nrow(results), "\n", sep = "")

    cells_processed <- cells_processed + 1

  } else {
    cat("\n  ⚠ No data to export for ", cell_id, "\n", sep = "")
  }

  cat("\n")
}

# ============================================================================
# FINAL SUMMARY
# ============================================================================
cat("\n")
cat("================================================================================\n")
cat("                        ANALYSIS COMPLETE!\n")
cat("================================================================================\n\n")

cat("Summary:\n")
cat("  ✓ Cells processed: ", cells_processed, "\n", sep = "")
cat("  ✓ Total interactions analyzed: ", total_interactions, "\n", sep = "")
cat("  ✓ Output directory: ", output_dir, "\n\n", sep = "")

cat("================================================================================\n")
