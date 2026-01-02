"""
N-Way Interaction Analysis Module

This module analyzes multi-organelle contact patterns from Imaris-generated
segmentation data. For a "bait" organelle, it counts how many surface points
are in contact with various combinations of target organelles.

For n target organelles, generates 2^n boolean combinations:
- 1-way: contact with exactly 1 target (e.g., "ER_only")
- 2-way: contact with exactly 2 targets (e.g., "ER+LD")
- ...
- n-way: contact with all targets
- No_contact: no targets in contact

Output Format:
    One Excel file per bait organelle
    Rows = cells, Columns = [Cell_ID, Surface_count, combo1, combo2, ..., No_contact]

Author: Philipp Kaintoch
Date: 2025-11-18
Version: 2.2.0
"""

import itertools
import pandas as pd
import numpy as np
import sys
from pathlib import Path
from typing import Dict, List, Set, Tuple, Optional
from datetime import datetime
from .data_loader import DataLoader
from ..utils.logging_config import get_logger
from ..utils.sorting import sort_cell_ids
from ..__version__ import __version__

# Initialize logger
logger = get_logger(__name__)


class NWayInteractionAnalyzer:
    """
    Analyzes n-way organelle interactions using boolean combination patterns.

    For a bait organelle, this class:
    1. Loads distance measurements to all other organelles (targets)
    2. For each surface point, determines which targets are in contact
    3. Counts surfaces matching each boolean pattern
    4. Outputs counts per cell in a structured format
    """

    def __init__(self, input_dir: str, threshold: float = 0.0):
        """
        Initialize the analyzer.

        Parameters:
        -----------
        input_dir : str
            Path to the directory containing the data
        threshold : float
            Distance threshold for contact (default: <= 0)
            Negative distances in Imaris indicate overlapping organelles
        """
        self.input_dir = input_dir
        self.threshold = threshold
        self.data_loader = DataLoader(input_dir)
        self.bait_organelles = None  # None = batch mode (all organelles)
        self.results = {}  # bait -> DataFrame
        self.metadata = {}

    def load_data(self):
        """
        Load and validate data using DataLoader.

        This method must be called before running analysis.
        """
        logger.info("Loading data...")
        self.data_loader.detect_structure()
        self.data_loader.find_cell_folders()

        # Log summary
        summary = self.data_loader.get_summary()
        for line in summary.split('\n'):
            if line.strip():
                logger.info(line)

    def get_available_organelles(self) -> List[str]:
        """
        Get list of detected organelles.

        Returns:
        --------
        List[str] : Sorted list of organelle names
        """
        return self.data_loader.all_organelles

    def set_bait_organelles(self, baits: List[str]):
        """
        Set specific bait organelles for single-bait mode.

        Parameters:
        -----------
        baits : List[str]
            List of organelle names to use as baits
        """
        # Validate that baits exist in data
        available = set(self.data_loader.all_organelles)
        for bait in baits:
            if bait not in available:
                raise ValueError(f"Bait '{bait}' not found in data. Available: {available}")

        self.bait_organelles = baits
        logger.info(f"Set bait organelles: {baits}")

    @staticmethod
    def generate_boolean_combinations(target_organelles: List[str]) -> List[Tuple[str, Set[str]]]:
        """
        Generate all 2^n boolean combinations for n target organelles.

        Parameters:
        -----------
        target_organelles : List[str]
            List of target organelle names

        Returns:
        --------
        List[Tuple[str, Set[str]]] : List of (name, contact_set) tuples
            - name: Human-readable name (e.g., "ER_only", "ER+LD")
            - contact_set: Set of organelles that must be in contact
        """
        # Sort alphabetically for consistent naming
        sorted_targets = sorted(target_organelles)
        combinations_list = []

        # Generate all subsets from size 1 to n
        for r in range(1, len(sorted_targets) + 1):
            for combo in itertools.combinations(sorted_targets, r):
                # Create name: "ER_only" for single, "ER+LD" for pairs
                if r == 1:
                    name = f"{combo[0]}_only"
                else:
                    name = "+".join(combo)

                contact_set = set(combo)
                combinations_list.append((name, contact_set))

        # Add "No_contact" as final combination (empty set)
        combinations_list.append(("No_contact", set()))

        return combinations_list

    def _evaluate_contacts(self, distance_data: Dict[str, pd.Series]) -> Dict[str, int]:
        """
        Evaluate contact patterns for surface points.

        For each surface point, determines which boolean pattern it matches
        and counts the total for each pattern.

        Parameters:
        -----------
        distance_data : Dict[str, pd.Series]
            Maps target organelle names to distance Series (all same length)

        Returns:
        --------
        Dict[str, int] : Counts for each boolean combination
            Includes 'Surface_count' as first entry
        """
        targets = list(distance_data.keys())

        # Handle empty data case
        if not targets:
            logger.warning("No target organelles found")
            return {'Surface_count': 0}

        # Get combinations for these targets
        combos = self.generate_boolean_combinations(targets)

        # Create contact matrix: True if distance <= threshold
        contact_df = pd.DataFrame({
            org: distances <= self.threshold
            for org, distances in distance_data.items()
        })

        # Initialize counts with surface count
        counts = {'Surface_count': len(contact_df)}

        # Evaluate each boolean combination
        for combo_name, expected_contacts in combos:
            if len(expected_contacts) == 0:
                # No_contact: all organelles must be False (not in contact)
                mask = ~contact_df.any(axis=1)
            else:
                # Specific combination: exactly these organelles in contact
                # Step 1: All expected organelles must be in contact
                in_contact = contact_df[list(expected_contacts)].all(axis=1)

                # Step 2: All other organelles must NOT be in contact
                others = [o for o in targets if o not in expected_contacts]
                if others:
                    not_in_contact = ~contact_df[others].any(axis=1)
                    mask = in_contact & not_in_contact
                else:
                    # All targets are in the expected set
                    mask = in_contact

            counts[combo_name] = int(mask.sum())

        return counts

    def analyze_cell_for_bait(self, cell_id: str, bait_organelle: str) -> Dict[str, int]:
        """
        Analyze one cell for a specific bait organelle.

        Parameters:
        -----------
        cell_id : str
            Cell identifier (e.g., "control_1")
        bait_organelle : str
            Bait organelle name (e.g., "ER")

        Returns:
        --------
        Dict[str, int] : Counts dictionary
            {'Surface_count': N, 'ER_only': 150, 'ER+LD': 45, ..., 'No_contact': 892}
        """
        # Get distance files for the bait organelle
        distance_files = self.data_loader.get_distance_files(cell_id, bait_organelle)

        if not distance_files:
            logger.warning(f"No distance files found for {cell_id}/{bait_organelle}")
            return None

        # Load distance data for each target organelle
        distance_data = {}
        reference_length = None

        for file_path, target_org in distance_files:
            try:
                distances = self.data_loader.load_distance_file(file_path)

                # Validate consistent length
                if reference_length is None:
                    reference_length = len(distances)
                elif len(distances) != reference_length:
                    logger.warning(
                        f"Length mismatch in {cell_id}/{bait_organelle}: "
                        f"{target_org} has {len(distances)} vs expected {reference_length}"
                    )
                    # Skip this target to maintain data integrity
                    continue

                distance_data[target_org] = distances

            except Exception as e:
                logger.error(f"Failed to load {file_path.name}: {str(e)}")
                continue

        if not distance_data:
            logger.warning(f"No valid distance data for {cell_id}/{bait_organelle}")
            return None

        # Evaluate boolean contact patterns
        counts = self._evaluate_contacts(distance_data)

        return counts

    def analyze_bait(self, bait_organelle: str) -> pd.DataFrame:
        """
        Analyze all cells for a specific bait organelle.

        Parameters:
        -----------
        bait_organelle : str
            Bait organelle name

        Returns:
        --------
        pd.DataFrame : Results with rows=cells, columns=[Cell_ID, Surface_count, combos..., No_contact]
        """
        logger.info(f"Analyzing bait: {bait_organelle}")

        # Get cells that have this bait organelle
        cells_with_bait = self.data_loader.get_cells_by_organelle(bait_organelle)
        total_cells = len(cells_with_bait)

        if total_cells == 0:
            logger.warning(f"No cells found with bait organelle: {bait_organelle}")
            return None

        logger.info(f"Found {total_cells} cells with {bait_organelle}")

        # Analyze each cell
        results_list = []
        for idx, cell_id in enumerate(cells_with_bait, 1):
            logger.info(f"[{idx}/{total_cells}] Processing cell: {cell_id}")

            cell_counts = self.analyze_cell_for_bait(cell_id, bait_organelle)

            if cell_counts is not None:
                # Add cell ID as first column
                row = {'Cell_ID': cell_id}
                row.update(cell_counts)
                results_list.append(row)

        if not results_list:
            logger.warning(f"No valid results for bait: {bait_organelle}")
            return None

        # Create DataFrame
        df = pd.DataFrame(results_list)

        # Sort by cell ID (natural sorting)
        sorted_ids = sort_cell_ids(df['Cell_ID'].tolist())
        df['_sort_key'] = df['Cell_ID'].apply(lambda x: sorted_ids.index(x))
        df = df.sort_values('_sort_key').drop('_sort_key', axis=1)
        df = df.reset_index(drop=True)

        logger.info(f"Completed {bait_organelle}: {len(df)} cells, {len(df.columns)-1} columns")

        return df

    def analyze_all_baits(self):
        """
        Analyze all bait organelles.

        If bait_organelles is set, analyzes only those.
        Otherwise, analyzes all organelles (batch mode).
        """
        logger.info("Starting N-Way Interaction Analysis")

        # Determine which baits to analyze
        if self.bait_organelles is not None:
            baits_to_analyze = self.bait_organelles
        else:
            # Batch mode: all organelles
            baits_to_analyze = self.data_loader.all_organelles

        total_baits = len(baits_to_analyze)
        logger.info(f"Analyzing {total_baits} bait organelle(s): {', '.join(baits_to_analyze)}")

        # Analyze each bait
        for idx, bait in enumerate(baits_to_analyze, 1):
            logger.info(f"Bait {idx}/{total_baits}: {bait}")

            result_df = self.analyze_bait(bait)

            if result_df is not None:
                self.results[bait] = result_df

        logger.info(f"\nAnalysis complete. Generated results for {len(self.results)} baits.")

    def _generate_metadata(self, bait: str) -> Dict[str, str]:
        """
        Generate metadata for a specific bait analysis.

        Parameters:
        -----------
        bait : str
            Bait organelle name

        Returns:
        --------
        Dict[str, str] : Metadata dictionary
        """
        # Get target organelles for this bait
        if bait in self.results:
            df = self.results[bait]
            # Columns minus Cell_ID and Surface_count = combination names
            combo_cols = [c for c in df.columns if c not in ['Cell_ID', 'Surface_count']]
            num_combos = len(combo_cols)
        else:
            num_combos = 'N/A'

        metadata = {
            'Software': 'Orgaplex-Analyzer',
            'Version': __version__,
            'Analysis_Type': 'N-Way Interaction Analysis',
            'Bait_Organelle': bait,
            'Contact_Threshold': str(self.threshold),
            'Total_Combinations': str(num_combos),
            'Timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
            'Python_Version': sys.version.split()[0],
            'Pandas_Version': pd.__version__,
            'NumPy_Version': np.__version__,
            'Input_Directory': str(self.input_dir),
            'Total_Cells_Analyzed': str(len(self.results.get(bait, []))),
            'All_Organelles': ', '.join(self.data_loader.all_organelles),
        }

        return metadata

    def export_to_excel(self, output_dir: str) -> List[str]:
        """
        Export results to Excel files (one per bait).

        Parameters:
        -----------
        output_dir : str
            Directory to save output files

        Returns:
        --------
        List[str] : List of created file paths
        """
        if not self.results:
            raise ValueError("No results available. Run analyze_all_baits() first.")

        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        created_files = []

        for bait, df in self.results.items():
            filename = f"nway_analysis_bait-{bait}_{timestamp}.xlsx"
            output_path = output_dir / filename

            logger.info(f"Exporting: {filename}")

            # Generate metadata for this bait
            metadata = self._generate_metadata(bait)

            with pd.ExcelWriter(output_path, engine='openpyxl') as writer:
                # Sheet 1: Results
                df.to_excel(writer, sheet_name='Results', index=False)

                # Sheet 2: Metadata
                metadata_df = pd.DataFrame(
                    list(metadata.items()),
                    columns=['Parameter', 'Value']
                )
                metadata_df.to_excel(writer, sheet_name='Metadata', index=False)

            created_files.append(str(output_path))
            logger.info(f"Saved: {output_path}")

        logger.info(f"Exported {len(created_files)} Excel files to {output_dir}")
        return created_files

    def export_to_csv(self, output_dir: str) -> List[str]:
        """
        Export results to CSV files (one per bait).

        Parameters:
        -----------
        output_dir : str
            Directory to save output files

        Returns:
        --------
        List[str] : List of created file paths
        """
        if not self.results:
            raise ValueError("No results available. Run analyze_all_baits() first.")

        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        created_files = []

        for bait, df in self.results.items():
            # Results file
            results_filename = f"nway_analysis_bait-{bait}_{timestamp}_results.csv"
            results_path = output_dir / results_filename
            df.to_csv(results_path, index=False)
            created_files.append(str(results_path))
            logger.info(f"Saved: {results_filename}")

            # Metadata file
            metadata = self._generate_metadata(bait)
            metadata_filename = f"nway_analysis_bait-{bait}_{timestamp}_metadata.csv"
            metadata_path = output_dir / metadata_filename
            metadata_df = pd.DataFrame(
                list(metadata.items()),
                columns=['Parameter', 'Value']
            )
            metadata_df.to_csv(metadata_path, index=False)
            created_files.append(str(metadata_path))

        logger.info(f"Exported {len(created_files)} CSV files to {output_dir}")
        return created_files

    def run(self, output_dir: str, file_format: str = 'excel') -> List[str]:
        """
        Run the complete analysis pipeline.

        Parameters:
        -----------
        output_dir : str
            Directory for output files
        file_format : str
            Either 'excel' or 'csv'

        Returns:
        --------
        List[str] : Paths to created output files
        """
        logger.info("Starting N-Way Interaction Analysis Pipeline")

        # Step 1: Load data (if not already loaded)
        if not self.data_loader._is_validated:
            self.load_data()

        # Step 2: Analyze all baits
        self.analyze_all_baits()

        # Step 3: Export results
        if file_format == 'excel':
            output_files = self.export_to_excel(output_dir)
        elif file_format == 'csv':
            output_files = self.export_to_csv(output_dir)
        else:
            raise ValueError(f"Unsupported file format: {file_format}")

        logger.info("N-Way Interaction Analysis Complete")
        return output_files

    def get_results_summary(self) -> str:
        """
        Get a summary of analysis results.

        Returns:
        --------
        str : Summary text
        """
        if not self.results:
            return "No results available yet."

        summary = []
        summary.append("N-Way Interaction Analysis Summary")
        summary.append(f"Threshold: <= {self.threshold}")
        summary.append(f"Total baits analyzed: {len(self.results)}")

        for bait, df in self.results.items():
            summary.append(f"\nBait: {bait}")
            summary.append(f"  Cells: {len(df)}")
            summary.append(f"  Columns: {len(df.columns)}")

            # Show total surface counts
            if 'Surface_count' in df.columns:
                total_surfaces = df['Surface_count'].sum()
                summary.append(f"  Total surfaces: {total_surfaces}")

            # Show No_contact percentage
            if 'No_contact' in df.columns and 'Surface_count' in df.columns:
                no_contact_total = df['No_contact'].sum()
                total = df['Surface_count'].sum()
                if total > 0:
                    pct = (no_contact_total / total) * 100
                    summary.append(f"  No contact: {pct:.1f}%")

        return "\n".join(summary)
