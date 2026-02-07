"""
Visualization utilities for Orgaplex-Analyzer output files.

Provides loading and rendering functions for publication-quality figures.

Author: Philipp Kaintoch
"""

import re
import numpy as np
import pandas as pd
from pathlib import Path
from typing import List, Optional


def load_radial_output(file_path: str) -> dict:
    """Load a Radial Distribution Excel output and return parsed data dict."""
    file_path = Path(file_path)
    if not file_path.exists():
        raise FileNotFoundError(f"File not found: {file_path}")

    xls = pd.ExcelFile(file_path, engine='openpyxl')

    if 'Summary' not in xls.sheet_names:
        raise ValueError(f"Missing 'Summary' sheet in {file_path.name}")
    if 'Metadata' not in xls.sheet_names:
        raise ValueError(f"Missing 'Metadata' sheet in {file_path.name}")

    meta_df = pd.read_excel(xls, sheet_name='Metadata')
    meta = dict(zip(meta_df['Parameter'], meta_df['Value']))

    for key in ('Organelle', 'Bin_Width_um', 'Max_Distance_um', 'Total_Bins'):
        if key not in meta:
            raise ValueError(f"Missing metadata key '{key}' in {file_path.name}")

    summary_df = pd.read_excel(xls, sheet_name='Summary', index_col=0)
    if 'Mean' not in summary_df.columns:
        raise ValueError(f"Missing 'Mean' column in Summary sheet of {file_path.name}")

    mean_values = summary_df['Mean'].values.astype(float)
    mean_values = np.nan_to_num(mean_values, nan=0.0)

    bin_edges = [0.0]
    for interval_str in summary_df.index:
        m = re.search(r',\s*([\d.]+)\]', str(interval_str))
        if m:
            bin_edges.append(float(m.group(1)))
        else:
            bin_edges.append(bin_edges[-1] + float(meta['Bin_Width_um']))
    bin_edges = np.array(bin_edges)

    return {
        'organelle': str(meta['Organelle']),
        'bin_width': float(meta['Bin_Width_um']),
        'max_distance': float(meta['Max_Distance_um']),
        'n_bins': int(meta['Total_Bins']),
        'mean_values': mean_values,
        'bin_edges': bin_edges,
    }


def generate_radial_heatmap(
    datasets: List[dict],
    output_path: str,
    condition_label: str = "",
    dpi: int = 300,
    ref_line_spacing: float = 20.0,
):
    """Render a stacked radial distribution heatmap and save to file."""
    if not datasets:
        raise ValueError("At least one dataset is required")

    organelles = [d['organelle'] for d in datasets]
    if len(organelles) != len(set(organelles)):
        raise ValueError(f"Duplicate organelles: {organelles}")

    ref_bw = datasets[0]['bin_width']
    ref_md = datasets[0]['max_distance']
    ref_nb = datasets[0]['n_bins']
    for d in datasets[1:]:
        if d['bin_width'] != ref_bw or d['max_distance'] != ref_md or d['n_bins'] != ref_nb:
            raise ValueError(
                f"Bin mismatch: {d['organelle']} has bin_width={d['bin_width']}, "
                f"max_distance={d['max_distance']}, n_bins={d['n_bins']} "
                f"(expected {ref_bw}, {ref_md}, {ref_nb})"
            )

    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt

    plt.rcParams['font.family'] = 'sans-serif'
    plt.rcParams['font.sans-serif'] = ['Arial']
    plt.rcParams['pdf.fonttype'] = 42

    n = len(datasets)
    fig_width = 7.0
    stripe_height = 0.25
    gap = 0.06
    bottom_margin = 0.5
    top_margin = 0.15
    left_margin = 0.12
    right_margin = 0.12
    label_margin = 0.06

    fig_height = top_margin + n * stripe_height + (n - 1) * gap + bottom_margin
    fig = plt.figure(figsize=(fig_width, fig_height))

    plot_left = (left_margin + label_margin) / fig_width
    plot_width = 1.0 - plot_left - right_margin / fig_width

    axes = []
    for i, d in enumerate(datasets):
        y_bottom = (bottom_margin + (n - 1 - i) * (stripe_height + gap)) / fig_height
        h = stripe_height / fig_height

        ax = fig.add_axes([plot_left, y_bottom, plot_width, h])

        vals = d['mean_values'].copy()
        vmax = vals.max()
        if vmax > 0:
            vals = vals / vmax

        data_2d = vals.reshape(1, -1)
        ax.imshow(
            data_2d, cmap='hot', interpolation='bilinear', aspect='auto',
            vmin=0, vmax=1, extent=[0, ref_md, 0, 1],
        )

        if ref_line_spacing > 0:
            x = ref_line_spacing
            while x < ref_md:
                ax.axvline(x, color='white', ls='--', lw=0.7, alpha=0.7)
                x += ref_line_spacing

        ax.text(
            ref_md + ref_md * 0.015, 0.5, d['organelle'],
            va='center', ha='left', fontsize=10, fontweight='bold',
            transform=ax.transData,
        )

        ax.set_yticks([])
        for spine in ax.spines.values():
            spine.set_visible(False)

        if i == n - 1:
            ax.tick_params(axis='x', labelsize=8)
            ax.spines['bottom'].set_visible(True)
            ax.set_xlabel('Distance from cell center (\u00b5m)', fontsize=10)
        else:
            ax.set_xticks([])

        axes.append(ax)

    if condition_label:
        label_x = left_margin * 0.4 / fig_width
        label_y = (bottom_margin + n * stripe_height / 2 + (n - 1) * gap / 2) / fig_height
        fig.text(
            label_x, label_y, condition_label,
            rotation=90, va='center', ha='center', fontsize=12,
        )

    fig.savefig(output_path, dpi=dpi, bbox_inches='tight', pad_inches=0.1)
    plt.close(fig)
