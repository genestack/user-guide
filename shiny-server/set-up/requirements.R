install.packages("devtools")
install.packages("shinyjs")
install.packages("plotly")
install.packages("plyr")
install.packages("dplyr")
install.packages("tidyr")
install.packages("DT")
# install.packages("RCurl")
# install.packages("ggbeeswarm")
# install.packages("gridExtra")
# install.packages("tidyverse")

install.packages("ArvadosR",
                 repos=c("http://r.arvados.org", getOption("repos")["CRAN"]),
                 dependencies=TRUE)

devtools::install_github("trestletech/shinyStore")
