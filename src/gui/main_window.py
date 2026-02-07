"""
GUI Module for Organelle Analysis Software

Provides a graphical user interface for running organelle analyses.

Author: Philipp Kaintoch
Date: 2025-11-18
"""

import re
import logging
import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import threading
from pathlib import Path
from datetime import datetime

from ..core.one_way_interaction import OneWayInteractionAnalyzer
from ..core.vol_spher_metrics import VolSpherMetricsAnalyzer
from ..core.nway_interaction import NWayInteractionAnalyzer
from ..core.radial_distribution import RadialDistributionAnalyzer
from .bait_selection_dialog import BaitSelectionDialog
from .radial_distribution_dialog import RadialDistributionDialog
from ..__version__ import __version__


class GUILogHandler(logging.Handler):
    """Redirects log records to a GUI callback."""

    def __init__(self, callback):
        super().__init__()
        self.callback = callback

    def emit(self, record):
        self.callback(self.format(record))


class ToolTip:
    """Simple tooltip class for displaying hover help text."""

    def __init__(self, widget, text):
        self.widget = widget
        self.text = text
        self.tooltip_window = None
        self.widget.bind("<Enter>", self.show_tooltip)
        self.widget.bind("<Leave>", self.hide_tooltip)

    def show_tooltip(self, event=None):
        if self.tooltip_window or not self.text:
            return
        x = self.widget.winfo_rootx() + 20
        y = self.widget.winfo_rooty() + self.widget.winfo_height() + 5

        self.tooltip_window = tk.Toplevel(self.widget)
        self.tooltip_window.wm_overrideredirect(True)
        self.tooltip_window.wm_geometry(f"+{x}+{y}")

        label = tk.Label(
            self.tooltip_window,
            text=self.text,
            background="#FFFFDD",
            relief="solid",
            borderwidth=1,
            font=("Arial", 9),
            wraplength=300
        )
        label.pack()

    def hide_tooltip(self, event=None):
        if self.tooltip_window:
            self.tooltip_window.destroy()
            self.tooltip_window = None


