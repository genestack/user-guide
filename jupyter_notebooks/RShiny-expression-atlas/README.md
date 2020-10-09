R Shiny expression atlas examples

ODM APIs help you perform cross-study cross-omics analysis on-the-fly. 

Here is an example of an API-driven R Shiny application that demonstrates how to develop a user interface to explore, search and visualise bulk and single-cell RNA-Seq data from public domain. This application can be easily modified/extended to support your custom analysis.

You can view the R scripts directly on GitHub. To modify/run the Shiny app yourselves, you need to:

1. Generate your API token (see our user guide)
2. Install R (https://www.r-project.org/) or RStudio (https://rstudio.com/) to directly run the app. Alternatively, install Jupyter notebooks (see https://jupyter.org/install) and also the R kernel (see https://github.com/IRkernel/IRkernel). This will allow you to run the Shiny app from Jupyter notebook.
3. Prerequisite:
    - R packages: intall.packages(c("shiny", "ggbeeswarm", "plyr", "gridExtra", "tidyverse", "httr", "RJSONIO"))
    - Ask us for the ODM R client libraries, and then install.packages(c("studyCurator", "integrationCurator"))
4. To run the Shiny application in the R console (R/RStudio/Jupyter notebooks)
    - Copy and paste your API token to the "token" variable in both app.R and dictionaries_api.R (e.g. token <- "xxxxxxxxx""), and save the files
    - Set your working directory to where the Shiny app folder locates using setwd('~/shinyappfolder')
    - load Shiny package using library(shiny)
    - Run the app using runApp()   
5. To run the Shiny application in a terminal or console window
    - Copy and paste your API token to the "token" variable in both app.R and dictionaries_api.R (e.g. token <- "xxxxxxxxx""), and save the files
    - Run the app using R -e "shiny::runApp('~/shinyappfolder')"

Example queries: Explore bulk RNA-Seq study:
1. Once you successfully load the Shiny app, a web-page styple user interface will appear.
2. On the left panel, there are multiple textboxes and drop-down lists that you can use to filter data for your analysis.
3. Select a type of study from the "Study Type", e.g. Bulk Study.
4. Select an area of interest in the "Therapeutic area" list, e.g. Immunology. You can either (a) type in the term, and an automated matched list will be returned for you to choose from, or (b) you can directly select from the drop-down list.
5. Select a study by ticking one or more studies appearred underneath the "Therapeutic area", e.g. ticking the study GSF766459.
6. Choose a gene of interest and type into the "Genes", e.g. CD3E.
7. You will be able to see both transcriptomic and proteomic data shown in the main panel under the "Beeswarm Plot" tab. You can also view relevant information in other tabs.
8. You can further filter the data using the "Cell types", e.g. typing in lymphocyte. Can you spot the difference? There are less cell types shown in the "Beeswarm Plot" and "Sample Info" tabs responding to the filter.
9. You can further filter the data using "Sample filter" (e.g. Sex=female) and "Expression filter" (e.g. Source="RNA-Seq"). All information in the "Sample Info" and "Expression Info" can be used to slice the data.
10. You can also query two genes at the same time, e.g. typing in CD28 next to CD3E. Two plots are displayed for the chosen two genes.
    
We will add more examples. Please give us feedback and let us know if you'd like to see specific examples!

