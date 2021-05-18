FROM rocker/shiny

# Reuirements for `tidyverse`.
# Why do we user `tidyverse`? Expression Atlas app uses...
RUN apt-get update && apt-get install -y libxml2-dev

# Install required R libraries.
ADD requirements.R /tmp/
RUN Rscript /tmp/requirements.R

# Install ODM API Clients.
RUN mkdir -p /tmp/r
ADD ./ODM-API-Clients/r /tmp/r/

RUN for package in /tmp/r/*; do Rscript -e "devtools::install(\"${package}\")"; done

EXPOSE 3838
CMD ["/usr/bin/shiny-server"]

# docker run -p 3838:3838 -v ~/dev/reports/:/srv/shiny-server/ rocker/shiny
