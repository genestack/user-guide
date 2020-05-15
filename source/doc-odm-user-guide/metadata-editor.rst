Metadata Editor
+++++++++++++++

Study Browser allows to explore created studies and associated data as well as data sets pre-imported from external
resources and search for a specific data using facets and free-text search box.
Any obtained results you can explore further with Metadata Editor app.
Besides, in the Metadata Editor app curators can validate and make changes to the Study, Samples and any processed
metadata.

Getting to the Metadata Editor
------------------------------

When you click create a new study button on the Dashboard, Metadata Editor app is opened and suggests you to specify metadata template. By default the Default template is applied.
You can explore each template by hovering over it's name and clicking "Explore" link.
By default, new study contains two tabs, namely Study and Sample providing metadata for Study and Samples, respectively.


.. image:: images/open-me.png
   :scale: 40 %
   :align: center

To open an existing experiment with Metadata Editor click on the study name in the search results in the Study Browser application.

.. image:: images/open-me-1.png
   :scale: 40 %
   :align: center

Note that users not included in the **"Curator" group** do not have permissions to make changes (update metadata, change
templates etc.) for experiments which are not owned by them.

Exploring the Metadata Editor
-----------------------------

.. image:: images/open-me-2.png
   :scale: 35 %
   :align: center

Click on application name shows drop-down menu allowing to create new study ('New study...'), explore and/or change if it
is needed the applied template ('Default template' > 'Explore' or 'Apply another'), and open tutorials ('User Guide').

.. image:: images/me-dropdown.png
   :scale: 35 %
   :align: center

When you click on the study name, drop-down menu will appear allowing you to:

.. image:: images/me-dropdown-2.png
   :scale: 50 %
   :align: center

- **Share** data with your colleagues

.. image:: images/share.png
   :scale: 35 %
   :align: center

-  **Export** all data by creating a link that can be used to download data and can be shared with your coleagues

.. image:: images/export.png
   :scale: 35 %
   :align: center

- **Rename** study

.. image:: images/rename.png
   :scale: 35 %
   :align: center

- **Copy accession** of the study

.. image:: images/copy-accession.png
   :scale: 35 %
   :align: center

- **Get more information** about the study. For example you can learn when the study was created and modifige, who is
  the owner and which groups it is shared with.

.. image:: images/more-info.png
   :scale: 35 %
   :align: center

- **Explore and change metadata template** by clicking on "Explore" and **Apply another..**
  option in the drop-down menu.

.. image:: images/template_selection.png
   :scale: 35 %
   :align: center

There are several tabs that can be shown on the Metadata Editor page, namely Study, Samples, Expression (optional),
Variants (optional) which represent metadata describing experiment, samples and processed files,
such as transcriptomics data (GCT) and genomics data (VCF).


Study tab
*********

Study tab provides general information about the study, namely experiment description, contributors and their contact
details and so on.

.. image:: images/study-tab.png
   :scale: 50 %
   :align: center

To rename the study click on the study title link at the top of the page and select "Rename". Type in the new name and click the blue "Rename" button.

Columns containing invalid metadata are highlighted in red and **Invalid metadata** flag is specified.

.. image:: images/study-invalid-metadata.png
   :scale: 50 %
   :align: center

Click the Invalid metadata flag to explore validation summary and correct metadata.

.. image:: images/study-invalid-metadata.png
   :scale: 50 %
   :align: center



Samples tab
***********

Sample tab represents metadata describing each sample in the study. For example, here can be provided information about
organism, cell line, disease. Metadata columns coming from the applied template are highlighted in yellow.

**Add and delete samples**

When you create new study by default it contains four samples. You can add more samples or delete samples if necessary.
To add them, click on the "+" button, then in the appeared window specify number of samples you would like to add to the study and click **Add**.

.. image:: images/add-samples-1.png
   :scale: 35 %
   :align: center

.. image:: images/add-samples-2.png
   :scale: 35 %
   :align: center

To remove samples from your study, hover over samples you would like to exclude, select them, and click on the **Delete** button.

.. image:: images/delete-samples.png
   :scale: 35 %
   :align: center

**Filter samples by metadata**

If you need to narrow the list of samples shown in the study (for example, filter by organism to only samples obtained
from H. sapiens. To do so, click "Filters" button in the upper-left corner. This will show a metadata summary, where for
each metadata field the list of values  and the number of samples with this values are specified.

.. image:: images/filters-1.png
   :scale: 35 %
   :align: center

You can also start typing metadata value of your interest ("H. sapiens" in this case) to show only needed checkbox in the list of suggested meatadata values.

.. image:: images/filters-4.png
   :scale: 35 %
   :align: center

Click "Apply" button.

.. image:: images/filters-2.png
   :scale: 35 %
   :align: center

As a result only samples obtained from H. sapience are shown in the Samples  tab.

.. image:: images/filters-3.png
   :scale: 35 %
   :align: center




Metadata validation and curation
--------------------------------

**Curators** can not only view but also validate and edit metadata.

Metadata fields are checked against a specific template, each template contain specific list of metadata fields and rules for the Study, Samples and
processed/experimental metadata tabs. If some required metadata fields are missing, have typos
or entered values don't match the applied template, an **Invalid metadata" flag** is shown in the upper right corner, also,
invalid fields themselves are highlighted in red.


.. image:: images/invalid-metadata.png
   :scale: 40 %
   :align: center


To **correct metadata manually**, click the field you wish to change and type a new value.

.. image:: images/correct-manually.png
   :scale: 50 %
   :align: center


When all the fields in a tab have been corrected the Invalid metadata flag will be replaced with a green
“Metadata is valid” flag.
Metadata fields for which **dictionaries or ontologies** are specified in the template allow you to click the
triangle sigh and select a term from a list of suggested terms from the associated dictionary.
You can also start typing a term and auto-complete will help you to select an appropriate term from the dictionary.

.. image:: images/autocomplete.png
   :scale: 50 %
   :align: center

Values matching dictionary terms will be marked in green.

.. image:: images/green-term.png
   :scale: 40 %
   :align: center

Values in the metadata columns can be propagated by dragging the bottom-right corner of a cell.

.. image:: images/drug.png
   :scale: 35 %
   :align: center

To replace multiple values you can use **bulk replace** function. To do so, you should click the name a metadata field
including incorrect values and select "Bulk replace" option in the drop down list.

.. image:: images/bulk-replace-1.png
   :scale: 35 %
   :align: center

This will open **Replace values** window where you can specify correct values.

.. image:: images/bulk-replace-2.png
   :scale: 35 %
   :align: center

If the field is controlled by a dictionary then auto-complete suggestions will also appear
so that you can select a term from dictionary. Click **Replace in...** button to replace the incorrect metadata values
with the new terms.

.. image:: images/bulk-replace-3.png
   :scale: 35 %
   :align: center

If there are any filters applied , you can chose to replace values only for the samples
that match your filter. As a result, values for only the filtered samples will be changed.

Clicking on the Invalid metadata link or opens the **Validation Summary** pop-up window where the
invalid metadata terms will be shown. Click on a term you would like to update, immediately, **Replace values**
window will open, allowing you to type in the correct value.

Apart from editing metadata manually, user can also import and validate the metadata. Click Iimport icon in the upper right corner and select a local CSV or Excel file containing metadata you would like
to associate with the imported files.

.. image:: images/import-from-spreadsheet.png
   :scale: 40 %
   :align: center




















