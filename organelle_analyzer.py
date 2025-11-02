#!/usr/bin/env python3
"""
This script analyzes organelle interactions from Imaris-generated segmentation
data. It processes shortest distance measurements between organelles and exports
results as Excel or CSV files.

AUTHOR: Philipp Kaintoch
DATE: 2025-10-09
VERSION: 1.0.0
================================================================================
"""

import os
import re
import pandas as pd
import numpy as np
from pathlib import Path
from typing import Dict, List, Tuple, Optional
import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import threading
from datetime import datetime


# ================================================================================
# CORE ANALYSIS CLASS
# ================================================================================

class OrganelleAnalyzer:
    """
    Core class for analyzing organelle interaction data.

    This class handles:
    - Detection of folder structure (LD vs non-LD datasets)
    - Parsing of Statistics folders and distance files
    - Calculation of mean distances and counts
    - Export to Excel or CSV formats
    """

    def __init__(self, parent_dir: str, progress_callback=None, status_callback=None):
        """
        Initialize the analyzer with a parent directory.

        Parameters:
        -----------
        parent_dir : str
            Path to the parent directory containing the data
        progress_callback : callable, optional
            Function to call with progress updates (0-100)
        status_callback : callable, optional
            Function to call with status messages
        """
        self.parent_dir = Path(parent_dir)
        self.progress_callback = progress_callback
        self.status_callback = status_callback

        # Data storage
        self.search_dir = None
        self.has_ld = False
        self.cell_folders = []
        self.all_organelles = []
        self.results = {}

        # Regex patterns for parsing folder and file names
        # Pattern to extract cell ID: everything before the last organelle_Statistics
        # Example: "control_1_ER_Statistics" -> "control_1"
        self.cell_id_pattern = re.compile(r'^(.+?)_[A-Z][A-Z0-9a-z]*_Statistics$')

        # Pattern to extract organelle from folder name
        # Example: "control_1_ER_Statistics" -> "ER"
        self.organelle_pattern = re.compile(r'_([A-Z][A-Z0-9a-z]*)_Statistics$')

        # Pattern to extract target organelle from filename
        # Example: "control_1_ER_Shortest_Distance_to_Surfaces_Surfaces=LD.csv" -> "LD"
        self.target_pattern = re.compile(r'Surfaces=([A-Z][A-Z0-9a-z]*)')

    def update_progress(self, value: float):
        """Update progress bar (0-100)."""
        if self.progress_callback:
            self.progress_callback(value)

    def update_status(self, message: str):
        """Update status message."""
        if self.status_callback:
            self.status_callback(message)
        print(f"[STATUS] {message}")

    def detect_structure(self) -> bool:
        """
        Detect the folder structure to determine if dataset contains LD.

        Returns:
        --------
        bool : True if structure detected successfully, False otherwise

        Structure 1 (WITH LD): Folders directly in parent_dir
            parent_dir/control_1_ER_Statistics/...

        Structure 2 (WITHOUT LD): Folders in subdirectories
            parent_dir/Control/control_1_ER_Statistics/...
        """
        self.update_status("Detecting folder structure...")

        if not self.parent_dir.exists():
            raise FileNotFoundError(f"Parent directory does not exist: {self.parent_dir}")

        # Get all items in parent directory
        all_items = list(self.parent_dir.iterdir())
        all_dirs = [item for item in all_items if item.is_dir()]

        # Check if any directory ends with "_Statistics"
        has_statistics_dirs = any(d.name.endswith('_Statistics') for d in all_dirs)

        if has_statistics_dirs:
            # Structure 1: Direct (WITH LD)
            self.update_status("Structure: Direct - Dataset contains LD")
            self.search_dir = self.parent_dir
            self.has_ld = True
        else:
            # Structure 2: Nested (WITHOUT LD)
            self.update_status("Structure: Nested - Searching subdirectories...")

            # Find subdirectories containing Statistics folders
            search_dirs = []
            for subdir in all_dirs:
                subdir_contents = list(subdir.iterdir())
                subdir_dirs = [item for item in subdir_contents if item.is_dir()]
                if any(d.name.endswith('_Statistics') for d in subdir_dirs):
                    search_dirs.append(subdir)

            if not search_dirs:
                raise ValueError("No valid Statistics folders found in parent directory or subdirectories")

            self.update_status(f"Found {len(search_dirs)} subdirectories with data")
            # Use the first subdirectory (typically "Control")
            self.search_dir = search_dirs[0]
            self.has_ld = False

        return True

    def find_cell_folders(self) -> bool:
        """
        Identify all cell folders and extract cell IDs and organelles.

        Returns:
        --------
        bool : True if cell folders found, False otherwise
        """
        self.update_status("Identifying cell folders...")

        # Find all directories ending with "_Statistics"
        stat_dirs = [d for d in self.search_dir.iterdir()
                     if d.is_dir() and d.name.endswith('_Statistics')]

        if not stat_dirs:
            raise ValueError("No folders ending with '_Statistics' found")

        # Parse each folder to extract cell ID and organelle
        self.cell_folders = []
        for folder in stat_dirs:
            folder_name = folder.name

            # Extract cell ID
            cell_match = self.cell_id_pattern.match(folder_name)
            if not cell_match:
                self.update_status(f"Warning: Could not parse cell ID from {folder_name}")
                continue
            cell_id = cell_match.group(1)

            # Extract organelle
            org_match = self.organelle_pattern.search(folder_name)
            if not org_match:
                self.update_status(f"Warning: Could not parse organelle from {folder_name}")
                continue
            organelle = org_match.group(1)

            self.cell_folders.append({
                'full_path': folder,
                'folder_name': folder_name,
                'cell_id': cell_id,
                'organelle': organelle
            })

        if not self.cell_folders:
            raise ValueError("No valid cell folders could be parsed")

        # Extract unique values
        unique_cells = set(f['cell_id'] for f in self.cell_folders)
        self.all_organelles = sorted(set(f['organelle'] for f in self.cell_folders))

        self.update_status(f"Found {len(unique_cells)} unique cells")
        self.update_status(f"Found {len(self.all_organelles)} unique organelles: {', '.join(self.all_organelles)}")

        return True

    def process_cell(self, cell_id: str) -> Dict:
        """
        Process all organelle interactions for a single cell.

        Parameters:
        -----------
        cell_id : str
            The cell identifier (e.g., "control_1")

        Returns:
        --------
        dict : Dictionary containing all interactions for this cell
            {
                'ER': {
                    'LD': {'mean': 5.87, 'count': 2260},
                    'Ly': {'mean': 0.27, 'count': 2260}
                },
                ...
            }
        """
        self.update_status(f"Processing cell: {cell_id}")

        # Get all folders for this cell
        cell_data = [f for f in self.cell_folders if f['cell_id'] == cell_id]

        # Storage for this cell's interactions
        interactions = {}

        # Process each source organelle folder
        for folder_info in cell_data:
            source_org = folder_info['organelle']
            source_folder = folder_info['full_path']

            # Initialize dictionary for this source organelle
            if source_org not in interactions:
                interactions[source_org] = {}

            # Find all distance files
            distance_files = list(source_folder.glob('*Shortest_Distance_to_Surfaces_Surfaces*.csv'))

            if not distance_files:
                self.update_status(f"  Warning: No distance files found for {source_org}")
                continue

            # Process each distance file
            for file_path in distance_files:
                filename = file_path.name

                # Extract target organelle from filename
                target_match = self.target_pattern.search(filename)
                if not target_match:
                    self.update_status(f"  Warning: Could not identify target in {filename}")
                    continue

                target_org = target_match.group(1)

                # Read the CSV file
                try:
                    # Skip first 4 rows (headers), no column names
                    df = pd.read_csv(file_path, skiprows=4, header=None)

                    # Calculate statistics on first column
                    distances = df.iloc[:, 0].dropna()
                    mean_distance = distances.mean()
                    count = len(distances)

                    # Store results
                    interactions[source_org][target_org] = {
                        'mean': mean_distance,
                        'count': count
                    }

                    self.update_status(f"  {source_org}_to_{target_org}: mean={mean_distance:.3f}, count={count}")

                except Exception as e:
                    self.update_status(f"  Error reading {filename}: {str(e)}")
                    continue

        return interactions

    def process_all_cells(self) -> Dict:
        """
        Process all cells in the dataset.

        Returns:
        --------
        dict : Results for all cells
            {
                'control_1': {...},
                'control_3': {...},
                ...
            }
        """
        # Get unique cell IDs
        unique_cells = sorted(set(f['cell_id'] for f in self.cell_folders))
        total_cells = len(unique_cells)

        self.update_status(f"Processing {total_cells} cells...")
        self.results = {}

        # Process each cell
        for idx, cell_id in enumerate(unique_cells):
            # Update progress
            progress = (idx / total_cells) * 90  # Reserve last 10% for export
            self.update_progress(progress)

            # Process this cell
            cell_interactions = self.process_cell(cell_id)
            self.results[cell_id] = cell_interactions

        self.update_progress(90)
        self.update_status(f"Completed processing {total_cells} cells")

        return self.results

    def export_single_file(self, output_path: Path, file_format: str = 'excel'):
        """
        Export all cells to a single file.

        Parameters:
        -----------
        output_path : Path
            Path for the output file
        file_format : str
            Either 'excel' or 'csv'
        """
        self.update_status("Exporting to single file...")

        # Build a flat table with all data
        rows = []
        for cell_id, cell_data in self.results.items():
            for source_org, targets in cell_data.items():
                for target_org, metrics in targets.items():
                    rows.append({
                        'cell_id': cell_id,
                        'source': source_org,
                        'target': target_org,
                        'interaction': f"{source_org}_to_{target_org}",
                        'mean_distance': metrics['mean'],
                        'count': metrics['count']
                    })

        # Create DataFrame
        df = pd.DataFrame(rows)

        # Sort by cell_id, source, target
        df = df.sort_values(['cell_id', 'source', 'target'])

        # Export
        if file_format == 'excel':
            df.to_excel(output_path, index=False, engine='openpyxl')
        else:  # csv
            df.to_csv(output_path, index=False)

        self.update_status(f"Exported: {output_path.name}")
        return len(rows)

    def export_per_cell_files(self, output_dir: Path, file_format: str = 'excel'):
        """
        Export one file per cell.

        Parameters:
        -----------
        output_dir : Path
            Directory to save the files
        file_format : str
            Either 'excel' or 'csv'
        """
        self.update_status("Exporting individual cell files...")

        output_dir.mkdir(exist_ok=True)
        file_count = 0

        for cell_id, cell_data in self.results.items():
            # Build table for this cell
            rows = []
            for source_org, targets in cell_data.items():
                for target_org, metrics in targets.items():
                    rows.append({
                        'source': source_org,
                        'target': target_org,
                        'interaction': f"{source_org}_to_{target_org}",
                        'mean_distance': metrics['mean'],
                        'count': metrics['count']
                    })

            if not rows:
                self.update_status(f"  Warning: No data for {cell_id}")
                continue

            # Create DataFrame
            df = pd.DataFrame(rows)
            df = df.sort_values(['source', 'target'])

            # Determine filename
            extension = 'xlsx' if file_format == 'excel' else 'csv'
            filename = f"{cell_id}_Organelle_Interactions.{extension}"
            output_path = output_dir / filename

            # Export
            if file_format == 'excel':
                df.to_excel(output_path, index=False, engine='openpyxl')
            else:  # csv
                df.to_csv(output_path, index=False)

            file_count += 1
            self.update_status(f"  Exported: {filename}")

        return file_count


