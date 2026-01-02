# Orgaplex-Analyzer v2.2

Scientific software for quantitative analysis of organelle interactions from Imaris segmentation data.

## Overview

This software processes 3D microscopy data segmented in Imaris and calculates spatial relationships between cellular organelles. The analysis pipeline extracts shortest-distance measurements and generates statistical summaries suitable for publication.

**Key capabilities:**
- One-way interaction analysis (mean distances between organelle populations)
- Volume and sphericity metrics (morphological analysis per organelle)
- Automatic organelle detection from folder structure
- Batch processing of multiple cells
- Excel and CSV export with metadata tracking

**Current version**: 2.2.0 (Released November 2025)
**Python rewrite**: Philipp Kaintoch

---

## Installation

### Prerequisites
- macOS, Linux, or Windows
- 4 GB RAM minimum (8 GB recommended for large datasets)
- 500 MB disk space

### For Non-Programmers (Conda Method - Recommended)

1. **Install Miniconda** (if not already installed):
   - Download from https://docs.conda.io/en/latest/miniconda.html
   - Follow installation wizard
   - Open "Anaconda Prompt" (Windows) or Terminal (Mac/Linux)

2. **Download this software**:
   - Click green "Code" button on GitHub
   - Select "Download ZIP"
   - Extract to a folder (e.g., `Documents/Orgaplex-Analyzer`)

3. **Install dependencies**:
   ```bash
   cd Documents/Orgaplex-Analyzer
   conda env create -f environment.yml
   ```
   This creates an environment named "orgaplex" with all required packages.

4. **Activate the environment**:
   ```bash
   conda activate orgaplex
   ```
   You must activate this environment each time before running the software.

### For Programmers (pip Method)

```bash
git clone https://github.com/philius19/orgaplex-analyzer.git
cd orgaplex-analyzer
pip install -r requirements.txt
```

Tested on Python 3.11 and 3.12.

---

## Quick Start

### GUI Interface (Recommended for First-Time Users)

1. Activate environment:
   ```bash
   conda activate orgaplex
   ```

2. Launch GUI:
   ```bash
   python run_gui.py
   ```

3. Select directories:
   - Input: Folder containing `*_Statistics` subdirectories from Imaris
   - Output: Where to save results

4. Configure options:
   - Analysis type: One-Way Interactions
   - Format: Excel (.xlsx) or CSV

5. Click "Run Analysis" and monitor progress

### Command-Line Interface

```bash
conda activate orgaplex

python standalone_scripts/run_one_way_interaction.py \
  --input "/path/to/imaris/export" \
  --output "results.xlsx" \
  --format excel
```

For CSV output (creates multiple files):
```bash
python standalone_scripts/run_one_way_interaction.py \
  --input "/path/to/data" \
  --output "output_directory" \
  --format csv
```

---

## Input Data Requirements

### Expected Directory Structure

The software auto-detects two structure types:

**Type 1: With Lipid Droplets (LD)**
```
Input_Directory/
├── cell_01_ER_Statistics/
│   └── cell_01_ER_Shortest_Distance_to_Surfaces_Surfaces=LD.csv
├── cell_01_LD_Statistics/
├── cell_01_Ly_Statistics/
├── cell_02_ER_Statistics/
└── ...
```

**Type 2: Without LD**
```
Input_Directory/
├── Control/
│   ├── cell_01_ER_Statistics/
│   ├── cell_01_Ly_Statistics/
│   └── ...
└── Treatment/
    └── ...
```

### File Naming Convention

Distance files must follow Imaris export format:
```
{CellID}_{SourceOrganelle}_Shortest_Distance_to_Surfaces_Surfaces={TargetOrganelle}.csv
```

Examples:
- `control_1_ER_Shortest_Distance_to_Surfaces_Surfaces=LD.csv`
- `treated_5_M_Shortest_Distance_to_Surfaces_Surfaces=P.csv`

### CSV File Format

Files must contain numerical distance values (in micrometers or nanometers) starting from row 5 (Imaris exports include 4-line header).

---

## Output Format

### Data Organization

Results are organised as **rows = interactions, columns = cells**:

| Interaction | cell_01 | cell_02 | cell_03 |
|-------------|---------|---------|---------|
| ER-to-LD    | 5.87    | 6.12    | 7.33    |
| ER-to-Ly    | 0.27    | 0.31    | 0.09    |
| M-to-ER     | 0.001   | 0.013   | 0.000   |

This format is compatible with:
- GraphPad Prism
- R statistical packages (tidyverse)
- Python data science tools (pandas, seaborn)
- Excel pivot tables

