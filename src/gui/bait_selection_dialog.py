"""
Bait Selection Dialog for N-Way Analysis

This module provides a modal dialog for selecting bait organelle(s)
after data has been loaded and organelles detected.

The dialog shows all available organelles from the dataset and allows
the user to select one or more baits for analysis.

Author: Philipp Kaintoch
Date: 2025-11-18
Version: 2.2.0
"""

import tkinter as tk
from tkinter import ttk
from typing import List, Optional


class BaitSelectionDialog:
    """
    Modal dialog for selecting bait organelle(s).

    Usage:
    ------
    dialog = BaitSelectionDialog(parent, available_organelles)
    parent.wait_window(dialog.dialog)

    if dialog.result:
        selected_baits = dialog.result  # List of selected organelle names
    else:
        # User cancelled
    """

    def __init__(self, parent: tk.Tk, available_organelles: List[str]):
        """
        Create and show the bait selection dialog.

        Parameters:
        -----------
        parent : tk.Tk
            Parent window
        available_organelles : List[str]
            List of organelle names to choose from
        """
        self.parent = parent
        self.available_organelles = sorted(available_organelles)
        self.result = None  # Will hold List[str] of selected baits or None

        self._create_dialog()

    def _create_dialog(self):
        """Create the dialog window and widgets."""
        # Create toplevel window
        self.dialog = tk.Toplevel(self.parent)
        self.dialog.title("Select Bait Organelle")
        self.dialog.geometry("350x400")
        self.dialog.resizable(False, False)

        # Make modal (blocks interaction with parent)
        self.dialog.transient(self.parent)
        self.dialog.grab_set()

        # Center the dialog on parent
        self._center_dialog()

        # Main container
        main_frame = ttk.Frame(self.dialog, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)

        # Title label
        title_label = ttk.Label(
            main_frame,
            text="Select Bait Organelle",
            font=('Arial', 12, 'bold')
        )
        title_label.pack(pady=(0, 10))

        # Instructions
        instructions = ttk.Label(
            main_frame,
            text="Choose the organelle to use as bait.\n"
                 "The analysis will count contacts between\n"
                 "the bait and all other organelles.",
            font=('Arial', 9),
            justify=tk.CENTER
        )
        instructions.pack(pady=(0, 15))

        # Organelle selection frame
        selection_frame = ttk.LabelFrame(
            main_frame,
            text="Available Organelles",
            padding="10"
        )
        selection_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 15))

        # Selection variable
        self.selection_var = tk.StringVar()

        # Create radio button for each organelle
        for organelle in self.available_organelles:
            radio = ttk.Radiobutton(
                selection_frame,
                text=organelle,
                variable=self.selection_var,
                value=organelle
            )
            radio.pack(anchor=tk.W, pady=2)

        # Select first organelle by default
        if self.available_organelles:
            self.selection_var.set(self.available_organelles[0])

        # Info about number of combinations
        n_targets = len(self.available_organelles) - 1
        if n_targets > 0:
            n_combos = 2 ** n_targets
            info_text = f"With {n_targets} target organelles, this will generate\n{n_combos} boolean combinations + 'No_contact'"
        else:
            info_text = "At least 2 organelles required for analysis"

        info_label = ttk.Label(
            main_frame,
            text=info_text,
            font=('Arial', 8),
            foreground='#666666',
            justify=tk.CENTER
        )
        info_label.pack(pady=(0, 10))

        # Button frame
        button_frame = ttk.Frame(main_frame)
        button_frame.pack(fill=tk.X)

        # Cancel button
        cancel_btn = ttk.Button(
            button_frame,
            text="Cancel",
            command=self._on_cancel,
            width=12
        )
        cancel_btn.pack(side=tk.LEFT, padx=(0, 10))

        # OK button
        ok_btn = ttk.Button(
            button_frame,
            text="Analyze",
            command=self._on_ok,
            width=12
        )
        ok_btn.pack(side=tk.RIGHT)

        # Bind Enter key to OK and Escape to Cancel
        self.dialog.bind('<Return>', lambda e: self._on_ok())
        self.dialog.bind('<Escape>', lambda e: self._on_cancel())

        # Handle window close button
        self.dialog.protocol("WM_DELETE_WINDOW", self._on_cancel)

    def _center_dialog(self):
        """Center the dialog on the parent window."""
        self.dialog.update_idletasks()

        # Get parent position and size
        parent_x = self.parent.winfo_x()
        parent_y = self.parent.winfo_y()
        parent_width = self.parent.winfo_width()
        parent_height = self.parent.winfo_height()

        # Get dialog size
        dialog_width = self.dialog.winfo_width()
        dialog_height = self.dialog.winfo_height()

        # Calculate position
        x = parent_x + (parent_width - dialog_width) // 2
        y = parent_y + (parent_height - dialog_height) // 2

        self.dialog.geometry(f"+{x}+{y}")

    def _on_ok(self):
        """Handle OK button click."""
        selected = self.selection_var.get()

        if selected:
            self.result = [selected]  # Return as list for consistency
        else:
            self.result = None

        self.dialog.destroy()

    def _on_cancel(self):
        """Handle Cancel button click."""
        self.result = None
        self.dialog.destroy()


