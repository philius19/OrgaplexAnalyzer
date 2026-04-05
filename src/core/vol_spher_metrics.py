"""
Morphology Metrics Analysis Module

Analyzes volume, sphericity, and area statistics for organelles from Imaris-generated
CSV files.

Author: Philipp Kaintoch
Date: 2025-11-18
"""

import pandas as pd
import numpy as np
from pathlib import Path
from typing import Dict
from .data_loader import DataLoader
from ..utils.logging_config import get_logger
from ..utils.sorting import sort_cell_ids
from ..utils.metadata import generate_base_metadata

logger = get_logger(__name__)


class MorphologyMetricsAnalyzer:
    """
    Analyzes volume and sphericity metrics from Imaris CSV exports.

    Output Format:
    --------------
    Excel file with one sheet per organelle:
    - Rows: Metrics (Mean_Sphericity, Count_Sphericity, Mean_Volume, Count_Volume, Total_Volume, Max_Volume, Mean_Area, Count_Area, Total_Area, Max_Area)
    - Columns: Cells (numerically sorted)
    """

    def __init__(self, input_dir: str):
        self.input_dir = Path(input_dir)
        if not self.input_dir.exists():
            raise FileNotFoundError(f"Input directory does not exist: {self.input_dir}")

        self.data_loader = DataLoader(input_dir)
        self.results = {}
        self.metadata = {}

    def load_data(self):
        """Load and validate data using DataLoader."""
        logger.info("Loading data...")
        self.data_loader.detect_structure()
        self.data_loader.find_cell_folders()

        summary = self.data_loader.get_summary()
        for line in summary.split('\n'):
            if line.strip():
                logger.info(line)

    def analyze_organelle(self, organelle: str) -> pd.DataFrame:
        """
        Analyze all cells for a specific organelle.

        Returns DataFrame with metrics as rows, cells as columns.
        """
        cells = self.data_loader.get_cells_by_organelle(organelle)

        if not cells:
            logger.warning(f"No cells found for organelle: {organelle}")
            return pd.DataFrame()

        logger.info(f"Found {len(cells)} cells for {organelle}")

        results_dict = {}

        for cell_id in cells:
            folder = self.data_loader.get_folder_path(cell_id, organelle)
            if folder is None:
                continue

            volume_file = folder / f"{cell_id}_{organelle}_Volume.csv"
            sphericity_file = folder / f"{cell_id}_{organelle}_Sphericity.csv"
            area_file = folder / f"{cell_id}_{organelle}_Area.csv"

            cell_metrics = {}

            # Volume metrics
            if volume_file.exists():
                try:
                    volumes = self.data_loader.load_metric_file(volume_file, "Volume")
                    cell_metrics['Mean_Volume'] = volumes.mean()
                    cell_metrics['Count_Volume'] = len(volumes)
                    cell_metrics['Total_Volume'] = volumes.sum()
                    cell_metrics['Max_Volume'] = volumes.max()
                except Exception as e:
                    logger.error(f"Failed to process {volume_file.name}: {e}")
                    cell_metrics['Mean_Volume'] = np.nan
                    cell_metrics['Count_Volume'] = 0
                    cell_metrics['Total_Volume'] = np.nan
                    cell_metrics['Max_Volume'] = np.nan
            else:
                logger.warning(f"Missing volume file for {cell_id} ({organelle})")
                cell_metrics['Mean_Volume'] = np.nan
                cell_metrics['Count_Volume'] = 0
                cell_metrics['Total_Volume'] = np.nan
                cell_metrics['Max_Volume'] = np.nan

            # Sphericity metrics
            if sphericity_file.exists():
                try:
                    sphericity = self.data_loader.load_metric_file(sphericity_file, "Sphericity")
                    cell_metrics['Mean_Sphericity'] = sphericity.mean()
                    cell_metrics['Count_Sphericity'] = len(sphericity)
                except Exception as e:
                    logger.error(f"Failed to process {sphericity_file.name}: {e}")
                    cell_metrics['Mean_Sphericity'] = np.nan
                    cell_metrics['Count_Sphericity'] = 0
            else:
                logger.warning(f"Missing sphericity file for {cell_id} ({organelle})")
                cell_metrics['Mean_Sphericity'] = np.nan
                cell_metrics['Count_Sphericity'] = 0

            # Area metrics
            if area_file.exists():
                try:
                    areas = self.data_loader.load_metric_file(area_file, "Area")
                    cell_metrics['Mean_Area'] = areas.mean()
                    cell_metrics['Count_Area'] = len(areas)
                    cell_metrics['Total_Area'] = areas.sum()
                    cell_metrics['Max_Area'] = areas.max()
                except Exception as e:
                    logger.error(f"Failed to process {area_file.name}: {e}")
                    cell_metrics['Mean_Area'] = np.nan
                    cell_metrics['Count_Area'] = 0
                    cell_metrics['Total_Area'] = np.nan
                    cell_metrics['Max_Area'] = np.nan
            else:
                logger.warning(f"Missing area file for {cell_id} ({organelle})")
                cell_metrics['Mean_Area'] = np.nan
                cell_metrics['Count_Area'] = 0
                cell_metrics['Total_Area'] = np.nan
                cell_metrics['Max_Area'] = np.nan

            results_dict[cell_id] = cell_metrics

        df = pd.DataFrame(results_dict)

        if not df.empty:
            df = df[sort_cell_ids(list(df.columns))]
            row_order = [
                'Mean_Sphericity', 'Count_Sphericity',
                'Mean_Volume', 'Count_Volume', 'Total_Volume', 'Max_Volume',
                'Mean_Area', 'Count_Area', 'Total_Area', 'Max_Area'
            ]
            df = df.reindex(row_order)

        return df

    def run(self, output_path: str, file_format: str = 'excel'):
        """Run the analysis for all organelles."""
        logger.info("Starting Morphology Metrics Analysis")
        logger.info(f"Input directory: {self.input_dir}")

        self.load_data()

        organelles = self.data_loader.all_organelles
        logger.info(f"Found {len(organelles)} organelles: {', '.join(organelles)}")

        if not organelles:
            raise ValueError("No organelles detected")

        for organelle in organelles:
            logger.info(f"Analyzing organelle: {organelle}")
            df = self.analyze_organelle(organelle)

            if not df.empty:
                self.results[organelle] = df
                logger.info(f"  Processed {df.shape[1]} cells")
            else:
                logger.warning(f"  No data for {organelle}")

        if not self.results:
            raise ValueError("No data was successfully processed")

        if file_format == 'excel':
            self._save_excel(output_path)
        else:
            self._save_csv(output_path)

        logger.info(f"Results saved to: {output_path}")
        logger.info("Analysis Complete")

    def _generate_metadata(self) -> dict:
        # Collect which metrics were actually computed from the first result
        metrics_list = []
        if self.results:
            first_df = next(iter(self.results.values()))
            metrics_list = first_df.index.tolist()

        metadata = generate_base_metadata(
            input_dir=self.input_dir,
            analysis_type='Morphology Metrics',
            Organelles_Analyzed=', '.join(sorted(self.results.keys())),
            Total_Cells=str(max(df.shape[1] for df in self.results.values()) if self.results else 0),
            Metrics_Computed=', '.join(metrics_list),
        )
        self.metadata = metadata
        return metadata

    def _save_excel(self, output_path: str):
        with pd.ExcelWriter(output_path, engine='openpyxl') as writer:
            for organelle, df in self.results.items():
                df.to_excel(writer, sheet_name=organelle, index=True)

            metadata = self._generate_metadata()
            metadata_df = pd.DataFrame(list(metadata.items()), columns=['Parameter', 'Value'])
            metadata_df.to_excel(writer, sheet_name='Metadata', index=False)

            exclusions_df = self.data_loader.get_exclusions_df()
            exclusions_df.to_excel(writer, sheet_name='Exclusions', index=False)

        logger.info(f"Saved {len(self.results)} organelle sheets to Excel")

    def _save_csv(self, output_dir: str):
        output_path = Path(output_dir)
        output_path.mkdir(parents=True, exist_ok=True)

        for organelle, df in self.results.items():
            csv_path = output_path / f"morphology_metrics_{organelle}.csv"
            df.to_csv(csv_path, index=True)

        metadata = self._generate_metadata()
        metadata_df = pd.DataFrame(list(metadata.items()), columns=['Parameter', 'Value'])
        metadata_path = output_path / "morphology_metrics_metadata.csv"
        metadata_df.to_csv(metadata_path, index=False)

        exclusions_df = self.data_loader.get_exclusions_df()
        exclusions_path = output_path / "morphology_metrics_exclusions.csv"
        exclusions_df.to_csv(exclusions_path, index=False)

        logger.info(f"Saved {len(self.results)} organelle CSVs to {output_dir}")

    def get_results_summary(self) -> str:
        if not self.results:
            return "No results available"

        summary = ["Morphology Metrics Analysis Summary"]
        for organelle, df in self.results.items():
            summary.append(f"\n{organelle}:")
            summary.append(f"  Cells analyzed: {df.shape[1]}")
            summary.append(f"  Metrics: {', '.join(df.index.tolist())}")

        return "\n".join(summary)
