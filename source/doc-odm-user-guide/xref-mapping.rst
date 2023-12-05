Cross-reference Mapping
+++++++++++++++++++++++

ODM provides the capability to import and link a cross-reference (xref) mapping file. This allows you to look up genes for a given set of transcripts and vice versa. Mappings are associated with expression data files, but if desired all mapping files can be queried to return all mappings. Currently all mapping file operations are carried out via API.

What can I import?
------------------

An xref mapping file can be uploaded. This needs to be a TSV file consisting of two columns. The first row must contain the headers. The first column must be the transcript IDs which must be unique. The file needs to be hosted at an HTTPS location accessible to ODM.

+-------------------+--------------------+
| TXNAME            | GENEID             |
+===================+====================+
| ENST00000438176.2 | ENSG00000231103.2  |
+-------------------+--------------------+
| ENST00000445563.2 | ENSG00000226662.2  |
+-------------------+--------------------+

Metadata about the transcript mapped (for e.g. 'organism') can be supplied as key : value pairs in the body of the request when the mapping file is imported. See below for details.

Importing a cross-reference mapping
-----------------------------------

You import cross-reference mapping in two stages. First, import the mapping file. Then, link the mapping file to the data file. Importing uses ODM's APIs - you will need an API token (see :ref:`token-label` )

Importing the cross-reference mapping file
******************************************

To import the mapping file submit a **POST** request to the `/reference-data/xrefsets <<HOST>/swagger/?urls.primaryName=reference-data#/Xrefset%20queries/create>`_ endpoint, with the body of the message containing a datalink of the URL of the file you wish to import, and any additional metadata:

.. literalinclude:: import-g-t-mapping.py

Linking the mapping file to an expression matrix file
*********************************************************************

To link the mapping file to expression data submit a **POST** request to the `/links <<HOST>/swagger/?urls.primaryName=integrationCurator#/Linkage/saveLinks>`_ endpoint which can be found under the integrationCurator set of endpoints. The body of the request needs to supply accessions of the mapping file (returned after successful import) and the expression data file, together with a 'type' label which identifies which is which. See below for an example:

.. literalinclude:: link-g-t-mapping.py

Expression data can be linked to previously uploaded mapping files (even the mapping file is linked to a different expression data object) using the above linking.

Querying cross-reference mappings
---------------------------------

To return the entries across all mapping files, supply gene or transcript IDs of interest to the **GET** `/xrefsets/entries <<HOST>/swagger/?urls.primaryName=reference-data#/Xrefset%20queries/searchEntries>`_ endpoint.

To return the gene or transcript IDs for a given set of entries a particular mapping file, supply the accession of the mapping file and the transcript IDs of interest to the **GET** `/xrefsets/{id}/entries <<HOST>/swagger/?urls.primaryName=reference-data#/Xrefset%20queries/searchEntriesWithinFile>`_ endpoint


Retrieving the mapping for a given gene in a study
--------------------------------------------------

To look at the mapping for given genes in a study you need to:

1. Retrieve the accession of the expressionGroup of interest for a given study

Supply the study accession as the studyQuery parameter to **GET** `/omics/expression/group <<HOST>/swagger/?urls.primaryName=integrationCurator#/Omics%20queries/searchExpressionGroups>`_

2. Retrieve the accession for the mapping linked to that expression group (if more than one, choose one)

Submit a **GET** request to the /links `endpoint <<HOST>/swagger/?urls.primaryName=integrationCurator#/Linkage/getLinksByParams>`_ with the parameters:  firstId = accession of expression group, secondType = “geneTranscriptMapping”. The API endpoint returns an array of accessions, you can check each mapping file via the API endpoint **GET** `/xrefsets/{id}/metadata <<HOST>/swagger/?urls.primaryName=reference-data#/Xrefset%20queries/getDetailsByAccession>`_ and choose the mapping of interest.

3. Retrieve transcript IDs for genes of interest

Submit a **GET** request to the endpoint `/xrefsets/{id}/entries <<HOST>/swagger/?urls.primaryName=reference-data#/Xrefset%20queries/searchEntriesWithinFile>`_ supplying **geneId=gene1&geneId=gene2** where gene1, gene2 eg are the Gene IDs of interest to the sourceID parameter.

Performing OMICS queries using gene/transcript IDs
---------------------------------------------

Gene/transcript IDs can be provided to OMICS queries (**GET** `/omics​/expression/data <<HOST>/swagger/?urls.primaryName=integrationCurator#/Omics%20queries/searchExpressionData>`_) by passing gene/transcript IDs to the exQuery parameter using for example **"feature = ENST00000230368,ENST00000188976"**

Checking a mapping is available for a given expression data file
-------------------------------------------------------------------

The `/links <<HOST>/swagger/?urls.primaryName=integrationCurator#/Linkage/getLinksByParams>`_ endpoint can be queried to determine which mapping files have been linked to a given expression data file. First use the endpoint **GET** with **"firstId = accession of expression group"**, and , **secondType = “geneTranscriptMapping”** to return the accession of the mapping file.

Then to view the mapping file supply this accession as the {id} in **GET** `/xrefsets/{id}/metadata <<HOST>/swagger/?urls.primaryName=reference-data#/Xrefset%20queries/getDetailsByAccession>`_.

It is also possible to add mapping file URL information to metadata templates in order to view this information in the GUI.

Checking which expression data files are linked to a given mapping file
-----------------------------------------------------------------------

The `/links <<HOST>/swagger/?urls.primaryName=integrationCurator#/Linkage/getLinksByParams>`_ endpoint can be queried to determine which expression data files have been linked to a given mapping file (so you know which links to delete after removing the mapping file, for example). Send a **GET** request to the `/links <<HOST>/swagger/?urls.primaryName=integrationCurator#/Linkage/getLinksByParams>`_ endpoint with **"firstId = accession of mapping file"**

Updating a mapping file
---------------------------------------

There is currently no method to update a mapping file, so to update a mapping the existing mapping file should be deleted and a new file uploaded.

Removing a mapping file
---------------------------------------

Mapping files can be deleted by sending a **DELETE** request to the `/xrefsets/{id} <<HOST>/swagger/?urls.primaryName=reference-data#/Xrefset%20queries/deleteFile>`_ endpoint. It is possible to remove a mapping file regardless of whether the mapping file is linked to an expression data file or not. Any existing links are not removed by this endpoint, but instead need to be removed by sending a **DELETE** request to the `/links <<HOST>/swagger/?urls.primaryName=integrationCurator#/Linkage/deleteLink>`_ endpoint. Likewise when a study is deleted, linked mapping files are not removed.

Who can do what?
----------------

- To upload files, create and delete links: Users must be part of the curator user group

- To query mapping: Any user can do this. Mappings are shared across all members of an organisation

- To delete a mapping file: Only the uploader of a mapping file can delete it.
