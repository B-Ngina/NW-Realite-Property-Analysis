# NW-Realite-Property-Analysis
This project involves cleaning and analyzing a property management dataset for NW Realite. The goal was to transform raw CSV data into an interactive dashboard to help the Head of Property Management make data-driven decisions regarding rent collection and occupancy.

Tools Used;

SQL (MySQL)-  handling nulls, and calculating lease durations.

Microsoft Excel- Data cleaning, Data modeling (VLOOKUP), Pivot Tables, and Dashboard creation.

Key Insights;

Arrears Concentration- Identified a significant debt risk in the Westlands area (Delta Corner).

Occupancy Gaps- High vacancy rates found in Riverside Court and Kimathi House despite 100% occupancy at NSSF Towers.

Data Integrity- Resolved critical issues including negative rent values and invalid lease dates.

Data Cleaning Decisions;

Negative Rent- Used ABS() to convert negative rent values to positive to fix data entry errors.

Date Logic- Flagged leases where lease_end was before lease_start as "Invalid" and excluded them from revenue totals.

Data Linking- Used VLOOKUP to connect Leases to Units, Properties, and Locations for geographical reporting.

Arrears- Maintained both positive and negative values to reflect the true net debt/credit position.

Formatting- Standardized all date and currency fields for visual consistency in the dashboard.
