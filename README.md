# Orgaplex-Analyzer v2.3

Scientific software for quantitative analysis of organelle interactions from Imaris segmentation data.

## Overview

This software processes 3D microscopy data segmented in Imaris and calculates spatial relationships between cellular organelles. The analysis pipeline extracts shortest-distance measurements and generates statistical summaries.

**Current version**: 2.3.0 (Released February 2026)
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

### Pip Method (recommended)

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
   - Input: Parent folder from Imaris export 
   - Output: Where to save results

4. Configure options:
   - Format: Excel (.xlsx) or CSV

5. Click "Run Analysis" and monitor progress

---


## Contact

For bugs, feature requests, or questions:
- Email: p.kaintoch@uni-muenster.de


---
