Import Data Using Python Script
+++++++++++++++++++++++++++++++

This page demonstrates how to use the python load&link script to input data into ODM. Please note that you need to be a member of the curator group in ODM to be able to import and edit data in ODM.

Requirements
------------

You need to have:

- The load&link python script itself (this will be provided soon or can be requested)

- A Genestack API token

- A Study file containing metadata about the study in CSV or TSV format, hosted at an FTP or HTTP web address

- A Samples file containing metadata about the samples in CSV or TSV format, hosted at an FTP or HTTP web address

Optional experimental (signal) data files
-----------------------------------------

You can optionally also provide:

- Expression data in .gct format, hosted at an FTP or HTTP web address

- Expression metadata in CSV or TSV format, hosted at an FTP or HTTP web address

- Variant data in .vcf format, hosted at an FTP or HTTP web address

- Variant metadata in CSV or TSV format, hosted at an FTP or HTTP web address

- Flow cytometry data in .facs format, hosted at an FTP or HTTP web address

- Flow cytometry metadata in CSV or TSV format, hosted at an FTP or HTTP web address

Once imported, studies, samples, and signal metadata will be queryable and editable from both the User Interface and
APIs, whilst the signal data will only queryable via APIs.


Getting a Genestack API token
-----------------------------

Before you begin you will need a genestack API token.

To obtain a token, sign in to ODM via a web browser, click on your email address in the top right and select "Profile"

.. image:: images/import_data_script_profile.png
   :scale: 50 %
   :align: center

Then click the "Generate new token" button under API tokens:

.. image:: images/import_data_script_API_token.png
   :scale: 50 %
   :align: center

Script usage
------------

Run the script by typing:

.. literalinclude:: import-data-script-1.py


Optionally include data files by appending any or all of the following to the above command:

.. literalinclude:: import-data-script-2.py

.. literalinclude:: import-data-script-3.py

.. literalinclude:: import-data-script-4.py