### Excel Output (4 Sheets)

1. **Mean_Distance**: Mean shortest distances per interaction
2. **Count**: Number of measurements (sample size per interaction)
3. **Data_Completeness**: "Present" or "Missing" for quality control
4. **Metadata**: Analysis provenance (software version, timestamp, parameters)

### CSV Output (4 Files)

When using `--format csv`, four files are generated in the output directory:
- `one_way_interactions_mean_distance.csv`
- `one_way_interactions_count.csv`
- `one_way_interactions_data_completeness.csv`
- `one_way_interactions_metadata.csv`

### Interpreting Results

- **NaN values**: No data file found for this interaction/cell combination
- **Zero counts**: Distance file was empty or contained no valid measurements
- **Missing entries**: Logged automatically with warnings during analysis

---

## Methods Summary

### Analysis Algorithm

One-way interaction analysis calculates the mean shortest distance from each object in the source organelle population to the nearest object in the target population.

**Mathematical definition**:
```
For source organelle S and target organelle T:
  d_i = min(distance from object i in S to all objects in T)
  Mean distance = (1/n) * Σ d_i
```

where n = number of objects in source population.

**Statistical notes**:
- Distance units: Preserved from Imaris
- Interaction count: Only values <= 0 are counted (threshold for valid interaction)
- Outlier handling: No automated filtering (preserve raw measurements)
- Missing data: Reported explicitly in Data_Completeness sheet

### Data Validation

The software performs these validation checks:

1. **File integrity**: Non-empty, readable CSV files
2. **Numeric validation**: All distance values are finite numbers
3. **Range checks**: Warning if distances exceed 100 micrometers
4. **Completeness tracking**: Missing interaction/cell combinations logged

Validation failures halt analysis with detailed error messages.

### Performance Characteristics

- Processing time: ~0.8 seconds per cell 
- Memory usage: ~100 MB for 200 cells
- Optimisation: O(1) dictionary lookups for large datasets

---

## Project Architecture

```
Orgaplex-Analyzer/
├── src/                    # Core modules
│   ├── core/
│   │   ├── data_loader.py        # Data extraction & validation
│   │   └── one_way_interaction.py # Statistical analysis
│   ├── gui/
│   │   └── main_window.py        # Tkinter interface
│   └── utils/
│       └── logging_config.py     # Logging framework
├── standalone_scripts/     # Customizable analysis scripts
├── run_gui.py             # GUI launcher
├── environment.yml        # Conda environment specification
├── requirements.txt       # pip dependencies
└── setup.py               # Package configuration
```

### Design Principles

- **Modularity**: Core logic separated from interfaces (GUI/CLI)
- **Data provenance**: Every output includes metadata for reproducibility
- **Robustness**: Comprehensive validation prevents silent data corruption
- **Performance**: O(1) lookups for large datasets (200+ cells)

---

## Customisation

The standalone scripts are designed for easy modification by researchers with basic Python knowledge. Each script has a **CONFIGURATION** section at the top where you can modify parameters without touching complex code.


### Available Scripts

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `run_one_way_interaction.py` | Mean distances between organelle populations | Standard proximity analysis |
| `run_vol_spher_metrics.py` | Volume and sphericity per organelle | Morphological analysis |
| `run_nway_interaction.py` | Multi-organelle contact patterns | Complex network analysis |

### Configuration Examples

#### Example 1: Analyse Only ER-Mitochondria Contacts

**Goal**: Focus on ER-to-Mitochondria interactions, ignore all others

**Steps**:
1. Open `standalone_scripts/run_one_way_interaction.py`
2. Find the CONFIGURATION section (around line 35)
3. Modify this line:
   ```python
   INTERACTION_FILTER = ['ER-to-M', 'M-to-ER']  # Only ER-mito interactions
   ```
4. Run normally:
   ```bash
   python standalone_scripts/run_one_way_interaction.py \
     --input /path/to/data --output er_mito_results.xlsx
   ```

**Result**: Output Excel will only contain ER-M and M-ER interactions

**Biological Context**: Useful for focused mitochondria-associated ER membrane (MAM) studies without distraction from other organelles.

---

#### Example 2: Calculate Median Instead of Mean

**Goal**: Get median distances instead of mean (more robust to outliers)

**Steps**:
1. Copy the script:
   ```bash
   cp standalone_scripts/run_one_way_interaction.py my_median_analysis.py
   ```

