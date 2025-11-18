import pandas as pd
from pathlib import Path

def analyze_data(Rootdir,
                 volume_file = "Mito Vol.xls",
                 sphericity_file = "Mito Spher.xls",
                 output_file = "metrics_summary_results.xls"):
    
    # Load data 
    print("Loading Data...")
    Root = Path(Rootdir)
    df_sphericity = pd.read_excel(Root / sphericity_file, header=1)
    df_volume = pd.read_excel(Root / volume_file, header=1)

    # Group 
    sphericity_grouped = df_sphericity.groupby("Original Image Name")
    volume_grouped = df_volume.groupby("Original Image Name")
    
    # Calculate Metrics 
    sphericity_metrics = sphericity_grouped['Sphericity'].mean()
    volume_metrics_df = volume_grouped["Volume"].agg(["mean", "sum", "max"])

    # Rename Columns 
    volume_metrics_df.columns = ["Mean_Volume", "Total_Volume", "Max_Volume"]

    # Make DF
    sphericity_df = sphericity_metrics.to_frame(name="Mean_Sphericity")

    # Merge Results in a DF with horizontal alignment 
    results = pd.concat([sphericity_df, volume_metrics_df], axis=1)
    
    # Reset index to make Image Name a regular column
    results = results.reset_index()
    results = results.rename(columns={'Original Image Name': 'Image'})

    # Save to Excel
    output_path = Root / output_file
    results.to_excel(output_path, index=False)
    print(f"Results saved to: {output_path}")

    # Print summary
    print(f"\nAnalyzed {len(results)} images")
    print("\nFirst 5 results:")
    print(results.head())

    return results

Root = "/Users/philippkaintoch/Desktop/Manuel"

analyze_data(Root)