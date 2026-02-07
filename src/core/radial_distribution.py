"""
Radial Distribution Analysis Module

Analyzes the radial volume distribution of organelles relative to the cell
center using distance-from-origin measurements from Imaris.

Author: Philipp Kaintoch
"""

import pandas as pd
import numpy as np
from pathlib import Path
from typing import Dict, List, Optional
from .data_loader import DataLoader
from ..utils.logging_config import get_logger
from ..utils.sorting import sort_cell_ids
from ..utils.metadata import generate_base_metadata

logger = get_logger(__name__)


class RadialDistributionAnalyzer:
    """
    Analyzes radial volume distribution of organelles from cell center.

    For a selected organelle, loads volume and distance-from-origin data
    per surface object, bins distances, and sums volume per bin to produce
    a radial volume profile per cell.

    Output Format:
    --------------
    Excel file with sheets:
    - Per_Cell_Data: Rows = distance bins, Columns = cells
    - Summary: Mean +/- SD across cells per bin
    - Metadata: Analysis provenance
    """

    def __init__(self, input_dir: str):
        self.input_dir = Path(input_dir)
        if not self.input_dir.exists():
            raise FileNotFoundError(f"Input directory does not exist: {self.input_dir}")

        self.data_loader = DataLoader(input_dir)
        self.organelle = None
        self.bin_width = 0.25
        self.max_distance = 80.0
        self.results = {}
        self.per_cell_df = None
        self.summary_df = None
        self.metadata = {}

    def load_data(self):
        logger.info("Loading data...")
        self.data_loader.detect_structure()
        self.data_loader.find_cell_folders()

        summary = self.data_loader.get_summary()
        for line in summary.split('\n'):
            if line.strip():
                logger.info(line)

    def get_available_organelles(self) -> List[str]:
        return self.data_loader.all_organelles

    def set_parameters(self, organelle: str, bin_width: float, max_distance: float):
        if self.data_loader.all_organelles and organelle not in self.data_loader.all_organelles:
            raise ValueError(f"Organelle '{organelle}' not found. Available: {', '.join(self.data_loader.all_organelles)}")
        if bin_width <= 0:
            raise ValueError(f"Bin width must be positive, got {bin_width}")
        if max_distance <= 0:
            raise ValueError(f"Max distance must be positive, got {max_distance}")
        if max_distance <= bin_width:
            raise ValueError(f"Max distance ({max_distance}) must be greater than bin width ({bin_width})")

        self.organelle = organelle
        self.bin_width = bin_width
        self.max_distance = max_distance

    def load_metric_file(self, file_path: Path, metric_name: str) -> pd.Series:
        """
        Load a Volume or Distance CSV file from Imaris.

        Returns raw Series WITHOUT dropna to preserve row alignment for pairing.
        """
        try:
            df = pd.read_csv(file_path, skiprows=4, header=None, encoding='utf-8')

            if df.shape[1] < 1:
                raise ValueError(f"File has no columns: {file_path.name}")
            if df.shape[0] < 1:
                raise ValueError(f"File has no data rows: {file_path.name}")

            values = df.iloc[:, 0]

            if values.dropna().empty:
                raise ValueError(f"No valid {metric_name} values in {file_path.name}")
            if not pd.api.types.is_numeric_dtype(values):
                raise ValueError(f"{metric_name} data is not numeric in {file_path.name}")
            if np.isinf(values).any():
                raise ValueError(f"Infinite {metric_name} values found in {file_path.name}")

            if metric_name == "Volume":
                non_nan = values.dropna()
                if (non_nan < 0).any():
                    raise ValueError(f"Negative volume values found in {file_path.name}")

            return values

        except pd.errors.EmptyDataError:
            raise ValueError(f"File is empty or has no data: {file_path.name}")
        except Exception as e:
            if isinstance(e, ValueError):
                raise
            raise IOError(f"Failed to read {file_path.name}: {e}")

    def analyze_cell(self, cell_id: str) -> Optional[pd.Series]:
        folder = self.data_loader.get_folder_path(cell_id, self.organelle)
        if folder is None:
            return None

        vol_file = folder / f"{cell_id}_{self.organelle}_Volume.csv"
        dist_file = folder / f"{cell_id}_{self.organelle}_Distance_from_Origin_Reference_Frame.csv"

        if not vol_file.exists() or not dist_file.exists():
            logger.warning(f"Missing file(s) for {cell_id} ({self.organelle})")
            return None

        try:
            volumes = self.load_metric_file(vol_file, "Volume")
            distances = self.load_metric_file(dist_file, "Distance")
        except Exception as e:
            logger.error(f"Failed to load data for {cell_id}: {e}")
            return None

        if len(volumes) != len(distances):
            logger.warning(f"Row mismatch for {cell_id}: Vol={len(volumes)}, Dist={len(distances)}")
            return None

        df = pd.DataFrame({'Vol': volumes.values, 'Dist': distances.values})
        df = df.dropna(subset=['Vol', 'Dist'])

        if df.empty:
            logger.warning(f"No valid data after NaN removal for {cell_id}")
            return None

        n_bins = round(self.max_distance / self.bin_width)
        bin_edges = np.linspace(0, self.max_distance, n_bins + 1)

        df['Dist_bin'] = pd.cut(df['Dist'], bins=bin_edges, include_lowest=True)

        n_unbinned = df['Dist_bin'].isna().sum()
        if n_unbinned > 0:
            logger.warning(f"{n_unbinned} surfaces outside bin range in {cell_id}")

        binned = df.groupby('Dist_bin', observed=False)['Vol'].sum()
        return binned

    def analyze(self) -> pd.DataFrame:
        if self.organelle is None:
            raise ValueError("Must call set_parameters() before analyze()")
        if self.data_loader.all_organelles and self.organelle not in self.data_loader.all_organelles:
            raise ValueError(f"Organelle '{self.organelle}' not found. Available: {', '.join(self.data_loader.all_organelles)}")

        cells = self.data_loader.get_cells_by_organelle(self.organelle)
        if not cells:
            raise ValueError(f"No cells found for organelle: {self.organelle}")

        logger.info(f"Analyzing {len(cells)} cells for {self.organelle}")

        for cell_id in cells:
            profile = self.analyze_cell(cell_id)
            if profile is not None:
                self.results[cell_id] = profile

        if not self.results:
            raise ValueError(f"No valid data for {self.organelle}")

        self.per_cell_df = pd.DataFrame(self.results)
        sorted_cols = sort_cell_ids(list(self.per_cell_df.columns))
        self.per_cell_df = self.per_cell_df[sorted_cols]

        self.summary_df = pd.DataFrame({
            'Mean': self.per_cell_df.mean(axis=1),
            'SD': self.per_cell_df.std(axis=1, ddof=1),
        })

        logger.info(f"Processed {len(self.results)} cells, {len(self.per_cell_df)} bins")
        return self.per_cell_df

    def run(self, output_path: str, file_format: str = 'excel'):
        logger.info("Starting Radial Distribution Analysis")
        logger.info(f"Input directory: {self.input_dir}")

        self.load_data()

        if self.organelle is None:
            raise ValueError("Must call set_parameters() before run()")

        logger.info(f"Organelle: {self.organelle}")
        logger.info(f"Binning: {self.bin_width} um steps, 0 - {self.max_distance} um")

        self.analyze()

        if file_format == 'excel':
            self._save_excel(output_path)
        else:
            self._save_csv(output_path)

        logger.info(f"Results saved to: {output_path}")
        logger.info("Analysis Complete")

    def _generate_metadata(self) -> dict:
        n_bins = round(self.max_distance / self.bin_width)
        metadata = generate_base_metadata(
            input_dir=self.input_dir,
            analysis_type='Radial Distribution',
            Organelle=self.organelle,
            Bin_Width_um=str(self.bin_width),
            Max_Distance_um=str(self.max_distance),
            Total_Bins=str(n_bins),
            Cells_Analyzed=str(len(self.results)),
        )
        self.metadata = metadata
        return metadata

    def _save_excel(self, output_path: str):
        with pd.ExcelWriter(output_path, engine='openpyxl') as writer:
            per_cell_export = self.per_cell_df.copy()
            per_cell_export.index = per_cell_export.index.astype(str)
            per_cell_export.to_excel(writer, sheet_name='Per_Cell_Data', index=True)

            summary_export = self.summary_df.copy()
            summary_export.index = summary_export.index.astype(str)
            summary_export.to_excel(writer, sheet_name='Summary', index=True)

            metadata = self._generate_metadata()
            metadata_df = pd.DataFrame(list(metadata.items()), columns=['Parameter', 'Value'])
            metadata_df.to_excel(writer, sheet_name='Metadata', index=False)

        logger.info(f"Saved radial distribution to Excel: {output_path}")

    def _save_csv(self, output_dir: str):
        output_path = Path(output_dir)
        output_path.mkdir(parents=True, exist_ok=True)

        per_cell_export = self.per_cell_df.copy()
        per_cell_export.index = per_cell_export.index.astype(str)
        per_cell_export.to_csv(output_path / f"radial_distribution_{self.organelle}_per_cell.csv", index=True)

        summary_export = self.summary_df.copy()
        summary_export.index = summary_export.index.astype(str)
        summary_export.to_csv(output_path / f"radial_distribution_{self.organelle}_summary.csv", index=True)

        metadata = self._generate_metadata()
        metadata_df = pd.DataFrame(list(metadata.items()), columns=['Parameter', 'Value'])
        metadata_df.to_csv(output_path / f"radial_distribution_{self.organelle}_metadata.csv", index=False)

        logger.info(f"Saved radial distribution CSVs to {output_dir}")

    def get_results_summary(self) -> str:
        if not self.results:
            return "No results available"

        n_bins = round(self.max_distance / self.bin_width)
        summary = [
            "Radial Distribution Analysis Summary",
            f"  Organelle: {self.organelle}",
            f"  Cells analyzed: {len(self.results)}",
            f"  Bins: {n_bins} ({self.bin_width} um steps, 0 - {self.max_distance} um)",
        ]
        return "\n".join(summary)
