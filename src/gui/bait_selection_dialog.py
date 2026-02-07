"""
Bait Selection Dialog for N-Way Analysis

Modal dialog for selecting a bait organelle after data has been loaded
and organelles detected.

Author: Philipp Kaintoch
Date: 2025-11-18
"""

import tkinter as tk
from tkinter import ttk
from typing import List


class BaitSelectionDialog:
    """
    Modal dialog for selecting a bait organelle.

    Usage:
        dialog = BaitSelectionDialog(parent, available_organelles)
        parent.wait_window(dialog.dialog)

        if dialog.result:
            selected_baits = dialog.result
    """

    def __init__(self, parent: tk.Tk, available_organelles: List[str]):
        self.parent = parent
        self.available_organelles = sorted(available_organelles)
        self.result = None
        self._create_dialog()

    def _create_dialog(self):
        self.dialog = tk.Toplevel(self.parent)
        self.dialog.title("Select Bait Organelle")
        self.dialog.geometry("350x400")
        self.dialog.resizable(False, False)

        self.dialog.transient(self.parent)
        self.dialog.grab_set()
        self._center_dialog()

        main_frame = ttk.Frame(self.dialog, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)

        ttk.Label(
            main_frame, text="Select Bait Organelle",
            font=('Arial', 12, 'bold')
        ).pack(pady=(0, 10))

        ttk.Label(
            main_frame,
            text="Choose the organelle to use as bait.\n"
                 "The analysis will count contacts between\n"
                 "the bait and all other organelles.",
            font=('Arial', 9),
            justify=tk.CENTER
        ).pack(pady=(0, 15))

        selection_frame = ttk.LabelFrame(main_frame, text="Available Organelles", padding="10")
        selection_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 15))

        self.selection_var = tk.StringVar()

        for organelle in self.available_organelles:
            ttk.Radiobutton(
                selection_frame, text=organelle,
                variable=self.selection_var, value=organelle
            ).pack(anchor=tk.W, pady=2)

        if self.available_organelles:
            self.selection_var.set(self.available_organelles[0])

        n_targets = len(self.available_organelles) - 1
        if n_targets > 0:
            n_combos = 2 ** n_targets
            info_text = f"With {n_targets} target organelles, this will generate\n{n_combos} boolean combinations + 'No_contact'"
        else:
            info_text = "At least 2 organelles required for analysis"

        ttk.Label(
            main_frame, text=info_text, font=('Arial', 8),
            foreground='#666666', justify=tk.CENTER
        ).pack(pady=(0, 10))

        button_frame = ttk.Frame(main_frame)
        button_frame.pack(fill=tk.X)

        ttk.Button(button_frame, text="Cancel", command=self._on_cancel, width=12).pack(
            side=tk.LEFT, padx=(0, 10))
        ttk.Button(button_frame, text="Analyze", command=self._on_ok, width=12).pack(
            side=tk.RIGHT)

        self.dialog.bind('<Return>', lambda e: self._on_ok())
        self.dialog.bind('<Escape>', lambda e: self._on_cancel())
        self.dialog.protocol("WM_DELETE_WINDOW", self._on_cancel)

    def _center_dialog(self):
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

    def _on_ok(self):
        selected = self.selection_var.get()
        self.result = [selected] if selected else None
        self.dialog.destroy()

    def _on_cancel(self):
        self.result = None
        self.dialog.destroy()
