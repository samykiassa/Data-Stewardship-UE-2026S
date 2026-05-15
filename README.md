# Predicting Road Traffic Accident Severity: An Analysis of Environmental Factors and Spurious Correlations

## File Organization
```text
Data-Stewardship-UE-2026S/
│
├── data/                   # Data used or generated in the project
│
├── docs/                   # Documentation and related materials
│
├── src/                    # Source code and scripts for data processing
│
├── outputs/                # Output files from scripts or analyses
```

## File Naming Convention
To ensure consistency, all files in this repository follow specific naming rules:

* **Input datasets (`data/`)**: Format: `[description]_[status]_[date].[ext]` 
  * date must follow the format `YYYYMMDD` 
  * The following status tags are allowed: 
    * `raw`: raw dataset without cleaning
    * `cleaned`: cleaned dataset
  
* **Documentation (`docs/`)**: Format: `[description]_[date].[ext]`  
  * date must follow the format `YYYYMMDD`
* **Scripts (`src/`)**: Format: `[job_name].[ext]`
  * date must follow the format `YYYYMMDD`
* **Configuration files**: Format: `[description].[ext]`

## DBRepo SQL Views

The SQL view definitions are stored in `src/create_views.sql`.

The database schema is normalized into separate tables for accidents, persons, weather, lighting, road surface, road class, vehicle type, sex, casualty class, and casualty severity. To support analysis and machine learning, the views denormalize the database into query-ready tables.

### `vw_accident_casualty_ml_features`

This is the main machine-learning feature table. It joins accident, person, vehicle type, road, weather, lighting, casualty class, and casualty severity information into one table.

The view contains accident-level information such as date, time, location, number of vehicles, weather, lighting, road surface, and road class. It also contains person-level and casualty-level information such as age, sex, vehicle type, casualty class, and casualty severity.

This view is used as the main input table for the accident severity prediction pipeline.

### `vw_environmental_severity_features`

This view focuses on environmental and road-related factors such as weather, lighting, road surface, road class, number of vehicles, date, and time.

It is used to analyse the relationship between environmental conditions and casualty severity. This is directly connected to the project goal of studying environmental factors and possible spurious correlations.

### `vw_binary_severity_features`

This view creates a binary target variable for machine learning classification.

Fatal and serious casualties are mapped to `high_severity`, while all other casualties are mapped to `low_severity`.

This view is useful when the machine-learning model is trained as a binary classifier instead of predicting the original severity categories directly.

### `vw_severity_by_weather`

This view counts casualties by weather condition and severity level.

It is used for exploratory analysis and for creating summary tables or figures in the final report.

### `vw_severity_by_lighting`

This view counts casualties by lighting condition and severity level.

It helps analyse whether daylight, darkness, or artificial lighting conditions are associated with different accident severity levels.

### `vw_severity_by_road_surface`

This view counts casualties by road surface condition and severity level.

It supports analysis of whether dry, wet, icy, or other road surface conditions are associated with accident severity.

### `vw_severity_by_vehicle_type`

This view counts casualties by vehicle type and severity level.

It is useful for checking whether certain vehicle types are overrepresented in serious or fatal casualty cases.


### `Views Verification`

Commented verification queries are included at the bottom of `src/create_views.sql`. They can be uncommented and run after the database tables are created, the data is loaded, and the views are created. These queries check row counts, preview the main ML feature table, and verify severity distributions.

---
