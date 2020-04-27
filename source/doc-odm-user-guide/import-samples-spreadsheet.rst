Import Samples Spreadsheet
++++++++++++++++++++++++++

If your study doesn't already have samples metadata with linked data (for example you have just created a new study) it is possible to import a spreadsheet of samples metadata through the GUI. This functionality is available in the Metadata Editor, on the samples tab.


Requirements
------------

You need a study which has no previously uploaded sample information that is linked to data.

You need a TSV format file (with a filename extension of .tsv) containing sample information. The first row of the table is a list of the metadata attribute names, which must not be duplicated.
See the example below:

- `Test_1000g.samples.tsv`_, a tab-delimited file of sample attributes.

.. _`Test_1000g.samples.tsv`: https://s3.amazonaws.com/bio-test-data/odm/Test_1000g/Test_1000g.samples.tsv

+----------------------+------------------+--------------+-----+------------+
| Sample Source        | Sample Source ID | Species      | Sex | Population |
+======================+==================+==============+=====+============+
| 1000 Genomes Project |     HG00119      | Homo sapiens |  M  | British    |
+----------------------+------------------+--------------+-----+------------+
| 1001 Genomes Project |     HG00121      | Homo sapiens |  F  | British    |
+----------------------+------------------+--------------+-----+------------+
| 1002 Genomes Project |     HG00183      | Homo sapiens |  M  | Finnish    |
+----------------------+------------------+--------------+-----+------------+
| 1003 Genomes Project |     HG00176      | Homo sapiens |  F  | Finnish    |
+----------------------+------------------+--------------+-----+------------+

Metadata editor
---------------

To import samples via the GUI you need to go to the Metadata Editor and then the samples tab. Each new study will be populated with some dummy sample entries but these will be deleted when you import a samples file.

Click on the cloud icon to the right of the samples tab:

.. image:: images/import-sample-icon.png
   :scale: 80 %
   :align: center

This will open a dialogue box that prompts you to select a local TSV file.

.. image:: images/import-dialogue.png
   :scale: 50 %
   :align: center

Once you have selected a .tsv file a preview of the import is shown:

.. image:: images/import-sample-preview.png
   :scale: 50 %
   :align: center

Click the import button and the samples will now be visible in the samples tab. Any previous sample metadata will be deleted.
