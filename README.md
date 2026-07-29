# Provider Outreach & Follow-Up Effectiveness Tracker

### Analyzing what drives resolution speed in a patient assistance pipeline

[![View Dashboard](https://img.shields.io/badge/Tableau-View%20Live%20Dashboard-1F4E79?style=for-the-badge&logo=tableau)](https://public.tableau.com/app/profile/tony.nguyen7509/viz/ProviderOutreachandFollow-UpEffectiveness/Dashboard1)

---

## Project Overview

This project is the second in a two-part series analyzing a patient assistance foundation eligibility pipeline. Where [Project 1](https://github.com/TonyNgyn/foundation-eligibility-pipeline) identified *where* cases stall and *which* documents are most often missing, this project goes a layer deeper — analyzing *how* outreach is conducted and *what contact strategies actually drive resolution*.

The core operational question: **when a document is missing, does it matter how you follow up?**

Built using **MySQL** for data modeling and analytical querying and **Tableau Public** for interactive visualization, this project models real-world outreach logic from my experience managing patient access cases at Genentech.

---

## The Business Problem

In a foundation eligibility pipeline, missing documents don't resolve themselves. A specialist must contact either the patient or provider, choose a contact method, and track whether that outreach results in resolution. The challenge is that not all contact strategies are equally effective:

- **Patient-owned documents** (Consent Form, Income Proof) resolve faster through direct patient contact via phone or text
- **Provider-owned documents** (Prescriber Form, Prior Authorization Letter) require provider outreach — but the method matters significantly
- **Prior Authorization Letters** are uniquely difficult: the PA process involves multiple steps on the provider's end, making fax-only outreach largely ineffective. A phone call to the provider's office accelerates the process substantially
- **Multi-missing cases** — where a patient is missing 3 or more documents — require a coordinated approach routing outreach to the provider when PA is among the missing items

This project quantifies those operational realities with data.

---

## Live Dashboard

Click the badge above or the link below to view the interactive Tableau dashboard:

🔗 [Provider Outreach & Follow-Up Effectiveness — Tableau Public](https://public.tableau.com/app/profile/tony.nguyen7509/viz/ProviderOutreachandFollow-UpEffectiveness/Dashboard1?publish=yes)

**Dashboard includes four charts:**
- **Resolution Rate by Document** — color-coded red to green showing which documents resolve easily vs. which stall cases
- **Contact Method Effectiveness** — combo chart comparing resolution rate and average days across Fax, Call, and Phone/Text
- **Case Complexity Impact** — how the number of missing documents affects resolution rate and timeline
- **Monthly Resolution Trend** — dual-line tracking resolution rate and average days to resolve across 12 months, surfacing operationally stressed periods

---

## Repository Contents

```
provider-outreach-effectiveness/
│
├── README.md                                    # This file
└── project2_outreach_effectiveness_mysql.sql    # Full SQL project file
```

### What's Inside the SQL File

**Schema** — One enriched table built on top of Project 1's patient data:
- `followup_log_v2` — 124 follow-up records with five fields not present in Project 1:
  - `contact_method` — Fax, Call, or Phone/Text
  - `attempt_number` — 1 (initial outreach) or 2 (escalation attempt)
  - `total_missing_docs` — case complexity indicator
  - `days_to_resolve` — actual resolution time when resolved
  - `notes` — outreach context (e.g. "Escalated to Call — 2nd attempt")

**Analytical Queries** — 10 queries including advanced SQL techniques:

| # | Query | SQL Concept |
|---|---|---|
| 1 | Resolution Rate by Document | Conditional AVG, multi-metric aggregation |
| 2 | Contact Method Effectiveness | Multi-dimension GROUP BY |
| 3 | Prior Auth Deep Dive — Fax vs Call | Filtered aggregation |
| 4 | Escalation Effectiveness (Attempt 1 vs 2) | Multi-dimension comparison |
| 5 | Case Complexity Impact | CASE bucketing |
| 6 | Patient vs Provider Speed | Two-dimension GROUP BY |
| 7 | Unresolved After 2 Attempts | HAVING clause |
| 8 | Monthly Resolution Trend | Date aggregation |
| 9 | Optimal Contact Strategy | **CTE + Window Function (RANK)** |
| 10 | Full Follow-Up Journey | Multi-table JOIN with ordering |

---

## Key Findings

Based on the mock dataset modeled on real operational patterns:

- **Prior Authorization Letter has the lowest resolution rate at 20.8%** — the most difficult document to collect, driven by an extended multi-step process on the provider's end
- **Fax-only outreach resolves only 20.8% of cases** vs. **66% when a call is made** — calling providers directly is significantly more effective and should be the default for PA and Prescriber Form follow-up
- **Phone/Text contact with patients resolves 84% of cases** at an average of 5.6 days — the fastest and most reliable outreach method for patient-owned documents
- **Single-document cases resolve at 64.3%** — multi-document cases (2+ missing) show similar rates but take longer (avg 11.9 days for 3+ missing), suggesting complexity compounds timeline rather than resolution probability
- **March and June were the lowest-performing months** at 40% and 44.4% resolution rates respectively — potential indicators of staffing, provider availability, or seasonal factors worth monitoring

---

## Operational Recommendations

Derived from the data analysis:

| Document | Best Contact | Method | Expected Resolution Rate |
|---|---|---|---|
| Consent Form | Patient | Phone/Text | 90% |
| Income Documentation | Patient | Phone/Text | 87% |
| Insurance Card | Patient | Phone/Text | 82% |
| Prescriber Form | Provider | Call | 76% |
| Prior Auth Letter | Provider | Call (not fax) | 62% escalated |

---

## New SQL Concepts Introduced (vs. Project 1)

This project expands on Project 1's SQL foundation with two advanced techniques:

**CTE (Common Table Expression)** — Query 9 uses a `WITH` clause to break a complex ranking problem into readable, named steps. CTEs are a standard tool in professional data analyst work for building readable, maintainable queries.

**Window Functions** — Query 9 uses `RANK() OVER (PARTITION BY ...)` to rank contact methods within each document type. Window functions operate across rows without collapsing them like GROUP BY does — a powerful and commonly tested concept in data analyst interviews.

---

## How to Run This Project

**Prerequisites:** Complete [Project 1](https://github.com/TonyNgyn/foundation-eligibility-pipeline) first — this project's `followup_log_v2` table references the `patients` table created there.

1. Open MySQL Workbench and connect to your local instance
2. Ensure `foundation_pipeline` database is active (`USE foundation_pipeline;`)
3. Go to **File → Open SQL Script** and select `project2_outreach_effectiveness_mysql.sql`
4. Run the full script with **Ctrl+Shift+Enter**
5. Highlight and run individual queries with **Ctrl+Enter** to explore each analysis

---

## Project Series

This is Part 2 of a two-part analytics project series:

| Project | Focus | Link |
|---|---|---|
| Part 1 — Foundation Eligibility Pipeline Tracker | Where cases stall, which docs are missing, pipeline health | [GitHub](https://github.com/TonyNgyn/foundation-eligibility-pipeline) \| [Tableau](https://public.tableau.com/app/profile/tony.nguyen7509/viz/FoundationEligibilityPipelineTracker/Dashboard1) |
| Part 2 — Provider Outreach Effectiveness (this project) | What contact strategies drive resolution | [GitHub](https://github.com/TonyNgyn/provider-outreach-effectiveness) \| [Tableau](https://public.tableau.com/app/profile/tony.nguyen7509/viz/ProviderOutreachandFollow-UpEffectiveness/Dashboard1) |

---

## About This Project

Built as part of my transition from healthcare operations into data analytics. The outreach logic, contact method strategies, and escalation patterns are modeled on real workflows from my experience managing patient access cases at Genentech.

All patient data is entirely fictional — names, dates, and outcomes are randomly generated mock data with no connection to real patients or cases.

**Author:** Tony Nguyen
**LinkedIn:** [linkedin.com/in/ttonynguyenn](https://www.linkedin.com/in/ttonynguyenn/)
**Tableau Public:** [public.tableau.com/profile/tony.nguyen7509](https://public.tableau.com/app/profile/tony.nguyen7509)
**Project 1:** [Foundation Eligibility Pipeline Tracker](https://github.com/TonyNgyn/foundation-eligibility-pipeline)

---

*Built with MySQL Workbench and Tableau Public — 2024*
