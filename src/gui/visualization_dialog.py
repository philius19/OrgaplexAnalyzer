"""
Visualization Dialog for Radial Distribution Heatmaps

Modal dialog for loading radial distribution output files and
generating publication-quality heatmap figures.

Author: Philipp Kaintoch
"""

import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import threading
from pathlib import Path

from ..visualization import load_radial_output, generate_radial_heatmap


class VisualizationDialog:
    """Modal dialog for generating radial distribution heatmaps."""

    def __init__(self, parent: tk.Tk):
        self.parent = parent
        self.datasets = []
        self._create_dialog()

    def _create_dialog(self):
        self.dialog = tk.Toplevel(self.parent)
        self.dialog.title("Radial Distribution Heatmap")
        self.dialog.geometry("520x520")
        self.dialog.resizable(False, False)

        self.dialog.transient(self.parent)
        self.dialog.grab_set()
        self._center_dialog()

        main_frame = ttk.Frame(self.dialog, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)

        ttk.Label(
            main_frame, text="Radial Distribution Heatmap",
            font=('Arial', 12, 'bold'),
        ).pack(pady=(0, 10))

        list_frame = ttk.LabelFrame(main_frame, text="Loaded Organelles", padding="10")
        list_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 10))

        self.listbox = tk.Listbox(list_frame, height=8, font=('Courier', 9))
        self.listbox.pack(fill=tk.BOTH, expand=True)

        btn_row = ttk.Frame(list_frame)
        btn_row.pack(fill=tk.X, pady=(5, 0))
        ttk.Button(btn_row, text="Add File...", command=self._add_file, width=14).pack(side=tk.LEFT)
        ttk.Button(btn_row, text="Remove Selected", command=self._remove_selected, width=14).pack(side=tk.RIGHT)

        opts_frame = ttk.LabelFrame(main_frame, text="Options", padding="10")
        opts_frame.pack(fill=tk.X, pady=(0, 10))

        row1 = ttk.Frame(opts_frame)
        row1.pack(fill=tk.X, pady=2)
        ttk.Label(row1, text="Condition Label:").pack(side=tk.LEFT)
        self.condition_var = tk.StringVar()
        ttk.Entry(row1, textvariable=self.condition_var, width=20).pack(side=tk.RIGHT)

        row2 = ttk.Frame(opts_frame)
        row2.pack(fill=tk.X, pady=2)
        ttk.Label(row2, text="Reference Line Spacing (\u00b5m):").pack(side=tk.LEFT)
        self.ref_spacing_var = tk.StringVar(value="20.0")
        ttk.Entry(row2, textvariable=self.ref_spacing_var, width=10).pack(side=tk.RIGHT)

        row3 = ttk.Frame(opts_frame)
        row3.pack(fill=tk.X, pady=2)
        ttk.Label(row3, text="DPI:").pack(side=tk.LEFT)
        self.dpi_var = tk.StringVar(value="300")
        ttk.Entry(row3, textvariable=self.dpi_var, width=10).pack(side=tk.RIGHT)

        self.status_label = ttk.Label(main_frame, text="", font=('Arial', 9), foreground='#666666')
        self.status_label.pack(pady=(0, 5))

        button_frame = ttk.Frame(main_frame)
        button_frame.pack(fill=tk.X)
        ttk.Button(button_frame, text="Cancel", command=self._on_cancel, width=12).pack(side=tk.LEFT)
        self.generate_btn = ttk.Button(button_frame, text="Generate Heatmap", command=self._generate, width=16)
        self.generate_btn.pack(side=tk.RIGHT)

        self.dialog.bind('<Escape>', lambda e: self._on_cancel())
        self.dialog.protocol("WM_DELETE_WINDOW", self._on_cancel)

    def _center_dialog(self):
        self.dialog.update_idletasks()
        px = self.parent.winfo_x()
        py = self.parent.winfo_y()
        pw = self.parent.winfo_width()
        ph = self.parent.winfo_height()
        dw = self.dialog.winfo_width()
        dh = self.dialog.winfo_height()
        self.dialog.geometry(f"+{px + (pw - dw) // 2}+{py + (ph - dh) // 2}")

    def _add_file(self):
        path = filedialog.askopenfilename(
            title="Select Radial Distribution Output",
            filetypes=[("Excel files", "*.xlsx")],
            parent=self.dialog,
        )
        if not path:
            return

        try:
            data = load_radial_output(path)
        except Exception as e:
            messagebox.showerror("Load Error", str(e), parent=self.dialog)
            return

        existing = [d['organelle'] for d in self.datasets]
        if data['organelle'] in existing:
            messagebox.showwarning(
                "Duplicate", f"Organelle '{data['organelle']}' is already loaded.",
                parent=self.dialog,
            )
            return

        if self.datasets:
            ref = self.datasets[0]
            if (data['bin_width'] != ref['bin_width'] or
                    data['max_distance'] != ref['max_distance'] or
                    data['n_bins'] != ref['n_bins']):
                messagebox.showerror(
                    "Bin Mismatch",
                    f"Bin parameters for '{data['organelle']}' do not match previously loaded files.\n"
                    f"Expected: bin_width={ref['bin_width']}, max_distance={ref['max_distance']}, n_bins={ref['n_bins']}\n"
                    f"Got: bin_width={data['bin_width']}, max_distance={data['max_distance']}, n_bins={data['n_bins']}",
                    parent=self.dialog,
                )
                return

        self.datasets.append(data)
        fname = Path(path).name
        self.listbox.insert(tk.END, f"{data['organelle']}  \u2014  {fname}")
        self.status_label.config(text=f"{len(self.datasets)} organelle(s) loaded")

    def _remove_selected(self):
        sel = self.listbox.curselection()
        if not sel:
            return
        idx = sel[0]
        self.listbox.delete(idx)
        self.datasets.pop(idx)
        self.status_label.config(text=f"{len(self.datasets)} organelle(s) loaded")

    def _generate(self):
        if not self.datasets:
            messagebox.showwarning("No Data", "Add at least one file first.", parent=self.dialog)
            return

        try:
            dpi = int(self.dpi_var.get())
            ref_spacing = float(self.ref_spacing_var.get())
        except ValueError:
            messagebox.showerror("Invalid Input", "DPI and spacing must be numbers.", parent=self.dialog)
            return

        output_path = filedialog.asksaveasfilename(
            title="Save Heatmap As",
            defaultextension=".png",
            filetypes=[("PNG", "*.png"), ("PDF", "*.pdf"), ("SVG", "*.svg")],
            parent=self.dialog,
        )
        if not output_path:
            return

        self.generate_btn.config(state='disabled')
        self.status_label.config(text="Generating heatmap...")

        def _run():
            try:
                generate_radial_heatmap(
                    self.datasets,
                    output_path,
                    condition_label=self.condition_var.get().strip(),
                    dpi=dpi,
                    ref_line_spacing=ref_spacing,
                )
                self.dialog.after(0, lambda: self._on_success(output_path))
            except Exception as e:
                self.dialog.after(0, lambda: self._on_error(str(e)))

        threading.Thread(target=_run, daemon=True).start()

    def _on_success(self, path):
        self.generate_btn.config(state='normal')
        self.status_label.config(text="Done!")
        messagebox.showinfo("Success", f"Heatmap saved to:\n{path}", parent=self.dialog)

    def _on_error(self, msg):
        self.generate_btn.config(state='normal')
        self.status_label.config(text="Error")
        messagebox.showerror("Error", f"Heatmap generation failed:\n{msg}", parent=self.dialog)

    def _on_cancel(self):
        self.dialog.destroy()
