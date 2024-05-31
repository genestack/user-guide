R Shiny Expression Atlas Example

Here is an example R Shiny app that demonstrates how you can easily develop a custom user interface to query (transcriptomic or proteomic) expression data using ODM's multi-omics API.

To run the app, you need to:

- Generate your API token (see our user guide) and copy-paste it to the "token" variable in the app.R script
- Install [RStudio](https://rstudio.com/)
- Prerequisite libraries:
  - R packages:
    `install.packages(c("shiny", "ggbeeswarm", "plyr", "gridExtra", "tidyverse", "httr", "RJSONIO"))`
  - Ask us for the ODM R client library and install the "studyCurator", "integrationCurator", "expressionCurator" packages, e.g.
    `install.packages('<path to the r/studyCurator folder>', repos = NULL, type="source")`

**Example queries:**

- Explore bulk expression studies:
  - Select a study type from the "Study Type" drop-down list, e.g. **Bulk Study**.
  - Select a therapeutic area from the "Therapeutic area" drop-down list, e.g. **Immunology**.
  - Select some studies to query, e.g. the study **GSF1061557 (Reyes et al.)**.
  - Specify a gene/protein of interest, e.g. **CD3E**.
  - You will be able to see both (transcriptomic or proteomic) expression data under the "Beeswarm Plot" tab. You can also view relevant information in other tabs.
  - You can group the samples using the "Group by" field, e.g. the default grouping is by **Sex**
  - You can filter the data further using "Sample filter" (e.g. **Sex=female**) and "Expression filter" (e.g. **Source="RNA-Seq"**). Any information in the "Sample Info" and "Signal Data Info" can be used to filter the data.
  - You can also query two genes at the same time, e.g. typing in **CD28** next to CD3E.

- Explore single cell RNASeq: similar to what you do with Bulk study
  - A new tab of “t-SNE plot” is available for single-cell expression data, which allows users to visualise cell clusters and overlay the expression of specific gene(s).
  - Select a study type from the "Study Type" drop-down list, e.g. **Single-cell Study**.
  - Select a therapeutic area from the "Therapeutic area" drop-down list, e.g. **Oncology**.
  - Select some studies to query, e.g. ticking the study **GSF766955 (Lambrechts et al.)**.
  - There are 50K cells in this study. Let’s filter this down to look only for lung squamous cell using “Sample filter”, **Disease=“lung squamous cell carcinoma"**
  - You can also look for the expression of specific “Genes”, e.g. **CD79A**


We will add more examples. Please give us feedback and let us know if you'd like to see specific examples!
