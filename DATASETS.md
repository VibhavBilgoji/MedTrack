# Global & India-Specific Medicine Datasets 💊

This document serves as a comprehensive reference for datasets and APIs used (or planned for integration) in MedTrack for drug classification, generic mapping, pricing, and metadata.

## 🌍 Global Medicine Datasets

### 1. WHO ATC/DDD Dataset
Used worldwide for drug classification.
- **Contains**: Generic drug names, Drug classes, Therapeutic categories, ATC codes.
- **Resources**:
  - [WHO ATC/DDD Toolkit](https://www.who.int/tools/atc-ddd-toolkit)
  - [ATC Index](https://www.whocc.no/atc_ddd_index/)
  - [Guidelines PDF](https://www.whocc.no/atc_ddd_methodology/guidelines/)

### 2. RxNorm (Best for Brand ↔ Generic Mapping)
The most important dataset for drug normalization and mapping.
- **Contains**: Brand names, Generic equivalents, Ingredients, Drug relationships, Synonyms, Standardized IDs.
- **Resources**:
  - [Official Download Page](https://www.nlm.nih.gov/research/umls/rxnorm/docs/rxnormfiles.html)
  - [Monthly Full Releases](https://www.nlm.nih.gov/research/umls/rxnorm/docs/rxnorm_release_notes.html)
  - [RxNorm API](https://lhncbc.nlm.nih.gov/RxNav/APIs/RxNormAPIs.html)

### 3. openFDA Drug Dataset
Excellent for medicine metadata and regulatory information.
- **Contains**: Brand names, Manufacturers, Ingredients, Labels, Dosage, Packaging, Drug approvals.
- **Resources**:
  - [openFDA Drug API](https://open.fda.gov/apis/drug/)
  - [Drug Label Downloads](https://open.fda.gov/apis/drug/label/download/)
  - [Drugs@FDA Database](https://www.fda.gov/drugs/information-on-drugs/drugsfda-data-files)

### 4. DailyMed
Massive NIH medicine database for official labeling.
- **Contains**: Active ingredients, Brand names, FDA labels, Strength, Packaging.
- **Resources**:
  - [Official Website](https://dailymed.nlm.nih.gov/dailymed/)
  - [SPL Downloads](https://dailymed.nlm.nih.gov/dailymed/spl-resources-all-drug-labels.cfm)

### 5. DrugBank
Extremely powerful but partially paid.
- **Contains**: Drug interactions, Chemical structures, Targets, Mechanisms, Synonyms, Brand names.
- **Resources**:
  - [Official Website](https://go.drugbank.com/)
  - [Download Access](https://go.drugbank.com/releases/latest)

### 6. NIH RxNav
Useful for ingredient lookup and generic mapping.
- **Contains**: Drug equivalency, Ingredient lookup, Generic mapping.
- **Resources**:
  - [Official Website](https://lhncbc.nlm.nih.gov/RxNav/)

---

## 🇮🇳 India-Specific Medicine Sources

### 7. Jan Aushadhi (Best for Cheap Alternatives)
Government generic medicine database.
- **Contains**: Generic medicine names, Prices, Alternatives, Product codes.
- **Resources**:
  - [Official Website](http://janaushadhi.gov.in/)
  - [Product List](http://janaushadhi.gov.in/ProductList.aspx)
  - [Search Medicines](http://janaushadhi.gov.in/JanAushadhiMedicine.aspx)

### 8. Tata 1mg
Good for branded medicines and pricing.
- **Contains**: Branded medicines, Alternatives, Pricing, Composition matching.
- **Resources**:
  - [Official Website](https://www.1mg.com/)
  - [Medicine Search](https://www.1mg.com/drugs-all-medicines)

### 9. PharmEasy
- [Official Website](https://pharmeasy.in/)

### 10. NetMeds
- [Official Website](https://www.netmeds.com/)

---

## 📊 Public Repositories & Research

### Kaggle Datasets
- [Drug Dataset Collection](https://www.kaggle.com/datasets?search=drug)
- **Useful searches**: Medicine prices, Drug classification, Prescriptions, Generic medicines.

### HuggingFace Datasets
- [Medical Datasets](https://huggingface.co/datasets?search=medical)
