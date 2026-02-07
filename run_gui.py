"""
GUI Launcher for Organelle Analysis Software

USAGE:
    python run_gui.py

Author: Philipp Kaintoch
"""

import sys
from pathlib import Path

# Add src directory to path
sys.path.insert(0, str(Path(__file__).parent))

from src.gui.main_window import launch_gui

if __name__ == "__main__":
    launch_gui()
