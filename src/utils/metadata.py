"""
Shared metadata generation for analysis provenance.
"""

import sys
from datetime import datetime
import pandas as pd
import numpy as np
from ..__version__ import __version__


def generate_base_metadata(input_dir: str, analysis_type: str, **extra) -> dict:
    """
    Generate standard metadata dict for any analysis module.

    Parameters:
    -----------
    input_dir : str
        Path to the input data directory
    analysis_type : str
        Name of the analysis (e.g., "One-Way Interaction Analysis")
    **extra :
        Additional key-value pairs to include in the metadata

    Returns:
    --------
    dict : Ordered metadata dictionary
    """
    metadata = {
        'Software': 'Orgaplex-Analyzer',
        'Version': __version__,
        'Analysis_Type': analysis_type,
        'Timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'Python_Version': sys.version.split()[0],
        'Pandas_Version': pd.__version__,
        'NumPy_Version': np.__version__,
        'Input_Directory': str(input_dir),
    }
    metadata.update(extra)
    return metadata
