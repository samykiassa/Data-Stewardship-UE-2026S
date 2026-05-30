---
language: en
license: mit
tags:
  - random-forest
  - traffic-safety
metrics:
  - accuracy
  - f1
  - precision
  - recall
dataset_doi: 10.82556/7fh1-gm97
model_card_version: "1.0.0"
date_created: "2026-05-29"
---

# Model Card for Accident Severity Prediction

A Random Forest classifier trained to predict the severity of traffic accident casualties (Minor / Serious / Fatal) from
environmental and demographic features, using data retrieved exclusively via the DBRepo REST API.

## Model Details

### Model Description

This model is a `RandomForestClassifier` from the scikit-learn Python library trained to classify each accident_casualty
record into one of three severity classes: **Minor (0)**, **Serious (1)**, or **Fatal (2)**. It was developed as part of
the 194.045 Data Stewardship course. The data is retrieved from the [DBRepo](https://test.dbrepo.tuwien.ac.at) REST
API (database ID: `b23492bd-f66d-4663-a1f5-f296767dbbdc`).

The `RandomForestClassifier` consists of 50 decision trees with a fixed random seed (`random_state=42`) for
reproducibility and uses `class_weight='balanced'` to account for the natural class imbalance in accident severity
data, because fatal accidents are rare relative to minor ones. The trained model artefact is serialised with `joblib`
and stored at `outputs/accident_severity_model.joblib`.

- **Developed by:** Adigun Oladapo Oludele ([0009-0001-7256-5903](https://orcid.org/0009-0001-7256-5903)), Kiassa
  Samy ([0000-0003-2580-979X](https://orcid.org/0000-0003-2580-979X)), Sodhi
  Muskan ([0009-0004-8744-9106](https://orcid.org/0009-0004-8744-9106)), Katoch
  Nea ([0009-0009-4474-1576](https://orcid.org/0009-0009-4474-1576))
- **Model type:** Random Forest Classifier (tabular, supervised)
- **Language(s):** en
- **License:** MIT

## Uses

### Direct Use

This model was developed for the 194.045 Data Stewardship course at TU Wien. It predicts the severity of traffic
accident casualties based on environmental and demographic factors such as weather, road surface, and age. It can be
used by researchers or students who want to explore which factors contribute most to accident severity.

### Downstream Use

The model can serve as a starting point for more advanced road safety analysis tools. For example, it could be embedded
in a dashboard that visualizes predicted accident severity across different conditions. Any such use should include
additional validation before drawing conclusions from the model's outputs.

### Out-of-Scope Use

This model must not be used to make decisions about individual people, such as insurance claims or legal judgements,
since it was trained on aggregated data and not designed for individual risk assessment. It was only validated on the
dataset used in this project, so applying it to data from other countries or time periods may give unreliable results.
It should also not be used in any safety-critical context such as emergency response or clinical decisions, as its
accuracy is not sufficient for that.

## Bias, Risks, and Limitations

The historical accident records the model was trained on may reflect biases in how accidents were reported or classified
by authorities, and the model will carry those biases forward. Additionally, many factors that strongly influence
accident severity, such as speed, seatbelt usage or the road layout are not present in the dataset, which limits how
accurate the model can be. The model's overall accuracy of around 69% also shows that the available features are not
sufficient to reliably predict accident severity across all classes.

## Ethical Considerations

The dataset contains personal attributes such as age and sex of accident casualties, so any use of this model must
comply with data protection regulations like GDPR. The model should not be used in ways that could lead to
discriminatory outcomes, for example by drawing conclusions about specific demographic groups. Any use of the model that
could lead to unfair treatment of individuals or groups should be avoided.

## Licence

The trained model artefact and generated outputs are released under the Creative Commons Attribution 4.0 International (
CC BY 4.0) licence. The project source code is released separately under the MIT Licence. The underlying training
dataset is published under the Open Government Licence v3.0 (OGL v3.0), which permits reuse and redistribution as long
as the original source, Leeds City Council, is acknowledged.

## Training Details

### Training Data

**Dataset:** Traffic accident records stored in the TU Wien DBRepo instance.

- **DOI:** `10.82556/7fh1-gm97`
- **DBRepo Database ID:** `b23492bd-f66d-4663-a1f5-f296767dbbdc`
- **API Base URL:** `https://test.dbrepo.tuwien.ac.at/api/v1`
- **Access method:** REST API via `DBRepoExperimentLoader` (see `dbrepo_api_reimplementation.ipynb`)

The data is stored across several related database tables, including information about the accident, the people
involved, weather conditions, road surface, and lighting. After combining these tables and removing incomplete records,
the final dataset contained 27,727 entries, each representing one person involved in a road traffic accident. The data
was loaded directly from the DBRepo REST API and no local files were used.

**Features used for training:**

| Feature        | Type        | Description                            |
|----------------|-------------|----------------------------------------|
| `weather`      | Categorical | Weather conditions at time of accident |
| `road_surface` | Categorical | Road surface condition                 |
| `lighting`     | Categorical | Lighting conditions                    |
| `sex`          | Categorical | Sex of the casualty                    |
| `vehicle`      | Categorical | Type of vehicle involved               |
| `age`          | Numeric     | Age of the casualty                    |

Before training, the categorical features were converted into numbers using one-hot encoding. The target label was
encoded as 0 for Slight, 1 for Serious, and 2 for Fatal injuries.

**Data splits:**

| Split      | Records | Proportion |
|------------|---------|------------|
| Training   | 19,408  | 70 %       |
| Validation | 4,159   | 15 %       |
| Test       | 4,160   | 15 %       |

## Evaluation

### Results

**Validation accuracy (reported during training):** `0.6831`

#### Per-Class Metrics

| Class            | Precision | Recall | F1-Score | Support |
|------------------|-----------|--------|----------|---------|
| Minor (0)        | 0.89      | 0.73   | 0.81     | 3 599   |
| Serious (1)      | 0.19      | 0.35   | 0.24     | 501     |
| Fatal (2)        | 0.15      | 0.62   | 0.24     | 60      |
| **Macro avg**    | 0.41      | 0.57   | 0.43     | 4 160   |
| **Weighted avg** | 0.80      | 0.69   | 0.73     | 4 160   |

#### Summary

The model achieves 69% overall accuracy on the test set. As expected, it performs well for Minor injuries (F1: 0.81) but
struggles with Serious and Fatal cases (F1: 0.24 each), since these are much rarer in the dataset. The large gap between
macro average F1 (0.43) and weighted average F1 (0.73) confirms that the model is heavily influenced by the majority
class.

## Model Card Authors

Katoch Nea ([0009-0009-4474-1576](https://orcid.org/0009-0009-4474-1576))