class BatchBaitDialog:
    """
    Simplified dialog for batch mode - shows info and confirms.

    This dialog appears when user selects batch mode to confirm
    they want to analyze all organelles as baits.
    """

    def __init__(self, parent: tk.Tk, available_organelles: List[str]):
        """
        Create batch confirmation dialog.

        Parameters:
        -----------
        parent : tk.Tk
            Parent window
        available_organelles : List[str]
            List of all organelles to be analyzed
        """
        self.parent = parent
        self.available_organelles = sorted(available_organelles)
        self.confirmed = False

        self._create_dialog()

    def _create_dialog(self):
        """Create the dialog window."""
        self.dialog = tk.Toplevel(self.parent)
        self.dialog.title("Batch Analysis Confirmation")
        self.dialog.geometry("400x300")
        self.dialog.resizable(False, False)

        # Make modal
        self.dialog.transient(self.parent)
        self.dialog.grab_set()

        # Center dialog
        self.dialog.update_idletasks()
        parent_x = self.parent.winfo_x()
        parent_y = self.parent.winfo_y()
        parent_width = self.parent.winfo_width()
        parent_height = self.parent.winfo_height()
        dialog_width = self.dialog.winfo_width()
        dialog_height = self.dialog.winfo_height()
        x = parent_x + (parent_width - dialog_width) // 2
        y = parent_y + (parent_height - dialog_height) // 2
        self.dialog.geometry(f"+{x}+{y}")

        # Main frame
        main_frame = ttk.Frame(self.dialog, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)

        # Title
        title = ttk.Label(
            main_frame,
            text="Batch N-Way Analysis",
            font=('Arial', 12, 'bold')
        )
        title.pack(pady=(0, 15))

        # Info text
        n_organelles = len(self.available_organelles)
        n_targets = n_organelles - 1
        n_combos = 2 ** n_targets if n_targets > 0 else 0

        info_text = (
            f"This will analyze each of the {n_organelles} organelles as bait:\n\n"
            f"{', '.join(self.available_organelles)}\n\n"
            f"For each bait, {n_combos} boolean combinations\n"
            f"will be evaluated.\n\n"
            f"Output: {n_organelles} Excel files (one per bait)"
        )

        info_label = ttk.Label(
            main_frame,
            text=info_text,
            font=('Arial', 10),
            justify=tk.CENTER
        )
        info_label.pack(pady=(0, 20))

        # Button frame
        button_frame = ttk.Frame(main_frame)
        button_frame.pack(fill=tk.X)

        cancel_btn = ttk.Button(
            button_frame,
            text="Cancel",
            command=self._on_cancel,
            width=12
        )
        cancel_btn.pack(side=tk.LEFT)

        ok_btn = ttk.Button(
            button_frame,
            text="Start Analysis",
            command=self._on_ok,
            width=15
        )
        ok_btn.pack(side=tk.RIGHT)

        self.dialog.bind('<Return>', lambda e: self._on_ok())
        self.dialog.bind('<Escape>', lambda e: self._on_cancel())
        self.dialog.protocol("WM_DELETE_WINDOW", self._on_cancel)

    def _on_ok(self):
        """Handle OK click."""
        self.confirmed = True
        self.dialog.destroy()

    def _on_cancel(self):
        """Handle Cancel click."""
        self.confirmed = False
        self.dialog.destroy()
