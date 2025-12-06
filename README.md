# NOAA Storm Events Analysis (2024)

**Author:** Julia Hise  
**Course:** DAT 511 – Final Project  
**Date:** December 2025  

## 📌 Project Overview
This project analyzes NOAA StormEvents data for 2024 to identify the most harmful weather event types, their geographic distribution, seasonal patterns, and fatality risks. The goal is to provide actionable insights for municipal managers and emergency planners preparing for severe weather.

## 📁 Files Included
- `FinalProject.R` – Raw R script with fully commented code for data loading, cleaning, analysis, and plotting.  
- `FinalProject.Rmd` – R Markdown file used to generate the RPubs report, including narrative, code chunks, figures, and interpretations.  
- `StormEvents_joined_data.csv` – Output file containing the cleaned and joined dataset (generated locally, not stored in repo due to size).
- `Q1-Rplot` - R plot for question 1
- `Q2-Rplot` - R plot for question 2
- `Q3updated-Rplot` - R plot for question 3
- `Q4-Rplot` - R plot for question 4
- **RPubs Report:** [View the published analysis here](https://rpubs.com/hisej/1377339)  

## ⚙️ How to Run
1. Download the NOAA StormEvents CSV files for 2024 from the official NOAA archive:  
   👉 [NOAA StormEvents CSV Archive](https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/)  
   *(Choose the most recent files for 2024: `details`, `fatalities`, and `locations`.)*  
2. Place all three CSV files in the same folder as the project scripts.  
3. Open `FinalProject.Rmd` in RStudio.  
4. Knit to HTML to preview the report.  
5. Publish to RPubs if desired.  

## 📊 Questions Answered
1. **Which event types are most harmful to population health?**  
   → Based on combined fatalities and injuries.  

2. **Which events occur most frequently in which states?**  
   → Top 10 event-type/state combinations.  

3. **Which event types dominate each month?**  
   → Seasonal hazard patterns across the calendar year.  

4. **Which event types cause the most fatalities?**  
   → Ranked by total fatality count.  

## 🛠️ Notes on Data Handling
- All analysis begins from raw NOAA CSVs.  
- Property and crop damage variables are cleaned using a custom function to convert suffixes (K, M, B) into numeric values.  
- Warnings related to parsing and joins are expected and handled appropriately:  
  - `read_csv()` calls include `show_col_types = FALSE` to suppress column spec messages.  
  - `left_join()` includes `relationship = "many-to-many"` to acknowledge expected duplication.  
  - Damage cleaning uses `suppressWarnings()` to handle non-numeric entries gracefully.  

## ✅ Reproducibility
All results are reproducible from the `.Rmd` file. Code is visible, figures are captioned, and interpretations are provided for each question.

