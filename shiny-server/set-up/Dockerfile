FROM rocker/shiny

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
