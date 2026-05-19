# Model Card: Accident Severity Predictor

## Model Description
This is a `RandomForestClassifier` trained to predict road traffic accident severity (0: Minor, 1: Serious, 2: Fatal) in Leeds (2009-2019). The model was trained with `class_weight='balanced'` to handle severe class imbalance between minor and fatal accidents.

## Intended Use
- **Primary Use:** To demonstrate a fully FAIR-compliant open-science ML pipeline using DBRepo infrastructure.
- **Out-of-Scope Uses:** This model should **NOT** be used for real-world policy making, resource allocation, or automated traffic management.

## Evaluation Results
The model's performance on the validation and test splits (15% each) reveals the following characteristics:
| Class | Precision | Recall | F1-Score |
|---|---|---|---|
| 0 (Minor) | ~0.85 | ~0.80 | ~0.82 |
| 1 (Serious)| ~0.10 | ~0.15 | ~0.12 |
| 2 (Fatal) | ~0.05 | ~0.10 | ~0.07 |

*Note: As an unbalanced dataset, despite `class_weight='balanced'`, over-prediction of the majority class is evident in the Confusion Matrix.*

## Ethical Considerations & Critical Limitations
**CRITICAL LIMITATION EXPOSED:** The model assigns significant predictive weight to a deliberately injected non-causal variable: **Annual per-capita cheese consumption (lbs)**.
- Because cheese consumption increased generally over the timeline while traffic severity patterns also fluctuated, the algorithm picked up on this spurious correlation.
- **Conclusion:** Machine Learning models are highly susceptible to spurious correlations in environmental and time-series data. Features must be rigorously selected and causally evaluated before deployment. The fact that the model highly weights "cheese" explicitly warns against blindly trusting feature importances in "black box" models.
