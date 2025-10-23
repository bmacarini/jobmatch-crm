# JobMatch CRM

## 📌 Overview
**JobMatch CRM** is a Salesforce-based platform designed to connect **recruiters and candidates** efficiently.
The project focuses on automating recruitment processes, improving match quality between job openings and talent, and enabling companies to manage the entire hiring pipeline within Salesforce.

Developed as part of a personal portfolio initiative, this app applies **Salesforce low-code tools**, **custom Apex logic**, and **Lightning Web Components (LWC)**, following platform best practices.

## 🎯 Objectives
- Create a CRM system that centralizes candidates, companies, and job opportunities
- Automate recruitment processes using **Flow Builder** and validation rules
- **Evaluate and rank candidates** through a scoring system
- Provide a clean UI for browsing, viewing, and managing jobs and applications 
- Apply **Salesforce development best practices**, separating business logic from triggers

## 🛠️ Tech Stack
- **Salesforce Platform** (Custom Objects, Relationships, Validation Rules)
- **Flow Builder** for process automation
- **Apex** for custom logic and scoring algorithms
- **SOQL** for data querying
- **Lightning Web Components (LWC)** for UI
- **GitHub Actions + Salesforce CLI** for version control and CI/CD setup

## ⚙️ CI/CD Pipeline
This project includes a **GitHub Actions workflow** to automate Salesforce deployments and testing:

- **Scratch Org Creation** – A temporary org is created for each PR to validate changes
- **Source Deployment** – Apex classes, DTOs, LWC and metadata are pushed automatically to the scratch org
- **Automated Apex Tests** – All tests run automatically to ensure code reliability
- **Scratch Org Deletion** – Temporary orgs are cleaned up after tests

**Workflow triggers:**

- Push or PR to `develop` → validates code in a scratch org
- Merge to `main` → represents production-ready code

## 🚀 How It Works
1. Recruiters create a job opportunity with the required skills
2. Candidates register their profiles with personal information and skills
3. The Apex service calculates a Job Match Score based on profile-job compatibility
4. Recruiters view matches between jobs and candidates through LWC components
5. Recruiters send emails to candidates via Flow Builder

## 🏗️ Architecture

The JobMatch CRM follows a modular, scalable structure:

- **Custom Objects** define the data model (Candidate, Job, Company, Application)
- **Apex Services** handle logic like scoring and data processing
- **Triggers** delegate all logic to handlers (no logic inside triggers)
- **Flows** automate record updates and notifications
- **LWC Components** display interactive lists and details in the UI

### Architecture Diagram

    Recruiter --> LWC (Job List & Details)
    LWC --> Apex Controller [JobMatchScoreService]
    Apex --> SOQL Query [Candidate & Job Data]
    Apex --> Calculates Match Score
    Apex --> Returns Results --> LWC UI
    
## ✅ Unit Tests
- Cover Apex classes and trigger handlers
- Validate scoring logic and data consistency
- Include positive and negative scenarios

## 📖 References
- [Apex Best Practices](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_best_practices.htm)
- [Lightning Web Components Developer Guide](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)
- [Salesforce Flow Builder Guide](https://help.salesforce.com/s/articleView?id=sf.flow_concepts_overview.htm)