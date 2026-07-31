# Foundation Eligibility Pipeline — Analytics Project Series

### An end-to-end SQL and Tableau analytics project built on real healthcare operations workflows

[![Project 1 Dashboard](https://img.shields.io/badge/Tableau-Pipeline%20Tracker-1F4E79?style=for-the-badge&logo=tableau)](https://public.tableau.com/app/profile/tony.nguyen7509/viz/FoundationEligibilityPipelineTracker/Dashboard1)
[![Project 2 Dashboard](https://img.shields.io/badge/Tableau-Outreach%20Effectiveness-2E75B6?style=for-the-badge&logo=tableau)](https://public.tableau.com/app/profile/tony.nguyen7509/viz/ProviderOutreachandFollow-UpEffectiveness/Dashboard1)

---

## Project Series Overview

This repository contains a two-part analytics project series analyzing a **patient assistance foundation eligibility pipeline** — the process by which patients and providers apply for financial assistance programs for specialty drug therapies.

The two projects build on each other progressively:

| | Project 1 | Project 2 |
|---|---|---|
| **Focus** | Where do cases stall and why? | What contact strategies drive resolution? |
| **Question** | Which documents are missing and what delays do they cause? | Does it matter how and who you contact? |
| **SQL Level** | JOINs, aggregations, GROUP BY | CTEs, window functions, RANK() |
| **Tableau** | Bar charts, line charts, pipeline funnel | Combo charts, dual-axis, color-encoded bars |
| **Dashboard** | [View Live →](https://public.tableau.com/app/profile/tony.nguyen7509/viz/FoundationEligibilityPipelineTracker/Dashboard1) | [View Live →](https://public.tableau.com/app/profile/tony.nguyen7509/viz/ProviderOutreachandFollow-UpEffectiveness/Dashboard1) |

Both projects share a single MySQL database (`foundation_pipeline`) and build on the same two core tables — run Project 1 first, then Project 2.

---

## The Business Problem

In a patient assistance eligibility pipeline, every application requires a complete set of documents before a determination can be made:

| Document | Submitted By | Typical Contact Method |
|---|---|---|
| Patient Consent Form | Patient | Phone / Text |
| Prescriber Form | Provider | Call |
| Insurance Card | Patient | Phone / Text |
| Prior Authorization Letter | Provider | Fax → escalate to Call |
| Adjusted Gross Income & Household Size | Patient | Phone / Text |

When any document is missing the case stalls, follow-up must be sent, and the clock keeps running. These projects quantify where cases stall, what causes the longest delays, and what outreach strategies actually resolve them.

---

## Repository Structure

```
foundation-eligibility-pipeline/
│
├── README.md                                         # This file
│
├── sql/
│   ├── project1_pipeline_tracker.sql                 # Schema, seed data, 10 queries
│   └── project2_outreach_effectiveness.sql           # Enriched schema, seed data, 10 queries
│
├── data/
│   ├── patients.csv                                  # 100 mock patient records
│   ├── followups_v1.csv                              # Original follow-up log (Project 1)
│   └── followups_v2.csv                              # Enriched follow-up log (Project 2)
│
└── tableau/
    ├── project1_dashboard_link.md                    # Tableau Public URL — Project 1
    └── project2_dashboard_link.md                    # Tableau Public URL — Project 2
```

---

## How to Run This Project

**Prerequisites:** MySQL Workbench installed with a local MySQL instance running.

### Step 1 — Run Project 1 First
1. Open MySQL Workbench and connect to your local instance
2. Go to **File → Open SQL Script** → select `sql/project1_pipeline_tracker.sql`
3. Run the full script with **Ctrl+Shift+Enter**
4. This creates the `foundation_pipeline` database, the `patients` and `followup_log` tables, loads all seed data, and runs 10 analytical queries

### Step 2 — Run Project 2
1. **File → Open SQL Script** → select `sql/project2_outreach_effectiveness.sql`
2. Run the full script with **Ctrl+Shift+Enter**
3. This adds the `followup_log_v2` table to the existing database — it references the `patients` table from Project 1 via foreign key
4. Run individual queries with **Ctrl+Enter** by highlighting them

### Note on Query Execution
Each query is separated by a comment header (e.g. `-- 1. Pipeline Overview`). Highlight any single query and hit **Ctrl+Enter** to run it independently.

---

## Project 1 — Foundation Eligibility Pipeline Tracker

### What It Does
Models the full patient application pipeline from submission through eligibility determination. Tracks which documents are missing, how that impacts resolution time, and how the pipeline performs across insurers, prescribers, and time.

### Live Dashboard
🔗 [Foundation Eligibility Pipeline Tracker — Tableau Public](https://public.tableau.com/app/profile/tony.nguyen7509/viz/FoundationEligibilityPipelineTracker/Dashboard1)

**Four charts:**
- Case Status Breakdown — where cases are right now
- Document Completeness Rate — which docs are most often missing
- Avg Delay Days by Missing Document — the operational cost of each gap
- Monthly Application Volume & Outcomes — pipeline health over time

### Schema
**`patients`** — 100 mock records including:
- Demographics (name, DOB, state)
- Insurance and drug information
- Prescriber name
- Document status flags (5 binary columns)
- AGI, household size, FPL percentage
- Eligibility status and resolution date
- Delay days (calculated from missing documents)

**`followup_log`** — 93 follow-up records including:
- Missing document type
- Contact type (Patient or Provider)
- Follow-up sent date and resolution date
- Resolved flag

### 10 Analytical Queries

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

### Key Findings
- **82% of cases are stalled** — 43% Incomplete, 39% Pending
- **Prior Authorization Letter** is absent in 24% of cases and causes the longest average delay at **18.4 days**
- **Prescriber Form** absence causes the second-longest delay at **15.1 days**
- Approval rate of **13%** is partially inflated by incomplete submissions in the denominator
- Monthly volume is stable at **8–10 cases/month** with no significant seasonal variation

---

## Project 2 — Provider Outreach & Follow-Up Effectiveness

### What It Does
Goes a layer deeper than Project 1 — instead of just identifying which documents are missing, this project analyzes **how outreach is conducted** and **what contact strategies actually resolve cases**. Introduces contact method (Fax, Call, Phone/Text), attempt tracking (initial vs. escalation), and case complexity as analytical dimensions.

### Live Dashboard
🔗 [Provider Outreach & Follow-Up Effectiveness — Tableau Public](https://public.tableau.com/app/profile/tony.nguyen7509/viz/ProviderOutreachandFollow-UpEffectiveness/Dashboard1)

**Four charts:**
- Resolution Rate by Document — color-coded red to green
- Contact Method Effectiveness — combo chart (bars + line overlay)
- Case Complexity Impact — color-encoded bars
- Monthly Resolution Trend — dual-line tracking rate and speed

### Schema
**`followup_log_v2`** — 124 enriched follow-up records, extending Project 1's `followup_log` with:
- `contact_method` — Fax, Call, or Phone/Text
- `attempt_number` — 1 (initial outreach) or 2 (escalation)
- `days_to_resolve` — actual resolution time in days
- `total_missing_docs` — case complexity flag
- `notes` — outreach context and escalation reason

### Operational Logic Modeled
The data reflects real-world outreach patterns:
- **Patient-owned documents** (Consent, Income Proof) route to direct patient contact via phone/text — fastest resolution method
- **Provider-owned documents** (Prescriber Form, Prior Auth) route to provider outreach
- **Prior Auth Letters** always start with fax but escalate to a phone call if unresolved — the PA process requires multiple steps on the provider's end making fax-only outreach largely ineffective
- **Multi-missing cases** (3+ documents) with PA present route all outreach to the provider for coordinated resolution

### 10 Analytical Queries

| # | Query | SQL Concept |
|---|---|---|
| 1 | Resolution Rate by Document | Conditional AVG |
| 2 | Contact Method Effectiveness | Multi-metric aggregation |
| 3 | Prior Auth Deep Dive — Fax vs Call | Filtered GROUP BY |
| 4 | Escalation Effectiveness (Attempt 1 vs 2) | Multi-dimension comparison |
| 5 | Case Complexity Impact | CASE bucketing |
| 6 | Patient vs Provider Speed | Two-dimension GROUP BY |
| 7 | Unresolved After 2 Attempts | HAVING clause |
| 8 | Monthly Resolution Trend | Date aggregation |
| 9 | Optimal Contact Strategy | **CTE + Window Function (RANK)** |
| 10 | Full Follow-Up Journey | Multi-table JOIN with ordering |

### Key Findings
- **Prior Authorization Letter resolves only 20.8% of the time via fax** vs. **66% when escalated to a phone call** — calling providers directly is significantly more effective
- **Phone/Text contact with patients resolves 84% of cases** at an average of 5.6 days — fastest and most reliable method for patient-owned documents
- **Fax-only outreach is largely ineffective** at 20.8% resolution — it should be used as a paper trail, not a primary contact strategy
- Single-document cases resolve at **64.3%** — multi-document cases (3+ missing) show compounding timelines averaging **11.9 days longer**
- **March and June** were the lowest-performing months at 40% and 44.4% resolution rates respectively

### New SQL Concepts vs. Project 1
**CTE (Common Table Expression)** — Query 9 uses a `WITH` clause to build a readable, multi-step ranking query. CTEs are standard in professional analytics work for building maintainable, layered logic.

**Window Functions** — Query 9 uses `RANK() OVER (PARTITION BY ...)` to rank contact methods within each document type independently. Window functions operate across rows without collapsing them like `GROUP BY` — a powerful pattern commonly tested in data analyst interviews.

---

## Recommended Contact Strategy (Data-Derived)

| Document | Contact | Method | Resolution Rate |
|---|---|---|---|
| Consent Form | Patient | Phone/Text | 90% |
| Income Documentation | Patient | Phone/Text | 87% |
| Insurance Card | Patient | Phone/Text | 82% |
| Prescriber Form | Provider | Call | 76% |
| Prior Auth Letter | Provider | Call (not fax) | 62% escalated |

---

## Tools Used

| Tool | Purpose |
|---|---|
| MySQL Workbench | Database design, relational modeling, query development |
| Tableau Public | Interactive dashboard and data visualization |
| Microsoft Excel | Intermediate data layer and chart prototyping |

---

## About This Project

Built as part of my transition from healthcare operations into data analytics. The pipeline logic, document requirements, outreach strategies, and escalation patterns are modeled directly on my experience managing 100+ patient cases weekly as a Foundation Specialist and Case Manager at Genentech.

All patient data is entirely fictional — all names, dates, and outcomes are randomly generated mock data with no connection to real patients or real cases.

**Author:** Tony Nguyen
**LinkedIn:** [linkedin.com/in/ttonynguyenn](https://www.linkedin.com/in/ttonynguyenn/)
**Tableau Public:** [public.tableau.com/profile/tony.nguyen7509](https://public.tableau.com/app/profile/tony.nguyen7509)

---

*Built with MySQL Workbench, Tableau Public, and Microsoft Excel — 2024*
