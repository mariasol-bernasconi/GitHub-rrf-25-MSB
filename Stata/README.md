# Reproducible Research Fundamentals 2025 - Stata

[README template](https://github.com/worldbank/wb-reproducible-research-repository/blob/main/resources/README_Template.md)



**A. Overview**

This reproducibility package includes data, documentation and code to reproduce "Reproducible Research Fundamentals 2025 - Stata".



**B. Data Availability**

The following is a list of datasets used. All data are publicly available.

**B.1. Data Sources**

* TZA\_CCT\_baseline.dta:
* TZA\_amenity.csv:
* treat\_status.dta:

**B.2. Statement about Rights**

I certify that the author(s) of the manuscript have documented permission to redistribute/publish the data contained within this replication package.



**C. Instructions for Replicators**

New users should follow these steps to run the package successfully:



Update file "main.do" with your directory paths: data, code, and outputs.



Ensure all required software and dependencies are installed as listed in "main.do". Stata version is 18.5. Necessary dependencies are ietoolkit, iefieldkit, winsor, sumstats, estout, keeporder, grc1leg2.



Run the "main.do" file. By doing this, you will be running three do files: "01-processing-data.do", "02-constructing-data.do", and "03-analyzing-data.do".



**D. List of Exhibits**

The provided code reproduces:

* fig1:
* fig2:
* fig3:
* summary\_1.tex:
* baltab\_1.tex:



**E. Code Description**

"main.do" sets file paths, installs necessary ADO packages, and executes all other do files. Meanwhile, "01-processing-data.do" loads data and handles missing values, "02-constructing-data.do" constructs necessary indicators for analysis, and "03-analyzing-data.do" performs basic statistical analysis and generates tables and visualizations.



**F. Folder Structure**



