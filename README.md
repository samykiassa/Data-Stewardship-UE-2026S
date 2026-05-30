# Predicting Road Traffic Accident Severity: An Analysis of Environmental Factors and Spurious Correlations

[![Zenodo DOI](https://zenodo.org/badge/1227412997.svg)](https://doi.org/10.5281/zenodo.20463919)
[![Dataset DOI](https://img.shields.io/badge/Dataset_DOI-10.82556%2F7fh1--gm97-blue)](https://doi.org/10.82556/7fh1-gm97)

## Abstract

This project investigates the prediction of road traffic accident severity using machine learning methods and structured accident-related data. The experiment focuses on environmental, contextual, and accident-specific attributes to analyse which factors contribute to casualty severity and whether some observed correlations may be spurious or misleading.

The project is developed as part of the FAIR Data Science / Data Stewardship exercise at TU Wien. It follows FAIR-oriented documentation and publication practices by combining a public GitHub repository, DBRepo-based data access, machine-readable metadata, licence documentation, and persistent identifiers for deposited artefacts.

The final experiment retrieves all input data from DBRepo through the REST API instead of reading local CSV files. The repository includes documentation for the database schema, SQL views, API-based loading workflow, RO-Crate metadata, Croissant metadata, software and data licences, and generated outputs.

---

## File Organization

```text
Data-Stewardship-UE-2026S/
│
├── data/                   # Data used or generated in the project
│
├── docs/                   # Documentation and related materials
│   ├── metadata/           # Metadata records such as Croissant metadata
│   └── validation/         # Validation outputs for metadata artefacts
│
├── src/                    # Source code and scripts for data processing
│   └── database/           # DBRepo schema, views, notebooks, and API workflow
│
├── outputs/                # Output files from scripts or analyses
│
├── ro-crate-metadata.json  # RO-Crate metadata for the research object
├── codemeta.json           # CodeMeta software metadata, if available
├── CITATION.cff            # Citation metadata, including DOI information, if available
├── LICENSE                 # Software licence
└── README.md               # Project documentation and reproduction instructions
```

## File Naming Convention

To ensure consistency, all files in this repository follow specific naming rules:

* **Input datasets (`data/`)**: Format: `[description]_[status]_[date].[ext]`
  * date must follow the format `YYYYMMDD`
  * The following status tags are allowed:
    * `raw`: raw dataset without cleaning
    * `cleaned`: cleaned dataset
    * `processed`: processed dataset used for analysis or modelling

* **Documentation (`docs/`)**: Format: `[description]_[date].[ext]`
  * date must follow the format `YYYYMMDD`

* **Scripts (`src/`)**: Format: `[job_name].[ext]`

* **Configuration files**: Format: `[description].[ext]`

* **Output files (`outputs/`)**: Format: `[description]_[date].[ext]`
  * date must follow the format `YYYYMMDD`

---

## Requirements and Installation

### Software requirements

The project requires the following software:

- Python 3.10 or later
- Git
- Jupyter Notebook or JupyterLab for executing the notebooks
- Internet access to retrieve data from the DBRepo REST API
- Access credentials for the DBRepo test instance

### Python environment

Clone the repository:

```bash
git clone https://github.com/e12436439/Data-Stewardship-UE-2026S.git
cd Data-Stewardship-UE-2026S
```

Create and activate a virtual environment:

```bash
python -m venv .venv
source .venv/bin/activate
```

On Windows PowerShell:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

Install the required Python packages:

```bash
pip install --upgrade pip
pip install -r requirements.txt
```


---

## Step-by-Step Reproduction Instructions

### 1. Clone the repository and install dependencies

Follow the installation instructions above.

### 2. Confirm DBRepo access

The final experiment uses DBRepo as the source for input data. Confirm that the DBRepo API base URL and database UUID listed below are reachable and that you have valid DBRepo credentials.

### 3. Create or verify DBRepo SQL views

The SQL view definitions are stored in:

```text
src/database/mysql_create_views.sql
```

The views were created and verified using:

```text
src/database/dbrepo_views_create.ipynb
```

Run the notebook if the views need to be recreated or checked.

### 4. Load the input data through the DBRepo API

Run the API-based loading workflow:

```text
src/database/dbrepo_api_reimplementation.ipynb
```

This notebook retrieves the normalized DBRepo tables through the REST API and reconstructs the ML-ready feature table in Python. The final workflow does not read local CSV files.

### 5. Reconstruct the ML-ready dataset

The notebook reconstructs the dataframe `raw_df` by joining the DBRepo-loaded tables. The resulting dataframe contains 27,727 rows and 24 columns.

### 6. Run the modelling and evaluation workflow

Run the project modelling scripts or notebooks in `src/` after the DBRepo-loaded dataframe has been reconstructed. Generated outputs such as predictions, metrics, and figures should be written to `outputs/` using the file naming convention above.

### 7. Validate metadata artefacts

The RO-Crate metadata file is available as:

```text
ro-crate-metadata.json
```

The validation output is available under:

```text
docs/validation/ro-crate-validation.txt
```

The validation command used was:

```bash
rocrate-validator validate . > docs/validation/ro-crate-validation.txt
```

---

## Inputs

### Input dataset

The road traffic accident dataset used in this project was obtained from the European Open Data Portal and published by Leeds City Council.

Dataset source:

```text
https://data.europa.eu/data/datasets/road-traffic-accidents?locale=en
```

The dataset contains accident, casualty, person, vehicle, road, weather, lighting, and severity-related information. In this project, it is represented in DBRepo using a normalized relational schema and then reconstructed into query-ready feature tables for analysis and machine learning.

### DBRepo database

API base URL:

```text
https://test.dbrepo.tuwien.ac.at/api/v1
```

Database UUID:

```text
b23492bd-f66d-4663-a1f5-f296767dbbdc
```

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

---

## Outputs

The project produces the following categories of outputs:

- reconstructed ML-ready dataframe produced from DBRepo API responses;
- trained machine learning model artefacts;
- prediction outputs;
- evaluation metrics;
- figures and exploratory analysis outputs;

Generated outputs are stored in `outputs/` or deposited in the TU Wien Research Data Repository according to the project submission requirements.

---

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

---

## DBRepo API-based Data Loading

The final experiment implementation retrieves all input data exclusively from DBRepo using the REST API. No local CSV files are read by the final pipeline.

### API base URL

```text
https://test.dbrepo.tuwien.ac.at/api/v1
```

### Database

Database UUID:

```text
b23492bd-f66d-4663-a1f5-f296767dbbdc
```

### Authentication

The DBRepo test instance requires HTTP Basic Authentication. The username is entered interactively and the password is entered using `getpass`, so credentials are not stored in the repository or notebook.

### Endpoints used

The implementation uses the following DBRepo REST API endpoints.

#### 1. Database metadata endpoint

```text
GET /database/{database_id}
```

Purpose: retrieve the database metadata and resolve table names to DBRepo table UUIDs.

#### 2. Paginated table data endpoint

```text
GET /database/{database_id}/table/{table_id}/data?page={page}&size={size}
```

Purpose: retrieve rows from each DBRepo table using pagination. The notebook uses a page size of 1000 rows.

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


---

## Metadata Artefacts

### Croissant Metadata

Croissant metadata for the input dataset is available at `docs/metadata/road_traffic_accident_croissant_20260529.json`. It describes the DBRepo-accessed accident severity input dataset, including fields, data types, distribution information, licence, and semantic unit mappings.

### RO-Crate

This repository is packaged as an RO-Crate 1.1 compliant research object.
The metadata is available in [`ro-crate-metadata.json`](ro-crate-metadata.json).
Validation output is available under [`docs/validation/ro-crate-validation.txt`](docs/validation/ro-crate-validation.txt).

### FAIR4ML Metadata

FAIR4ML metadata for the trained Random Forest model is available at `docs/metadata/fair4ml_model_metadata_20260529.yaml`.

The metadata describes the training dataset DOI, algorithm name and version, hyperparameters, evaluation metrics, intended use, known limitations, and the related model card. The same FAIR4ML metadata file is uploaded alongside the trained model in the TUWRD model deposit.

### Model Card

The Model Card for the trained accident severity prediction model is available at `docs/metadata/model_card_20260529.md`.

It describes the model, intended use, out-of-scope uses, training data, evaluation results, limitations, ethical considerations, and licence.

## TUWRD Deposits

The trained model artefact is deposited in the TU Wien Research Data Repository test instance.

- Model deposit DOI: `10.70124/thw4c-36p53`

The generated output data, including predictions, confusion matrix, feature distribution histogram, and performance/feature-importance chart, is deposited separately.

- Generated output data DOI: `10.70124/cmx24-bwv40`

---

## Licences

This project distinguishes between three categories of artefacts: input data, software/code, and produced output data.

### Input Data Licence

The road traffic accident dataset used in this project was obtained from the European Open Data Portal and published by Leeds City Council.

Dataset source:

```text
https://data.europa.eu/data/datasets/road-traffic-accidents?locale=en
```

The dataset is distributed under the Open Government Licence (OGL) v3.0. This licence permits reuse, redistribution, and modification of the data, provided that appropriate attribution is maintained.

This licence allows the dataset to be used for research and machine learning purposes within this project. The required attribution to Leeds City Council and the original dataset source is maintained in the README, metadata files, and repository documentation.

### Software Licence

The software and source code developed for this project are licensed under the MIT License.

The MIT License was selected because it is a permissive open-source licence that allows reuse, modification, distribution, and academic collaboration with minimal restrictions.

The licence is compatible with the source dataset licence and supports reproducible scientific research.

### Output Data Licence

All generated artefacts produced during this project, including trained machine learning models, processed datasets, figures, and prediction outputs, are distributed under the Creative Commons Attribution 4.0 International (CC BY 4.0) licence.

This licence permits reuse and redistribution provided appropriate attribution is given to the project authors.

---