2. Open `my_median_analysis.py` and add custom analysis after imports:
   ```python
   from src.core.one_way_interaction import OneWayInteractionAnalyzer
   import numpy as np

   class MedianAnalyzer(OneWayInteractionAnalyzer):
       def analyze_cell(self, cell_id):
           result = {}
           for source_org in self.data_loader.all_organelles:
               distance_files = self.data_loader.get_distance_files(cell_id, source_org)
               for file_path, target_org in distance_files:
                   try:
                       distances = self.data_loader.load_distance_file(file_path)
                       interaction = f"{source_org}-to-{target_org}"
                       result[interaction] = {
                           'mean': np.median(distances),  # Changed from mean to median
                           'count': len(distances)
                       }
                   except Exception as e:
                       pass
           return result
   ```

3. In `main()`, replace line ~120:
   ```python
   analyzer = MedianAnalyzer(str(input_path))  # Use custom class
   ```

4. Run:
   ```bash
   python my_median_analysis.py --input data/ --output median_results.xlsx
   ```

**When to use**: Publications requiring non-parametric statistics, or when distance distributions are heavily skewed.

---

#### Example 3: Batch Process Multiple Datasets

**Goal**: Run analysis on multiple experiment folders automatically

**Steps**:
1. Create a new script `batch_process.py`:
   ```python
   #!/usr/bin/env python3
   import subprocess
   from pathlib import Path

   # List your experiment directories
   experiments = [
       "/path/to/control_replicate1",
       "/path/to/control_replicate2",
       "/path/to/treatment_replicate1",
   ]

   for exp_dir in experiments:
       exp_name = Path(exp_dir).name
       output_file = f"results_{exp_name}.xlsx"

       print(f"\nProcessing: {exp_name}")
       subprocess.run([
           "python", "standalone_scripts/run_one_way_interaction.py",
           "--input", exp_dir,
           "--output", output_file,
           "--format", "excel"
       ])

   print("\nAll experiments processed!")
   ```

2. Run:
   ```bash
   python batch_process.py
   ```

**When to use**: High-throughput experiments with consistent folder structures.

---

### Parameter Reference

#### Common Parameters (All Scripts)

**OUTPUT_FORMAT**
```python
OUTPUT_FORMAT = 'excel'  # Single .xlsx file with multiple sheets
OUTPUT_FORMAT = 'csv'    # Multiple .csv files in output directory
```

**Context**: Excel is better for small-to-medium datasets. CSV is better for large datasets or R/Python downstream analysis.

---

#### One-Way Interaction Parameters

**DISTANCE_THRESHOLD** (Filter interactions by distance)
```python
DISTANCE_THRESHOLD = None   # No filtering (report all distances)
```

**Context**: In Imaris, negative distances mean overlap. Setting `0.0` counts only direct contacts. 

**INTERACTION_FILTER** (Analyse specific organelle pairs)
```python
INTERACTION_FILTER = None                    # All interactions
INTERACTION_FILTER = ['ER-to-M', 'ER-to-LD'] # Only ER relationships
```

---

#### N-Way Interaction Parameters

**CONTACT_THRESHOLD** (Define "contact")
```python
CONTACT_THRESHOLD = 0.0   # Only overlaps (negative distances)
```


**BAIT_ORGANELLES** (Which organelles to analyse)
```python
BAIT_ORGANELLES = None        # Interactive mode (prompts you)
BAIT_ORGANELLES = ['ER']      # Only analyze ER
BAIT_ORGANELLES = ['ER', 'M'] # ER and mitochondria
```


---

### Getting Help

See `standalone_scripts/README.md` for:
- Complete script documentation
- More customisation examples
- Parameter descriptions
- Troubleshooting tips

Quick template:
```bash
cp standalone_scripts/run_one_way_interaction.py my_custom_script.py
# Edit CONFIGURATION section
python my_custom_script.py --input data/ --output results.xlsx
```

---

## Troubleshooting

**Error**: "No folders ending with '_Statistics' found"
**Solution**: Verify input directory contains Imaris export folders. Check folder naming matches `*_Statistics` pattern.

**Error**: "No module named 'src'"
**Solution**: Run scripts from project root directory, not from subdirectories.

**Problem**: GUI freezes during analysis
**Solution**: Normal for large datasets. Monitor status window for progress. Analysis runs in background thread.

**Problem**: Missing data warnings
**Solution**: Check Data_Completeness sheet. Missing data may indicate incomplete Imaris export or analysis failures for specific cells.

**Error**: "No valid distance values found"
**Solution**: Verify CSV files contain numeric data starting at row 5. Check files are not empty.


---


## Contact

For bugs, feature requests, or questions:
- Email: p.kaintoch@uni-muenster.de


---
