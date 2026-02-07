"""
Radial Distribution Configuration Dialog

Modal dialog for selecting an organelle and configuring binning parameters
for radial distribution analysis.

Author: Philipp Kaintoch
"""

import tkinter as tk
from tkinter import ttk, messagebox
from typing import List, Optional, Tuple


class RadialDistributionDialog:
    """
    Modal dialog for configuring radial distribution analysis.

    Usage:
        dialog = RadialDistributionDialog(parent, available_organelles)
        parent.wait_window(dialog.dialog)

        if dialog.result:
            organelle, bin_width, max_distance = dialog.result
    """

    def __init__(self, parent: tk.Tk, available_organelles: List[str]):
        self.parent = parent
        self.available_organelles = sorted(available_organelles)
        self.result = None
        self._create_dialog()

    def _create_dialog(self):
        self.dialog = tk.Toplevel(self.parent)
        self.dialog.title("Radial Distribution Configuration")
        self.dialog.geometry("400x520")
        self.dialog.resizable(False, False)

        self.dialog.transient(self.parent)
        self.dialog.grab_set()
        self._center_dialog()

        main_frame = ttk.Frame(self.dialog, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)

        ttk.Label(
            main_frame, text="Radial Distribution",
            font=('Arial', 12, 'bold')
        ).pack(pady=(0, 10))

        ttk.Label(
            main_frame,
            text="Analyze the radial volume distribution of an\n"
                 "organelle relative to the cell center.\n"
                 "Configure the distance binning below.",
            font=('Arial', 9),
            justify=tk.CENTER
        ).pack(pady=(0, 15))

        # Organelle selection
        org_frame = ttk.LabelFrame(main_frame, text="Select Organelle", padding="10")
        org_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 10))

        self.selection_var = tk.StringVar()

        for organelle in self.available_organelles:
            ttk.Radiobutton(
                org_frame, text=organelle,
                variable=self.selection_var, value=organelle
            ).pack(anchor=tk.W, pady=2)

        if self.available_organelles:
            self.selection_var.set(self.available_organelles[0])

        # Binning parameters
        bin_frame = ttk.LabelFrame(main_frame, text="Binning Parameters", padding="10")
        bin_frame.pack(fill=tk.X, pady=(0, 10))

        width_row = ttk.Frame(bin_frame)
        width_row.pack(fill=tk.X, pady=2)
        ttk.Label(width_row, text="Bin Width (um):").pack(side=tk.LEFT)
        self.bin_width_var = tk.StringVar(value="0.25")
        width_entry = ttk.Entry(width_row, textvariable=self.bin_width_var, width=10)
        width_entry.pack(side=tk.RIGHT)

        dist_row = ttk.Frame(bin_frame)
        dist_row.pack(fill=tk.X, pady=2)
        ttk.Label(dist_row, text="Max Distance (um):").pack(side=tk.LEFT)
        self.max_distance_var = tk.StringVar(value="80.0")
        dist_entry = ttk.Entry(dist_row, textvariable=self.max_distance_var, width=10)
        dist_entry.pack(side=tk.RIGHT)

        self.preview_label = ttk.Label(
            bin_frame, text="", font=('Arial', 9),
            foreground='#666666'
        )
        self.preview_label.pack(pady=(8, 0))

        width_entry.bind('<KeyRelease>', self._update_preview)
        dist_entry.bind('<KeyRelease>', self._update_preview)
        self._update_preview()

        # Buttons
        button_frame = ttk.Frame(main_frame)
        button_frame.pack(fill=tk.X, pady=(5, 0))

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

    def _update_preview(self, event=None):
        try:
            bw = float(self.bin_width_var.get())
            md = float(self.max_distance_var.get())
            if bw > 0 and md > bw:
                n_bins = round(md / bw)
                self.preview_label.config(
                    text=f"{n_bins} bins: 0.00 - {md:.2f} um",
                    foreground='#666666'
                )
            else:
                self.preview_label.config(text="Invalid parameters", foreground='#CC0000')
        except ValueError:
            self.preview_label.config(text="Invalid parameters", foreground='#CC0000')

    def _on_ok(self):
        try:
            bw = float(self.bin_width_var.get())
            md = float(self.max_distance_var.get())
        except ValueError:
            messagebox.showerror("Invalid Input", "Bin width and max distance must be numbers.",
                                 parent=self.dialog)
            return

        if bw <= 0:
            messagebox.showerror("Invalid Input", "Bin width must be positive.", parent=self.dialog)
            return
        if md <= 0:
            messagebox.showerror("Invalid Input", "Max distance must be positive.", parent=self.dialog)
            return
        if md <= bw:
            messagebox.showerror("Invalid Input", "Max distance must be greater than bin width.",
                                 parent=self.dialog)
            return

        selected = self.selection_var.get()
        if not selected:
            messagebox.showerror("No Selection", "Please select an organelle.", parent=self.dialog)
            return

        self.result = (selected, bw, md)
        self.dialog.destroy()

    def _on_cancel(self):
        self.result = None
        self.dialog.destroy()
