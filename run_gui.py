"""
GUI Launcher for Organelle Analysis Software

This script launches the graphical user interface for the organelle analysis software.

USAGE:
    python run_gui.py

Or make it executable and run directly:
    chmod +x run_gui.py
    ./run_gui.py

Author: Philipp Kaintoch
Date: 2026-02-01
Version: 3.0.0
"""

import sys
from pathlib import Path

# Add src directory to path
sys.path.insert(0, str(Path(__file__).parent))

from src.gui.main_window import launch_gui

if __name__ == "__main__":
    launch_gui()
