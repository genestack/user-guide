Supported Signal Data Files
++++++++++++++++++++++++++++

Expression data
---------------

**GCT (Gene Cluster Text, .gct)** file is a tab-delimited text file containing gene expression data
(e.g. microarray, RNA-seq data). GCT is automatically recognised as an Expression file in ODM.

.. image:: images/gct-file.png
   :scale: 75 %
   :align: center

The first line contains the version: #1.2
The second line shows the number of rows (‘56202’) and columns (‘2’) in the data matrix.
The third line shows unique column headings: ‘gene_id’, ‘Description’, ‘Bladder’ etc.
The first left column shows unique values (e.g. Ensembl gene ID), the second one contains
metadata (‘DDX11L1’). The raw expression values are shown in the bottom right part of the file.
Each column corresponds to a separate assay (expression data measured in  a specific tissue);
each row of the data matrix shows an expression value, for example, of a particular gene.

To learn more take a look at the GCT specification_.

.. _specification: http://software.broadinstitute.org/cancer/software/genepattern/gp_guides/file-formats/sections/gct

.. [broken link; another option => https://software.broadinstitute.org/software/igv/GCT]

Variant data
------------

In ODM a Variant Data file corresponds to VCF. **VCF (Variant Call Format, .vcf)** is the tab-delimited text file containing information about the position of genetic variations in the genome. Output of variant calling analysis.

.. image:: images/vcf-file.png
   :scale: 55 %
   :align: center

Basic structure of VCF
**********************

The file contains three main parts:

- *Meta-information lines* (marked with “##”) — includes VCF format version number (##fileformat=VCFv4.3);
- *FILTER lines* (filters applied to the data, e.g. ##FILTER=<ID=LowQual, Description="Low quality">” ), FORMAT and INFO lines (explanations for abbreviations in the FORMAT and INFO columns of data lines,  e.g. “##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">”);
- *Header line* (marked with “#”) — includes eight mandatory columns, namely #CHROM (chromosome), POS (genomic position), ID (identifier), REF (reference allele), ALT (alternate allele(s)), QUAL (Phred-scaled quality score for ALT), FILTER (filter status, where “PASS” means that this position has passed all filters), INFO (additional information described in the header lines, e.g. “DP=100”);
- *Data lines* — provide information about a genomic position of a variation and genotype information on samples for each position; each line represents a single variant, represented in the header.

To learn more take a look at the VCF specification_.

.. _VCF specification: https://samtools.github.io/hts-specs/VCFv4.3.pdf

Flow cytometry data
-------------------

**FACS (.facs)** file is a TXT file with tab-delimited table that stores quantification data for proteins.

Annotation Table
****************

Annotation table file is tab-delimited table. Each row is one sample, each column is one property type (first column contains unique identifiers of each sample).

.. image:: images/facs-annot.png
   :scale: 55 %
   :align: center

Signal Table
************

Tab-delimited file, where first columns describe features; then, each column corresponds to one sample.

.. image:: images/facs-signals.png
   :scale: 75 %
   :align: center

Each row in the file is one feature:

- *Cytokine MFI* —  just one protein identifier. MFI = Mean/Median Fluorescence Intensity.
- *Cell counts* — a combination of cell markers (=genes/proteins) and modifiers: positive (+), negative (-), high(hi), low(lo), intermediate(int).
- *MFI_CellMarker* — like counts, but the intensity of one particular cell marker on a given cell subpopulation defines as for counts is measured.
- *Percentage* — like counts, but the percentage of cells positive/negative for a particular cell marker relative to the parent population as defined like for cell counts is provided.

Cell populations can have nicknames, e.g. CD45+CD3+CD4+FOXP3+ (’MarkerCombination’) cells are also called Tregs.
