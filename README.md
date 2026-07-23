# Foundation Eligibility Pipeline Tracker

### A healthcare operations analytics project built in MySQL and Tableau Public

[![View Dashboard](https://img.shields.io/badge/Tableau-View%20Live%20Dashboard-1F4E79?style=for-the-badge&logo=tableau)](https://public.tableau.com/app/profile/tony.nguyen7509/viz/FoundationEligibilityPipelineTracker/Dashboard1)

---

## Project Overview

This project models a real-world patient assistance foundation eligibility pipeline — the process by which patients and providers apply for financial assistance programs for specialty drug therapies. The goal was to analyze where cases stall, which missing documents cause the longest delays, and how the pipeline performs over time.

The project was built using **MySQL** for data modeling and analysis and **Tableau Public** for interactive visualization, and is based on operational workflows from my experience as a Foundation Specialist and Case Manager at Genentech.

---

## Business Problem

In a foundation eligibility pipeline, every patient application requires a complete set of documents before an eligibility determination can be made:

| Document | Submitted By |
|---|---|
| Patient Consent Form | Patient |
| Prescriber Form | Provider |
| Insurance Card | Patient |
| Prior Authorization Letter / Denial | Provider |
| Adjusted Gross Income & Household Size | Patient |

When any document is missing, the case stalls — follow-up must be sent to either the patient or provider, and the clock keeps running. The operational questions this project answers:

- Where are cases getting stuck in the pipeline?
- Which missing document causes the longest average delay?
- Which prescribers submit the most complete packets?
- How does application volume and approval rate trend month over month?

---

## Live Dashboard

Click the badge above or the link below to view the interactive Tableau dashboard:

🔗 [Foundation Eligibility Pipeline Tracker — Tableau Public](https://public.tableau.com/app/profile/tony.nguyen7509/viz/FoundationEligibilityPipelineTracker/Dashboard1?publish=yes)

The dashboard includes four charts:
- **Case Status Breakdown** — distribution of Approved, Denied, Pending, and Incomplete cases
- **Document Completeness Rate** — which documents are most frequently missing
- **Avg Delay Days by Missing Document** — the operational cost of each missing document in days
- **Monthly Application Volume & Outcomes** — pipeline trend across 2024

---

## Repository Contents

```
foundation-eligibility-pipeline/
│
├── README.md                          # This file
└── foundation_pipeline_mysql.sql      # Full SQL project file
```

### What's Inside the SQL File

The SQL file contains three sections:

**1. Schema** — Two relational tables:
- `patients` — 100 mock patient records including demographics, insurance, drug, prescriber, document status flags, AGI, household size, FPL percentage, eligibility status, and delay metrics
- `followup_log` — 93 follow-up records tracking which document was missing, who was contacted (patient vs. provider), when follow-up was sent, and whether it was resolved

**2. Seed Data** — 100 patient rows and 93 follow-up rows of realistic mock data generated to reflect real pipeline distribution patterns

**3. Analytical Queries** — 10 queries covering the full operational picture:

| # | Query | Business Question |
|---|---|---|
| 1 | Pipeline Overview | Where are cases right now? |
| 2 | Document Completeness Rate | Which doc is most often missing? |
| 3 | Avg Delay by Missing Document | What is actually slowing the pipeline? |
| 4 | Eligibility by FPL Bracket | Who qualifies at what income level? |
| 5 | Follow-Up Resolution Rate | Are patients and providers responding? |
| 6 | Active Work Queue | Which cases need attention today? |
| 7 | Prescriber Performance | Which providers submit complete packets? |
| 8 | Monthly Volume & Approval Trend | Is the pipeline healthy over time? |
| 9 | Insurer Breakdown | Which payers have the lowest PA rates? |
| 10 | End-to-End Pipeline Duration | How long does a case take start to finish? |

---

## Key Findings

Based on the mock dataset:

- **82% of cases are stalled** — 43% Incomplete, 39% Pending — indicating a significant documentation bottleneck before eligibility determination
- **Prior Authorization Letter** is the most impactful missing document, causing an average delay of **18.4 days** and absent in 24% of cases
- **Prescriber Form** absence causes the second-longest delay at **15.1 days** — targeted provider education could significantly reduce cycle time
- **Approval rate is 13%** — partially inflated denominator due to incomplete submissions; true eligibility rate among fully documented cases is higher
- **Monthly volume is stable** at 8–10 cases/month with no significant seasonal variation

---

## Tools Used

| Tool | Purpose |
|---|---|
| MySQL Workbench | Database design, data modeling, query development |
| Tableau Public | Interactive dashboard and data visualization |
| Microsoft Excel | Intermediate data layer and chart prototyping |
| Python (data generation) | Mock dataset generation for realistic pipeline simulation |

---

## How to Run This Project

1. Download `foundation_pipeline_mysql.sql`
2. Open MySQL Workbench and connect to your local instance
3. Go to **File → Open SQL Script** and select the downloaded file
4. Run the full script with **Ctrl+Shift+Enter** — this creates the database, tables, and loads all data
5. Highlight and run individual queries with **Ctrl+Enter** to explore each analysis
6. View the companion Tableau dashboard at the link above for visual output

---

## About This Project

This project was built as part of my transition from healthcare operations into data analytics. The pipeline logic, document requirements, and operational questions are drawn directly from my work managing 100+ patient cases weekly as a Foundation Specialist at Genentech.

The dataset is entirely fictional — all patient names, dates, and outcomes are randomly generated mock data with no connection to real patients or real cases.

**Author:** Tony Nguyen
**LinkedIn:** [linkedin.com/in/ttonynguyenn](https://www.linkedin.com/in/ttonynguyenn/)
**Tableau Public:** [public.tableau.com/profile/tony.nguyen7509](https://public.tableau.com/app/profile/tony.nguyen7509)

---

*Built with MySQL Workbench, Tableau Public, and Microsoft Excel — 2024*
