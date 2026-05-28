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
* **Configuration files**: Format: `[description].[ext]`
* **Output files (`outputs/`)**: Format: `[description]_[date].[ext]`
  * date must follow the format `YYYYMMDD`

## DBRepo SQL Views

The SQL view definitions are stored in `src/database/mysql_create_views.sql`.
The DBRepo views were created and verified using the notebook `src/database/dbrepo_views_create.ipynb`.
The DBRepo API-based loading workflow is implemented in `src/database/dbrepo_api_reimplementation.ipynb`.

The database schema is normalized into separate tables for accidents, persons, weather, lighting, road surface, road class, vehicle, sex, casualty class, and casualty severity. To support analysis and machine learning, the views denormalize the database into query-ready tables.

### `vw_accident_casualty_ml_features`

This is the main machine-learning feature table. It joins accident, person, vehicle, road, weather, lighting, casualty class, and casualty severity information into one table.

The view contains accident-level information such as date, time, location, number of vehicles, weather, lighting, road surface, and road class. It also contains person-level and casualty-level information such as age, sex, vehicle categories, casualty class, and casualty severity.

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

### `vw_severity_by_vehicle`

This view counts casualties by vehicle category and severity level.

It is useful for checking whether certain vehicle categories are overrepresented in serious or fatal casualty cases.


## View Verification

All seven required DBRepo views were created and verified successfully in DBRepo. The verification output confirms that each required view exists in DBRepo and has a DBRepo view identifier.

Commented verification queries are included at the bottom of `src/database/mysql_create_views.sql`. They can be uncommented and run after the database tables are created, the data is loaded, and the views are created. These queries check row counts, preview the main ML feature table, and verify severity distributions.

## DBRepo API-based data loading

The final experiment implementation retrieves all input data exclusively from DBRepo using the REST API. No local CSV files are read by the final pipeline.

### API base URL

`https://test.dbrepo.tuwien.ac.at/api/v1`

### Database

Database UUID:

`b23492bd-f66d-4663-a1f5-f296767dbbdc`

### Authentication

The DBRepo test instance requires HTTP Basic Authentication. The username is entered interactively and the password is entered using `getpass`, so credentials are not stored in the repository or notebook.

### Endpoints used

The implementation uses the following DBRepo REST API endpoints.

1. Database metadata endpoint

```text
GET /database/{database_id}
```

Purpose: retrieve the database metadata and resolve table names to DBRepo table UUIDs.

2. Paginated table data endpoint

```text
GET /database/{database_id}/table/{table_id}/data?page={page}&size={size}
```

Purpose: retrieve rows from each DBRepo table using pagination. The notebook uses a page size of 1000 rows.

### Relations loaded from DBRepo

The following normalized DBRepo tables are loaded through the REST API:

- `accident`
- `person`
- `accident_casualty`
- `road_class`
- `road_surface`
- `lighting`
- `weather`
- `sex`
- `casualty_class`
- `casualty_severity`
- `vehicle`

The final working implementation reconstructs the ML-ready feature table in Python from the normalized API-loaded tables. The DBRepo views were created and verified separately.

### Reconstruction of the ML-ready feature table

The notebook builds the experiment table as follows:

1. Load the parent and child fact tables from DBRepo:
   - `accident`
   - `person`
   - `accident_casualty`
2. Join `accident_casualty` with `accident` on `reference_number`.
3. Join the result with `person` on `person_id`.
4. Join all lookup tables to add human-readable descriptions for categorical attributes:
   - `road_class`
   - `road_surface`
   - `lighting`
   - `weather`
   - `sex`
   - `casualty_class`
   - `casualty_severity`
   - `vehicle`

The resulting dataframe is named `raw_df` and contains 27,727 rows and 24 columns. It is produced entirely from DBRepo REST API responses.

### Robustness

The DBRepo API loader includes error handling for:

- connection errors;
- missing tables;
- empty API responses;
- unexpected HTTP status codes;
- temporary server-side errors such as 429, 500, 502, 503, and 504.

Temporary failures are retried using exponential backoff.

### Verification

The working API implementation successfully loaded the normalized DBRepo tables and reconstructed the ML-ready experiment dataset with the expected row counts:

- `accident`: 10,118 rows
- `person`: 27,727 rows
- `accident_casualty`: 27,727 rows
- reconstructed `raw_df`: 27,727 rows

This confirms that the final experiment pipeline no longer depends on local CSV input files. 


---
