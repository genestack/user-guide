Gene-Transcript Mapping
+++++++++++++++++++++++

ODM provides the capability to import and link a gene-transcript mapping file.

What can I import?
------------------

A gene-transcript mapping file can be uploaded. This needs to be a TSV file consisting of two columns. The first row must contain the headers TXNAME and GENEID, and the first column must be the transcript IDs which must be unique. The file needs to be hosted at an HTTP/FTP location accessible to ODM.

+-------------------+--------------------+
| TXNAME            | GENEID             |
+===================+====================+
| ENST00000438176.2 | ENSG00000231103.2  |
+-------------------+--------------------+
| ENST00000445563.2 | ENSG00000226662.2  |
+-------------------+--------------------+

Metadata about the transcript mapped (for e.g. 'organism') can be supplied as key : value pairs in the body of the request when the mapping file is imported. See below for details.

Importing a gene-transcript mapping
-----------------------------------

You import gene-transcript mapping in two stages. First, import the mapping file. Then, link the mapping file to the expression matrix file (GCT). Importing uses ODM's APIs - you will need an API token (see :ref:`token-label` )

Importing the gene-transcript mapping file
******************************************

To import the gene-transcript mapping file submit a **POST** request to the **/gene-transcript-mapping** endpoint, with the body of the message containing a datalink of the URL of the file you wish to import, and any additional metadata:

.. literalinclude:: import-g-t-mapping.py

Because uploading is asynchronous the system returns confirmation message with a **jobExecId**. This can then be supplied as a **GET** request to the **/{jobExecId}​/output** endpoint to monitor status of the job, which when complete this will return the accession of the gene-transcript mapping object that has been created.

Linking the gene-transcript mapping file to an expression matrix file
*********************************************************************

To link the mapping file to expression data submit a **POST** request to the **/links** endpoint which can be found under the integrationCurator set of endpoints. The body of the request needs to supply accessions of the mapping file (returned after successful import) and the expression data file, together with a 'type' label which identifies which is which. See below for an example:

.. literalinclude:: link-g-t-mapping.py

Querying gene-transcript mappings
---------------------------------

To return the geneIDs for a given set of transcripts across all mapping files, supply the transcript IDs of interest to **GET** **/gene-transcript-mapping/genes?transcriptId=transcript1,transcriptId=transcript2**

To return the geneIDs for a given set of transcripts in a particular mapping file, supply the accession of the mapping file and the transcript IDs of interest to **GET** **/gene-transcript-mapping/{id}/genes?transcriptId=transcript1,transcriptID=transcript2**

To return the transcript IDs for a given list of geneIDs across all mapping files supply the genesIDs of interest to **GET** **/gene-transcript-mapping/transcripts?geneId=gene1&geneId=gene2**

To return the transcript IDs for a given list of geneIDs in a particular mapping files supply supply the accession of the mapping file and the genesIDs of interest to **GET** **/gene-transcript-mapping/{id}/transcripts?geneId=gene1&geneId=gene2**

Retrieving a mapping for given GeneIDs in a study
--------------------------------------------------

To look at the mapping for given genes in a study you need to:

1. Retrieve the accession of the expressionGroup of interest for a given study

Post **GET** to **/omics/expression/group?studyQuery=genestack:Accession=GSF123456**

2. Retrieve the accession for the mapping linked to that expression group (if more than one, choose one)

Post **GET** to the ​/links endpoint with the parameters:  firstId = accession of expression group, secondType = “geneTranscriptMapping”. The API endpoint returns an array of accessions, you can check each mapping file via the API endpoint **GET** **/gene-transcript-mapping/{id}** and choose the mapping of interest.

3. Retrieve transcript IDs for genes of interest

Post **GET** to the endpoint **/gene-transcript-mapping/{id}/transcripts?geneId=gene1&geneId=gene2** where gene1, gene2 eg are the Gene IDs of interest.

Performing OMICS queries using transcript IDs
---------------------------------------------

Transcript IDs can be provided to OMICS queries (**GET** **/omics​/expression/data**) by passing transcript IDs to the exQuery parameter using for example **"feature = ENST00000230368,ENST00000188976"**

Checking a mapping is available for a given expression data file
-------------------------------------------------------------------

The **/links** endpoint can be queried to determine which mapping files have been linked to a given expression data file. First use the endpoint **GET** with **"firstId = accession of expression group"**, and , **secondType = “geneTranscriptMapping”** to return the accession of the mapping file.

Then to view the mapping file supply this accession as the {id} in **GET** **/gene-transcript-mapping/{id}**.

It is also possible to add mapping file URL information to metadata templates in order to view this information in the GUI.

Checking which expression data files are linked to a given mapping file
-----------------------------------------------------------------------

The **/links** endpoint can be queried to determine which expression data files have been linked to a given mapping file (so you know which links to delete after removing the mapping file, for example). Send a **GET** request to the **/links** endpoint with **"firstId = accession of mapping file"**

Updating a gene-transcript mapping file
---------------------------------------

There is currently no method to update a mapping file, so to update a mapping the existing mapping file should be deleted and a new file uploaded.

Removing a gene-transcript mapping file
---------------------------------------

Mapping files can be deleted by sending a **DELETE** request to the **/gene-transcript-mapping/{id}** endpoint. It is possible to remove a mapping file regardless of whether the mapping file is linked to an expression data file or not. Any existing links are not removed by this endpoint, but instead need to be removed by sending a **DELETE** request to the **/links** endpoint. Likewise when a study is deleted, linked mapping files are not removed.
