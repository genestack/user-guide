Metadata Editor
+++++++++++++++

Study Browser allows to explore created studies and associated data as well as data sets pre-imported from external
resources and search for a specific data using facets and free-text search box.
Any obtained results you can explore further with Metadata Editor app.
Besides, in the Metadata Editor app curators can validate and make changes to the Study, Samples and any processed
metadata.

Getting to the Metadata Editor
------------------------------

When you create a new study Metadata Editor immediately opens and suggests you to specify metadata template. By default the Default template is applied.
You can explore each template by hovering over it and clicking "Explore".
By default, new study contains two tabs, namely Study and Sample; Sample tab includes four samples.

.. image:: images/open-me.png
   :scale: 40 %
   :align: center

To open an existing experiment with Metadata Editor click on the study name in the search results in the Study Browser application.

.. image:: images/open-me-1.png
   :scale: 40 %
   :align: center

Note that users not included in the group "Curator" do not have permissions to make changes (update metadata, change
templates etc.) for experiments they are not owners of.

Exploring the Metadata Editor
-----------------------------

.. image:: images/open-me-2.png
   :scale: 40 %
   :align: center

Click on application name shows drop-down menu allowing to create new study ('New study...'), explore applied template or
change it if needed ('Default template' > 'Explore' or 'Apply another'), and open tutorials ('User Guide').

.. image:: images/me-dropdown.png
   :scale: 35 %
   :align: center

When you click on the study name, you can:

- **Share** data with your colleagues

.. image:: images/share.png
   :scale: 35 %
   :align: center

-  **Export** all data with Export data application

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

- **Get more information** about the study

.. image:: images/more-info.png
   :scale: 35 %
   :align: center

- **Explore and change metadata template**
Template applied to a dataset can be changed by clicking the **Apply another..**
option from the study title drop-down menu.

.. image:: images/template_selection.png
   :scale: 35 %
   :align: center

There are several tabs on the Metadata Editor page, namely Study, Samples, Expression (optional), Variants (optional),
FACS (optional), which represent metadata describing experiment, samples and processed files.

Study tab
*********


.. image:: images/study-tab.png
   :scale: 50 %
   :align: center

To rename the study click on the study title link at the top of the page and select "Rename". Type in the new name and click the blue "Rename" button.

Columns containing invalid metadata are highlighted in red and **Invalid metadata** flag is specified.

.. image:: images/study-invalid-metadata.png
   :scale: 50 %
   :align: center

Click the flag to explore validation summary and correct metadata.

.. image:: images/study-invalid-metadata.png
   :scale: 50 %
   :align: center



Samples tab
***********

Sample tab represents metadata for ech sample in the study.
Metadata columns coming from the applied template are highlighted in yellow.

.. Filter metadata


**Add and delete samples**

When you create new study by default it contains four samples. You can add more samples or delete samples if necessary.
To add them, click on the "+"-sign , then in the appeared window specify number of samples you would like to add to the study and click **Add**.

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



Metadata validation and curation
********************************

**Curators** can not only view but also validate and edit metadata.

Metadata fields are checked against a specific template, each template contain specific list of metadata fields and rules for the Study, Samples and
processed/experimental metadata tabs. If some required metadata fields are missing, have typos
or entered values don't match the applied template, an **Invalid metadata" flag** is shown in the upper right corner, also,
invalid fields themselves are highlighted in red.


.. image:: images/invalid-metadata.png
   :scale: 50 %
   :align: center


To **correct metadata manually**, click the field you wish to change and type a new value.
When all the fields in a tab have been corrected the Invalid metadata flag will be replaced with a green
“Metadata is valid” flag.
Metadata fields for which **dictionaries or ontologies** are specified in the template allow you to click the
triangle sigh and select a term from a list of suggested terms from the associated dictionary.
You can also start typing a term and auto-complete will help you to select an appropriate term from the dictionary.
Values matching dictionary terms will be marked in green.

Values in the metadata columns can be propagated by dragging the bottom-right corner of a cell.
To replace multiple values you can use **bulk replace** function. To do so, you should click the name a metadata field
including incorrect values and select "Bulk replace" option in the drop down list. This will open **Replace values**
window where you can specify correct values.
If the field is controlled by a dictionary then auto-complete suggestions will also appear
so that you can select a term from dictionary. Click **Replace in...** button to replace the incorrect metadata values with the new terms.
If there are any filters applied (for example, "Sex" - "male"), you can chose to replace values only for the samples
that match your filter. As a result, values for only the filtered samples will be changed.

Clicking on the Invalid metadata link or opens the **Validation Summary** pop-up window where the
invalid metadata terms will be shown. Click on a term you would like to update, immediately, **Replace values**
window will open, allowing you to type in the correct value.

Apart from editing metadata manually, user can also import and validate the metadata. Click Import data from spreadsheet button and select a local CSV or Excel file containing metadata you would like
to associate with the imported files.

.. image:: images/import-from-spreadsheet.png
   :scale: 50 %
   :align: center




