class OrganelleAnalysisGUI:
    """Main GUI window for organelle analysis software."""

    def __init__(self, root):
        self.root = root
        self.root.title(f"Organelle Analysis Software v{__version__}")
        self.root.geometry("850x720")
        self.root.resizable(True, True)

        self.input_dir = tk.StringVar()
        self.output_dir = tk.StringVar()
        self.file_format = tk.StringVar(value='excel')
        self.analysis_type = tk.StringVar(value='one_way')

        self.output_dir.set(str(Path.home()))
        self.setup_ui()
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)

    def setup_ui(self):
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))

        title_label = ttk.Label(
            main_frame, text="Organelle Analysis Software",
            font=('Arial', 14, 'bold')
        )
        title_label.grid(row=0, column=0, columnspan=3, pady=(0, 20))

        row = 1

        # Input Directory
        ttk.Label(main_frame, text="Input Directory:",
                  font=('Arial', 10, 'bold')).grid(row=row, column=0, sticky=tk.W, pady=(0, 5))

        row += 1
        ttk.Entry(main_frame, textvariable=self.input_dir, width=50).grid(
            row=row, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 5))

        input_browse_btn = ttk.Button(main_frame, text="Browse...", command=self.browse_input_dir)
        input_browse_btn.grid(row=row, column=2, padx=(5, 0), pady=(0, 5))
        ToolTip(input_browse_btn, "Select folder containing *_Statistics directories from Imaris")

        # Output Directory
        row += 1
        ttk.Label(main_frame, text="Output Directory:",
                  font=('Arial', 10, 'bold')).grid(row=row, column=0, sticky=tk.W, pady=(15, 5))

        row += 1
        ttk.Entry(main_frame, textvariable=self.output_dir, width=50).grid(
            row=row, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 5))

        output_browse_btn = ttk.Button(main_frame, text="Browse...", command=self.browse_output_dir)
        output_browse_btn.grid(row=row, column=2, padx=(5, 0), pady=(0, 5))
        ToolTip(output_browse_btn, "Select folder where results will be saved")

        row += 1
        ttk.Separator(main_frame, orient='horizontal').grid(
            row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=20)

        # Analysis Options
        row += 1
        ttk.Label(main_frame, text="Analysis Options",
                  font=('Arial', 10, 'bold')).grid(row=row, column=0, sticky=tk.W, pady=(0, 10))

        row += 1
        analysis_frame = ttk.Frame(main_frame)
        analysis_frame.grid(row=row, column=0, columnspan=3, sticky=tk.W, pady=5)

        ttk.Label(analysis_frame, text="Analysis Type:").pack(side=tk.LEFT, padx=(0, 20))

        oneway_radio = ttk.Radiobutton(analysis_frame, text="One-Way Interactions",
                                        variable=self.analysis_type, value='one_way')
        oneway_radio.pack(side=tk.LEFT, padx=5)
        ToolTip(oneway_radio, "Calculate mean shortest distances between organelle populations")

        volspher_radio = ttk.Radiobutton(analysis_frame, text="Vol/Spher-Metrics",
                                          variable=self.analysis_type, value='vol_spher')
        volspher_radio.pack(side=tk.LEFT, padx=5)
        ToolTip(volspher_radio, "Calculate volume and sphericity statistics per organelle")

        row += 1
        nway_frame = ttk.Frame(main_frame)
        nway_frame.grid(row=row, column=0, columnspan=3, sticky=tk.W, pady=5)

        ttk.Label(nway_frame, text="N-Way Analysis:").pack(side=tk.LEFT, padx=(0, 20))

        nway_single_radio = ttk.Radiobutton(nway_frame, text="Single Bait",
                                             variable=self.analysis_type, value='nway_single')
        nway_single_radio.pack(side=tk.LEFT, padx=5)
        ToolTip(nway_single_radio, "Multi-organelle contact patterns for a selected bait organelle")

        nway_batch_radio = ttk.Radiobutton(nway_frame, text="Batch (All Baits)",
                                            variable=self.analysis_type, value='nway_batch')
        nway_batch_radio.pack(side=tk.LEFT, padx=5)
        ToolTip(nway_batch_radio, "Analyze ALL organelles as baits (generates one file per organelle)")

        row += 1
        radial_frame = ttk.Frame(main_frame)
        radial_frame.grid(row=row, column=0, columnspan=3, sticky=tk.W, pady=5)

        ttk.Label(radial_frame, text="Distribution:").pack(side=tk.LEFT, padx=(0, 20))

        radial_radio = ttk.Radiobutton(radial_frame, text="Radial Distribution",
                                        variable=self.analysis_type, value='radial_distribution')
        radial_radio.pack(side=tk.LEFT, padx=5)
        ToolTip(radial_radio, "Radial volume distribution of an organelle from cell center")

        # Output Format
        row += 1
        format_frame = ttk.Frame(main_frame)
        format_frame.grid(row=row, column=0, columnspan=3, sticky=tk.W, pady=5)

        ttk.Label(format_frame, text="Output Format:").pack(side=tk.LEFT, padx=(0, 20))

        excel_radio = ttk.Radiobutton(format_frame, text="Excel (.xlsx)",
                                       variable=self.file_format, value='excel')
        excel_radio.pack(side=tk.LEFT, padx=5)
        ToolTip(excel_radio, "Single Excel file with multiple sheets (recommended for most users)")

        csv_radio = ttk.Radiobutton(format_frame, text="CSV (.csv)",
                                     variable=self.file_format, value='csv')
        csv_radio.pack(side=tk.LEFT, padx=5)
        ToolTip(csv_radio, "Multiple CSV files in output directory (for R/Python analysis)")

        row += 1
        ttk.Separator(main_frame, orient='horizontal').grid(
            row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=20)

        # Experimental
        row += 1
        ttk.Label(main_frame, text="Experimental",
                  font=('Arial', 10, 'bold')).grid(row=row, column=0, sticky=tk.W, pady=(0, 5))

        row += 1
        viz_frame = ttk.Frame(main_frame)
        viz_frame.grid(row=row, column=0, columnspan=3, sticky=tk.W, pady=(0, 5))

        viz_btn = ttk.Button(viz_frame, text="Visualize Results...", command=self._open_visualization)
        viz_btn.pack(side=tk.LEFT)
        ToolTip(viz_btn, "Generate heatmaps from radial distribution output files")

        row += 1
        ttk.Separator(main_frame, orient='horizontal').grid(
            row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=20)

        # Run Button
        row += 1
        self.run_button = ttk.Button(main_frame, text="Run Analysis", command=self.run_analysis)
        self.run_button.grid(row=row, column=0, columnspan=3, pady=(0, 20))
        ToolTip(self.run_button, "Start processing the selected analysis with current settings")

        # Progress Bar
        row += 1
        ttk.Label(main_frame, text="Progress:", font=('Arial', 10)).grid(
            row=row, column=0, sticky=tk.W, pady=(0, 5))

        row += 1
        self.progress_bar = ttk.Progressbar(main_frame, mode='indeterminate', length=400)
        self.progress_bar.grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))

        # Status Text
        row += 1
        ttk.Label(main_frame, text="Status:", font=('Arial', 10)).grid(
            row=row, column=0, sticky=tk.W, pady=(0, 5))

        row += 1
        self.status_text = tk.Text(
            main_frame, height=12, width=75, wrap=tk.WORD,
            state='disabled', font=('Courier', 9)
        )
        self.status_text.grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E))

        self.status_text.tag_config('INFO', foreground='#0066CC')
        self.status_text.tag_config('WARNING', foreground='#FF8C00')
        self.status_text.tag_config('ERROR', foreground='#CC0000')
        self.status_text.tag_config('SUCCESS', foreground='#008000')
        self.status_text.tag_config('DEBUG', foreground='#808080')

        scrollbar = ttk.Scrollbar(main_frame, orient='vertical', command=self.status_text.yview)
        scrollbar.grid(row=row, column=3, sticky=(tk.N, tk.S))
        self.status_text['yscrollcommand'] = scrollbar.set

    def browse_input_dir(self):
        directory = filedialog.askdirectory(title="Select Input Directory")
        if directory:
            self.input_dir.set(directory)

    def browse_output_dir(self):
        directory = filedialog.askdirectory(title="Select Output Directory")
        if directory:
            self.output_dir.set(directory)

    def update_status(self, message: str):
        self.status_text.config(state='normal')

        match = re.match(r'\[(\w+)\]', message)
        if match:
            level = match.group(1)
            if level in ['INFO', 'WARNING', 'ERROR', 'DEBUG']:
                self.status_text.insert(tk.END, message + '\n', level)
            elif 'SUCCESS' in message:
                self.status_text.insert(tk.END, message + '\n', 'SUCCESS')
            else:
                self.status_text.insert(tk.END, message + '\n')
        else:
            self.status_text.insert(tk.END, message + '\n')

        self.status_text.see(tk.END)
        self.status_text.config(state='disabled')
        self.root.update_idletasks()

    def validate_inputs(self) -> bool:
        if not self.input_dir.get():
            messagebox.showerror("Error", "Please select an input directory")
            return False
        if not Path(self.input_dir.get()).exists():
            messagebox.showerror("Error", "Input directory does not exist")
            return False
        if not self.output_dir.get():
            messagebox.showerror("Error", "Please select an output directory")
            return False
        if not Path(self.output_dir.get()).exists():
            messagebox.showerror("Error", "Output directory does not exist")
            return False
        return True

    def _attach_gui_logging(self):
        handler = GUILogHandler(self.update_status)
        handler.setLevel(logging.INFO)
        handler.setFormatter(logging.Formatter('[%(levelname)s] %(message)s'))
        logging.getLogger().addHandler(handler)
        return handler

    def _detach_gui_logging(self, handler):
        logging.getLogger().removeHandler(handler)

    def run_analysis_thread(self):
        handler = self._attach_gui_logging()
        try:
            self.status_text.config(state='normal')
            self.status_text.delete(1.0, tk.END)
            self.status_text.config(state='disabled')
            self.progress_bar.start(10)

            try:
                input_dir = self.input_dir.get()
                output_dir = Path(self.output_dir.get())
                file_format = self.file_format.get()
                analysis_type = self.analysis_type.get()

                if analysis_type == 'one_way':
                    if file_format == 'excel':
                        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                        output_path = output_dir / f"One_Way_Interactions_{timestamp}.xlsx"
                    else:
                        output_path = output_dir / "One_Way_Interactions"

                    analyzer = OneWayInteractionAnalyzer(input_dir)
                    analyzer.run(str(output_path), file_format=file_format)

                elif analysis_type == 'vol_spher':
                    if file_format == 'excel':
                        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                        output_path = output_dir / f"Vol_Spher_Metrics_{timestamp}.xlsx"
                    else:
                        output_path = output_dir / "Vol_Spher_Metrics"

                    analyzer = VolSpherMetricsAnalyzer(input_dir)
                    analyzer.run(str(output_path), file_format=file_format)

                elif analysis_type == 'nway_single':
                    analyzer = NWayInteractionAnalyzer(input_dir, threshold=0.0)
                    analyzer.load_data()
                    available_orgs = analyzer.get_available_organelles()

                    self._nway_analyzer = analyzer
                    self._nway_output_dir = output_dir
                    self._nway_file_format = file_format

                    self.root.after(0, lambda: self._show_bait_selection_dialog(available_orgs))
                    return

                elif analysis_type == 'nway_batch':
                    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                    batch_output_dir = output_dir / f"NWay_Analysis_Batch_{timestamp}"

                    analyzer = NWayInteractionAnalyzer(input_dir, threshold=0.0)
                    output_files = analyzer.run(str(batch_output_dir), file_format=file_format)

                    self.update_status(f"\n[SUCCESS] Created {len(output_files)} output files")

                elif analysis_type == 'radial_distribution':
                    analyzer = RadialDistributionAnalyzer(input_dir)
                    analyzer.load_data()
                    available_orgs = analyzer.get_available_organelles()

                    self._radial_analyzer = analyzer
                    self._radial_output_dir = output_dir
                    self._radial_file_format = file_format

                    self.root.after(0, lambda: self._show_radial_distribution_dialog(available_orgs))
                    return

                else:
                    raise ValueError(f"Unknown analysis type: {analysis_type}")

            finally:
                self._detach_gui_logging(handler)

            self.progress_bar.stop()
            self.update_status("\n[SUCCESS] Analysis completed successfully!")
            messagebox.showinfo("Success", "Analysis completed successfully!")

        except Exception as e:
            self.progress_bar.stop()
            self.update_status(f"\n[ERROR] {str(e)}")
            messagebox.showerror("Error", f"Analysis failed:\n{str(e)}")
            logging.exception("Analysis failed with exception:")

        finally:
            self.run_button.config(state='normal')

    def run_analysis(self):
        if not self.validate_inputs():
            return
        self.run_button.config(state='disabled')
        self.analysis_thread = threading.Thread(target=self.run_analysis_thread, daemon=False)
        self.analysis_thread.start()

    def _show_bait_selection_dialog(self, available_orgs):
        dialog = BaitSelectionDialog(self.root, available_orgs)
        self.root.wait_window(dialog.dialog)

        if dialog.result:
            selected_bait = dialog.result[0]
            self._nway_analyzer.set_bait_organelles([selected_bait])

            self.analysis_thread = threading.Thread(
                target=self._continue_nway_analysis, daemon=False
            )
            self.analysis_thread.start()
        else:
            self.update_status("[INFO] Analysis cancelled by user")
            self.progress_bar.stop()
            self.run_button.config(state='normal')

    def _continue_nway_analysis(self):
        handler = self._attach_gui_logging()
        try:
            try:
                analyzer = self._nway_analyzer
                output_dir = self._nway_output_dir
                file_format = self._nway_file_format

                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                bait_name = analyzer.bait_organelles[0] if analyzer.bait_organelles else "unknown"
                final_output_dir = output_dir / f"NWay_Analysis_{bait_name}_{timestamp}"

                analyzer.analyze_all_baits()

                if file_format == 'excel':
                    output_files = analyzer.export_to_excel(str(final_output_dir))
                else:
                    output_files = analyzer.export_to_csv(str(final_output_dir))

                self.update_status(f"\n[SUCCESS] Analysis complete! Created {len(output_files)} file(s)")

            finally:
                self._detach_gui_logging(handler)

            messagebox.showinfo("Success", "N-Way Analysis completed successfully!")

        except Exception as e:
            self.update_status(f"\n[ERROR] {str(e)}")
            messagebox.showerror("Error", f"Analysis failed:\n{str(e)}")
            logging.exception("N-Way analysis failed:")

        finally:
            self.progress_bar.stop()
            self.run_button.config(state='normal')

            for attr in ('_nway_analyzer', '_nway_output_dir', '_nway_file_format'):
                if hasattr(self, attr):
                    delattr(self, attr)

    def _show_radial_distribution_dialog(self, available_orgs):
        dialog = RadialDistributionDialog(self.root, available_orgs)
        self.root.wait_window(dialog.dialog)

        if dialog.result:
            organelle, bin_width, max_distance = dialog.result
            self._radial_analyzer.set_parameters(organelle, bin_width, max_distance)

            self.analysis_thread = threading.Thread(
                target=self._continue_radial_analysis, daemon=False
            )
            self.analysis_thread.start()
        else:
            self.update_status("[INFO] Analysis cancelled by user")
            self.progress_bar.stop()
            self.run_button.config(state='normal')

    def _continue_radial_analysis(self):
        handler = self._attach_gui_logging()
        try:
            try:
                analyzer = self._radial_analyzer
                output_dir = self._radial_output_dir
                file_format = self._radial_file_format

                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                organelle = analyzer.organelle

                if file_format == 'excel':
                    output_path = output_dir / f"Radial_Distribution_{organelle}_{timestamp}.xlsx"
                else:
                    output_path = output_dir / f"Radial_Distribution_{organelle}_{timestamp}"

                analyzer.analyze()

                if file_format == 'excel':
                    analyzer._save_excel(str(output_path))
                else:
                    analyzer._save_csv(str(output_path))

                self.update_status(f"\n[SUCCESS] Radial distribution analysis complete!")

            finally:
                self._detach_gui_logging(handler)

            messagebox.showinfo("Success", "Radial Distribution Analysis completed successfully!")

        except Exception as e:
            self.update_status(f"\n[ERROR] {str(e)}")
            messagebox.showerror("Error", f"Analysis failed:\n{str(e)}")
            logging.exception("Radial distribution analysis failed:")

        finally:
            self.progress_bar.stop()
            self.run_button.config(state='normal')

            for attr in ('_radial_analyzer', '_radial_output_dir', '_radial_file_format'):
                if hasattr(self, attr):
                    delattr(self, attr)

    def _open_visualization(self):
        from .visualization_dialog import VisualizationDialog
        VisualizationDialog(self.root)

    def on_closing(self):
        if hasattr(self, 'analysis_thread') and self.analysis_thread.is_alive():
            response = messagebox.askyesno(
                "Analysis Running",
                "Analysis is still running. Do you want to wait for it to complete?"
            )
            if response:
                self.analysis_thread.join(timeout=30)
            else:
                messagebox.showwarning(
                    "Warning",
                    "Forcing quit may result in incomplete output files."
                )
        self.root.destroy()


def launch_gui():
    root = tk.Tk()
    app = OrganelleAnalysisGUI(root)
    root.mainloop()


if __name__ == "__main__":
    launch_gui()
