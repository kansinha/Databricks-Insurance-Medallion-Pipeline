# Databricks-Insurance-Medallion-Pipeline
An end-to-end insurance claims and web funnel ETL pipeline built using Databricks (Spark 4.1.0) and Unity Catalog.

##  Project Overview
This project implements a production-ready, multi-source **Medallion Lakehouse Architecture** using **Databricks (Spark 4.1.0)** and **Unity Catalog**. The pipeline ingests semi-structured digital platform web traffic logs alongside core transactional database records to build data-driven insights on user conversion bottlenecks and regional insurance risk metrics.

##  System Architecture
The pipeline follows enterprise data engineering standards by splitting transformations into three distinct tiers:
1. **Bronze Layer (Ingestion):** Ingests raw CSV (policies, claims) and JSON (web funnel logs) from Unity Catalog Volumes, maintaining an append-only historical audit trail with ingestion timestamps.
2. **Silver Layer (Cleansing):** Cleans, standardizes, handles schema enforcement (casting timestamps/currencies), and deduplicates records into conformed Delta tables.
3. **Gold Layer (Aggregations):** Utilizes Spark SQL to compute high-value analytical business tables optimized for BI layer reporting.

---

##  Analytical Insights Delivered

### 1. Digital Platform Funnel Analysis
Tracks user milestones from original quote initialization through application finalization to isolate customer drop-off percentages.
* **Key KPI:** `overall_conversion_rate` (Calculated dynamically by policy type and geographical region).

### 2. Financial Performance & Loss Ratios
Aggregates total premiums generated against real paid claims to expose profit/loss exposures for underwriting teams.
* **Key KPI:** `loss_ratio_percentage` (Total Claims Paid / Total Premiums Collected * 100).

---

##  Technology Stack & Tools
* **Platform:** Databricks Community Edition
* **Data Catalog:** Unity Catalog (Volumes & Managed Delta Tables)
* **Engine:** Apache Spark 4.1.0 (PySpark Core & Spark SQL)
* **Storage Format:** Delta Lake (`.delta`)

##  Repository Structure
* `notebooks/01_bronze_ingestion.py`: PySpark source scripts for multi-format volume ingestion.
* `notebooks/02_silver_cleansing.py`: Data optimization, duplication handling, and typing validation.
* `notebooks/03_gold_analytics.sql`: Pure Spark SQL analytic matrices for strategic BI consumption.
