### Structure of the folder

```
set-up/
|-- Dockerfile
|-- requirements.R
|-- ODM-API-Clients/
|   |-- r/
|   |   |- ...

reports/
|- homepage/
|  |- app.R
|- cohort-report-viewer/
|  |- app.R
|- ...
```

Directory `set-up` contains a `Dockerfile`, list of R requirements (`requirements.R`) and a directory `ODM-API-Clients`, where <u>one should store</u> the freshest versions of the ODM API R clients (for ex. from https://ci.genestack.com/buildConfiguration/OdmUnified_BuildArtefacts_BuildRestApiClient/437070?buildTab=artifacts).

Directory `reports` contains a list of R Shiny web applications, one folder for one application. Main file of the application must be named as `app.R` to be recognised by `shiny-server`.

### Run dockerized shiny-server 

After downloading ... one should do the following steps.

1. Build `shiny-server` docker image (all commands should be called form the `shiny-server` directory):

   ```bash
   docker build set-up -t shiny-server
   ```

2. Run a docker container from image (port 3838 should be available):

   ```bash
   docker run --rm -p 3838:3838 -v $PWD/reports/:/srv/shiny-server/ shiny-server
   ```

If the run is successful you should see a list of the applications from the `reports` directory at http://localhost:3838. Each app is available under the link `localhost:3838/application-name/`, where `application-name` is a name of the corresponding directory.
