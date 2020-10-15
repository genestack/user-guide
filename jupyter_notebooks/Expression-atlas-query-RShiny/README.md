R Shiny expression atlas examples

ODM APIs help you perform cross-study cross-omics analysis on-the-fly.

Here is an example of an API-driven R Shiny application that demonstrates how to develop a user interface to explore, search and visualise bulk and single-cell RNA-Seq data from public domain. This application can be easily modified/extended to support your custom analysis.

You can view the R scripts directly on GitHub. To modify/run the Shiny app yourselves, you need to:

- Generate your API token (see our user guide)
- Install [R](https://www.r-project.org/) or [RStudio](https://rstudio.com/) to directly run the app. Alternatively, install [Jupyter notebooks](https://jupyter.org/install) and also the [R kernel](https://github.com/IRkernel/IRkernel). This will allow you to run the Shiny app from Jupyter notebook.
- Prerequisite libraries:
  - R packages: 
    `intall.packages(c("shiny", "ggbeeswarm", "plyr", "gridExtra", "tidyverse", "httr", "RJSONIO"))`
  - Ask us for the ODM R client libraries (in this case, install "studyCurator", "integrationCurator"), and then
    `install.packages('<path to the r/integrationCurator folder>', repos = NULL, type="source")`

Run the Shiny application in the R console (R/RStudio/Jupyter notebooks)
- Copy and paste your API token to the "token" variable in scripts app.R and dictionaries_api.R (e.g. `token <- "<your token here>""`), and save the files
- Set your working directory to where the Shiny app folder is located using `setwd('~/shinyappfolder')`
- load Shiny package using `library(shiny)`
- Run the app using `runApp()`

Alternatively, run the Shiny application in a terminal or console window
- Copy and paste your API token to the "token" variable in both app.R and dictionaries_api.R (e.g. `token <- “<your token here>""`), and save the files
- Run the app using `R -e “shiny::runApp('~/shinyappfolder')"`

**Example queries:**
- Explore bulk RNA-Seq study:
  - Once you successfully load the Shiny app, a web-page style user interface will appear.
  On the left panel, there are multiple text boxes and drop-down lists that you can use to filter data for your analysis.
  - Select a type of study from the "Study Type", e.g. **Bulk Study**.
  - Select an area of interest in the "Therapeutic area" list, e.g. **Immunology**. You can either
    - Type in the term, and an automated matched list will be returned for you to choose from, OR
    - Directly select from the drop-down list.
  - Select a study by ticking one or more studies appeared underneath the "Therapeutic area", e.g. ticking the study **GSF1061557 (Reyes et al.)**.
  - Choose a gene of interest and type into the "Genes", e.g. **CD3E**.
  - You will be able to see both transcriptomic and proteomic data shown in the main panel under the "Beeswarm Plot" tab. You can also view relevant information in other tabs.
  - You can further filter the data using the "Cell types", e.g. typing in **lymphocyte**. Can you spot the difference? There are less cell types shown in the "Beeswarm Plot" and "Sample Info" tabs responding to the filter.
  - You can further filter the data using "Sample filter" (e.g. **Sex=female**) and "Expression filter" (e.g. **Source="RNA-Seq"**). All information in the "Sample Info" and "Expression Info" can be used to slice the data.
  - You can also query two genes at the same time, e.g. typing in **CD28** next to CD3E. Two plots are displayed for the chosen two genes.

Note: The EU Blueprint study has more granular cell types compared to the Reyes et al. study. To display expression data from both studies together, add 'lymphocyte' cell type filter, which will filter, merge, and show the cell types from both studies at the same level of granularity.

- Explore single cell RNASeq: similar to what you do with Bulk study
  - A new tab of “t-SNE plot” is available for single-cell expression data, which allows users to visualise clustering of different cell types based on their expression
  - Select a type of study from the "Study Type", e.g. **Single-cell Study**.
  - Select an area of interest in the "Therapeutic area" list, e.g. **Oncology**.
  - Select a study by ticking one or more studies appeared underneath the "Therapeutic area", e.g. ticking the study **GSF766955 (Lambrechts et al.)**. 
  - There are 50K cells in this study. Let’s filter this down to look only for lung squamous cell using “Sample filter”, **Disease=“lung squamous cell"**
  - You can also look for “Genes”, e.g. **CD79A**

Note: single-cell study queries usually take a bit longer to run using a laptop/desktop due to the large number of cells included in the study.

We will add more examples. Please give us feedback and let us know if you'd like to see specific examples!
