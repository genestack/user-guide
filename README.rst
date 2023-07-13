Open Data Manager user guide
#############################

This repository contains source files for **ODM User Guide** documentation
generated and hosted by `ReadTheDocs <https://odm-user-guide.readthedocs.io/>`_
(see ``source/`` subdirectory).

Source files are in *reStructuredText* format, slightly similar to Markdown, but
still quite different.  If you are not familiar with it, a good place to start is
`reStructuredText Primer <https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html>`_.
Files in that format could be edited with any competent text editor and also
online here at *Github*.

To update documentation, one should be familiar with basic *git* and *Github*
concepts and workflows.  **ReadTheDocs** automatically builds two versions of
documentation:

- `default one (AKA "latest") <https://odm-user-guide.readthedocs.io/en/latest/>`_
  is built from *master* branch
- `"development" version <https://odm-user-guide.readthedocs.io/en/development/>`_
  is built from *development* branch

To make minor changes (fix a typo, update a link or an image, reword a
sentence), the following workflow is suggested:

1. Make the changes directly in *development* branches (in Github web editor or
   in your local clone) and commit them.
2. Wait for about 5 min for ReadTheDocs to build and deploy updated
   *development* version.
3. Check that result is as expected.
4. Merge changes from *development* to *master* branch.

If planned changes are major or require review before being merged, create a
new branch off *development* and merge it to *development* with Github PR.
Then proceed as per pp. 2–4.

"ODM User Guide" project at ReadTheDocs could be configured
`there <https://readthedocs.org/projects/odm-user-guide/>`_, but this is
Genestack admins' area of responsibility.

Generate documentation locally
******************************

- Install required tools and dependencies::

    python3 -m pip install Sphinx sphinx-rtd-theme

- Generate documentation::

    make html

- Open in browser::

    open _build/html/index.html