# ================================================================================
# GUI CLASS
# ================================================================================

class AnalyzerGUI:
    """
    Graphical user interface for the Organelle Analyzer.

    Provides controls for:
    - Selecting input and output directories
    - Choosing export format and output mode
    - Running the analysis
    - Monitoring progress
    """

    def __init__(self, root):
        """Initialize the GUI."""
        self.root = root
        self.root.title("Organelle Interaction Analysis Tool")
        self.root.geometry("700x650")
        self.root.resizable(True, True)

        # Variables
        self.input_dir = tk.StringVar()
        self.output_dir = tk.StringVar()
        self.file_format = tk.StringVar(value='excel')
        self.output_mode = tk.StringVar(value='single')

        # Set default output directory to user's home
        self.output_dir.set(str(Path.home()))

        self.setup_ui()

    def setup_ui(self):
        """Create and layout all UI elements."""

        # Main container with padding
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))

        # Title
        title_label = ttk.Label(main_frame, text="Organelle Interaction Analysis Tool",
                               font=('Arial', 14, 'bold'))
        title_label.grid(row=0, column=0, columnspan=3, pady=(0, 20))

        # Input Directory Section
        row = 1
        ttk.Label(main_frame, text="Input Directory:", font=('Arial', 10, 'bold')).grid(
            row=row, column=0, sticky=tk.W, pady=(0, 5))

        row += 1
        ttk.Entry(main_frame, textvariable=self.input_dir, width=50).grid(
            row=row, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 5))
        ttk.Button(main_frame, text="Browse...", command=self.browse_input_dir).grid(
            row=row, column=2, padx=(5, 0), pady=(0, 5))

        # Output Directory Section
        row += 1
        ttk.Label(main_frame, text="Output Directory:", font=('Arial', 10, 'bold')).grid(
            row=row, column=0, sticky=tk.W, pady=(15, 5))

        row += 1
        ttk.Entry(main_frame, textvariable=self.output_dir, width=50).grid(
            row=row, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 5))
        ttk.Button(main_frame, text="Browse...", command=self.browse_output_dir).grid(
            row=row, column=2, padx=(5, 0), pady=(0, 5))

        # Separator
        row += 1
        ttk.Separator(main_frame, orient='horizontal').grid(
            row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=20)

        # Analysis Options
        row += 1
        ttk.Label(main_frame, text="Analysis Options", font=('Arial', 10, 'bold')).grid(
            row=row, column=0, sticky=tk.W, pady=(0, 10))

        # Output Format
        row += 1
        format_frame = ttk.Frame(main_frame)
        format_frame.grid(row=row, column=0, columnspan=3, sticky=tk.W, pady=5)

        ttk.Label(format_frame, text="Output Format:").pack(side=tk.LEFT, padx=(0, 20))
        ttk.Radiobutton(format_frame, text="Excel (.xlsx)", variable=self.file_format,
                       value='excel').pack(side=tk.LEFT, padx=5)
        ttk.Radiobutton(format_frame, text="CSV (.csv)", variable=self.file_format,
                       value='csv').pack(side=tk.LEFT, padx=5)

        # Output Mode
        row += 1
        mode_frame = ttk.Frame(main_frame)
        mode_frame.grid(row=row, column=0, columnspan=3, sticky=tk.W, pady=5)

        ttk.Label(mode_frame, text="Output Mode:").pack(side=tk.LEFT, padx=(0, 20))
        ttk.Radiobutton(mode_frame, text="Single file (all cells)", variable=self.output_mode,
                       value='single').pack(side=tk.LEFT, padx=5)
        ttk.Radiobutton(mode_frame, text="Separate files per cell", variable=self.output_mode,
                       value='separate').pack(side=tk.LEFT, padx=5)

        # Separator
        row += 1
        ttk.Separator(main_frame, orient='horizontal').grid(
            row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=20)

        # Run Button
        row += 1
        self.run_button = ttk.Button(main_frame, text="Run Analysis",
                                     command=self.run_analysis)
        self.run_button.grid(row=row, column=0, columnspan=3, pady=(0, 20))

        # Progress Bar
        row += 1
        ttk.Label(main_frame, text="Progress:", font=('Arial', 10)).grid(
            row=row, column=0, sticky=tk.W, pady=(0, 5))

        row += 1
        self.progress_bar = ttk.Progressbar(main_frame, mode='determinate', length=400)
        self.progress_bar.grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))

        # Status Text
        row += 1
        ttk.Label(main_frame, text="Status:", font=('Arial', 10)).grid(
            row=row, column=0, sticky=tk.W, pady=(0, 5))

        row += 1
        self.status_text = tk.Text(main_frame, height=12, width=75, wrap=tk.WORD,
                                   state='disabled', font=('Courier', 9))
        self.status_text.grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E))

        # Scrollbar for status text
        scrollbar = ttk.Scrollbar(main_frame, orient='vertical', command=self.status_text.yview)
        scrollbar.grid(row=row, column=3, sticky=(tk.N, tk.S))
        self.status_text['yscrollcommand'] = scrollbar.set

    def browse_input_dir(self):
        """Open dialog to select input directory."""
        directory = filedialog.askdirectory(title="Select Input Directory")
        if directory:
            self.input_dir.set(directory)

    def browse_output_dir(self):
        """Open dialog to select output directory."""
        directory = filedialog.askdirectory(title="Select Output Directory")
        if directory:
            self.output_dir.set(directory)

    def update_status(self, message: str):
        """Update the status text box."""
        self.status_text.config(state='normal')
        self.status_text.insert(tk.END, message + '\n')
        self.status_text.see(tk.END)
        self.status_text.config(state='disabled')
        self.root.update_idletasks()

    def update_progress(self, value: float):
        """Update the progress bar."""
        self.progress_bar['value'] = value
        self.root.update_idletasks()

    def validate_inputs(self) -> bool:
        """Validate user inputs before running analysis."""
        if not self.input_dir.get():
            messagebox.showerror("Error", "Please select an input directory")
            return False

        if not Path(self.input_dir.get()).exists():
            messagebox.showerror("Error", "Input directory does not exist")
            return False

        if not self.output_dir.get():
            messagebox.showerror("Error", "Please select an output directory")
            return False

        if not Path(self.output_dir.get()).exists():
            messagebox.showerror("Error", "Output directory does not exist")
            return False

        return True

    def run_analysis_thread(self):
        """Run the analysis in a separate thread (called by run_analysis)."""
        try:
            # Clear status
            self.status_text.config(state='normal')
            self.status_text.delete(1.0, tk.END)
            self.status_text.config(state='disabled')

            # Reset progress
            self.update_progress(0)

            # Create analyzer
            analyzer = OrganelleAnalyzer(
                self.input_dir.get(),
                progress_callback=self.update_progress,
                status_callback=self.update_status
            )

            # Step 1: Detect structure (5%)
            self.update_status("="*60)
            self.update_status("ORGANELLE INTERACTION ANALYSIS")
            self.update_status("="*60)
            self.update_status("")

            analyzer.detect_structure()
            self.update_progress(5)

            # Step 2: Find cell folders (10%)
            analyzer.find_cell_folders()
            self.update_progress(10)

            # Step 3: Process all cells (10-90%)
            self.update_status("")
            analyzer.process_all_cells()

            # Step 4: Export results (90-100%)
            self.update_status("")
            self.update_status("="*60)
            self.update_status("EXPORTING RESULTS")
            self.update_status("="*60)
            self.update_status("")

            output_path = Path(self.output_dir.get())
            file_format = self.file_format.get()
            output_mode = self.output_mode.get()

            if output_mode == 'single':
                # Single file for all cells
                extension = 'xlsx' if file_format == 'excel' else 'csv'
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                filename = f"Organelle_Interactions_All_Cells_{timestamp}.{extension}"
                output_file = output_path / filename

                num_interactions = analyzer.export_single_file(output_file, file_format)
                self.update_progress(100)

                self.update_status("")
                self.update_status("="*60)
                self.update_status("ANALYSIS COMPLETE")
                self.update_status("="*60)
                self.update_status(f"Total interactions: {num_interactions}")
                self.update_status(f"Output file: {output_file}")

            else:
                # Separate files per cell
                results_dir = output_path / "Organelle_Interaction_Results"
                num_files = analyzer.export_per_cell_files(results_dir, file_format)
                self.update_progress(100)

                self.update_status("")
                self.update_status("="*60)
                self.update_status("ANALYSIS COMPLETE")
                self.update_status("="*60)
                self.update_status(f"Files created: {num_files}")
                self.update_status(f"Output directory: {results_dir}")

            # Show success message
            messagebox.showinfo("Success", "Analysis completed successfully!")

        except Exception as e:
            self.update_status("")
            self.update_status("ERROR: " + str(e))
            messagebox.showerror("Error", f"Analysis failed:\n{str(e)}")

        finally:
            # Re-enable run button
            self.run_button.config(state='normal')

    def run_analysis(self):
        """Start the analysis (validates inputs and launches thread)."""
        if not self.validate_inputs():
            return

        # Disable run button during analysis
        self.run_button.config(state='disabled')

        # Run in separate thread to keep GUI responsive
        thread = threading.Thread(target=self.run_analysis_thread, daemon=True)
        thread.start()


# ================================================================================
# MAIN ENTRY POINT
# ================================================================================

def main():
    """Main entry point for the application."""
    root = tk.Tk()
    app = AnalyzerGUI(root)
    root.mainloop()


if __name__ == "__main__":
    main()
