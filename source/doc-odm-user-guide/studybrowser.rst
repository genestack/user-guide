Study Browser
+++++++++++++

The Study Browser is the main interface to quickly search and discover studies of interest.


Getting to the Study Browser
----------------------------
Click 'Browse studies' on the dashboard after you sign in to launch the Study Browser.

.. image:: images/quickstart_user_dashboard.png
   :scale: 65 %
   :align: center

You can also use the short cut dock in the top lefthand corner of any window.

.. image:: images/shortcut_dock.png
   :scale: 75 %
   :align: center


Exploring the Study Browser
---------------------------

.. image:: images/quickstart_user_studybrowser.png
   :scale: 30 %
   :align: center

At the top of the window is the main search bar. In the text box you can search by the name of a study, the accession of a study, sample or signal object, or by any text that is in any metadata field across all of the data you have visibility of.

As you begin typing you will be offered auto-complete suggestions based on dictionaries of terms that are present in ODM.

The search is synonym-aware, so if you type in 'human' the auto-complete suggests 'Homo sapiens' as the preferred label of humans.

The main panel displays the results of your search and filter options, if you have any, otherwise all studies are displayed that your user account has visibility of, ordered by date with the newest at the top.

Filter panel
************

The filter panel allows you to filter your results with search facets.

.. image:: images/studybrowser_searchpanel.png
   :scale: 35 %
   :align: center

Bookmarked studies can be shown by clicking on the Bookmarks icon. Access allows you to see your studies, those that are accessible to you (for example, public studies) or those that have been shared with your user account/group.

If there are additional facet terms a **Find more** link will be displayed. Clicking on this allows you to type in terms and you can select from the presented list of options.


.. image:: images/studybrowser_autocomplete.png
   :scale: 35 %
   :align: center

Exactly which metadata fields are available as search facets is determined by templates, which is also how you specify what metadata are expected to be seen for a given type of omics data, and which controlled vocabularies or ontologies should apply. 

Results panel
*************

.. image:: images/studybrowser_resultspanel.png
   :scale: 35 %
   :align: center

The main panel in the study browser shows the results of your search, or if no search terms/filters have been applied, all studies that you have visibility of. The first column displays the name of the study, and you can click this to look at the study in more detail. It also lists information about which user created or imported the study, and the date.

To the left of the study titles is a three dot link. Click this is open a menu that allows you to rename the study (if you have permission), copy the accession of the study, add it to your bookmarks, or view more information.

.. image:: images/three_dots_menu.png
   :scale: 35 %
   :align: center


The next column shows the type of the study. If there is information about the general type of study, for example: 'expression profiling by high throughput sequencing', or 'RNA-seq of coding RNA from Single Cells' then it is displayed here. 

The third column is a summary of the metadata that is associated with the study. This displays information such as the organism, tissue, cell-type, disease and so on and is pulled straight from the metadata fields of the samples in the study.

You can hover over any name in the summary column and the name of the metadata field where the data comes from will appear.

.. image:: images/studybrowser_tooltip.png
   :scale: 50 %
   :align: center

The next column tells us how many samples are present in each study.

The penultimate column shows what types of experimental signal data are present for each study. 

.. image:: images/studybrowser_signals.png
   :scale: 50 %
   :align: center

And finally you can use the bookmark flag at the end to flag studies for viewing later.
