# Publishing & Persistent Identifiers (Phase 5)

## Zenodo DOI Integration
1. Connect this GitHub repository to Zenodo via the official Zenodo-GitHub integration (`https://zenodo.org/account/settings/github/`).
2. Create a Release on GitHub.
3. Zenodo will automatically mint a DOI.
4. Update `README.md` and `CITATION.cff` with the real DOI value.

## TU Wien Research Data Repository (TUWRD) Deposits
You must manually make two separate deposits to the TUWRD test instance (`https://test.researchdata.tuwien.ac.at`):

### 1. Model Deposit
- **Resource Type:** Model
- **Files to Upload:**
  - `outputs/accident_severity_model.pkl`
  - `docs/fair4ml.json`
- **Metadata:** Include the Zenodo DOI from above, and reference the DBRepo entry.
- **Community:** Request inclusion in the `DaSt-2026-final` community.

### 2. Generated Data Deposit
- **Resource Type:** Dataset
- **Files to Upload:**
  - `outputs/cheese_distribution_by_severity.png`
  - `outputs/confusion_matrix.png`
  - `outputs/feature_importances.png`
  - The prediction results (if serialized).
- **Metadata:** Link to the Model Deposit above, include the Zenodo DOI, and reference the DBRepo entry.
- **Community:** Request inclusion in the `DaSt-2026-final` community.
