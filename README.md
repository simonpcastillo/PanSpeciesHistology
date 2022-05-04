# AI-powered pan-species computational pathology: bridging clinic and wildlife care


[![bio shield](https://img.shields.io/static/v1?label=bioRxiv&message=10.1101/2022.03.05.482261v1&color=RED)](https://www.biorxiv.org/content/10.1101/2022.03.05.482261v1)

<p align='center'>
    <img src= 'https://github.com/simonpcastillo/PanSpeciesHistology/blob/main/img/panspp.png' width="300" height="250">
 </p>


<p align="center"> 
Khalid AbdulJabbar, Simon P. Castillo, Katherine Hughes, Hannah Davidson, Amy M. Boddy, Lisa M. Abegglen, Elizabeth P. Murchison, Trevor A. Graham, Simon Spiro, Chiara Palmieri, Yinyin Yuan
</p>

Contact: [Khalid AbdulJabbar](mailto:khalid.abduljabbar@icr.ac.uk), [Simon Castillo](mailto:simon.castillo@icr.ac.uk), or [Yinyin Yuan](mailto:yinyin.yuan@icr.ac.uk)

To know more: [yuanlab.org](https://yuanlab.org/projects.html) 

## Overview

We  conducted the first pan-species study of computational comparative pathology using a supervised convolutional neural network algorithm trained on human samples and tested in 20 non-human species. The artificial intelligence algorithm achieves high accuracy in measuring immune response through single-cell classification for two transmissible cancers (canine transmissible venereal tumour, 0.94; Tasmanian devil facial tumour disease, 0.88). Furthermore, in 18 other vertebrate species (mammalia=11, reptilia=4, aves=2, and amphibia=1), accuracy (0.57-0.94) was influenced by cell morphological similarity preserved across different taxonomic groups, tumour sites, and variations in the immune compartment. 

A new metric, named morphospace overlap, was developed to guide rational deployment of this technology on new samples. This study provides the foundation and guidelines for transferring artificial intelligence technologies to veterinary pathology based on a new understanding of morphological conservation, which could vastly accelerate new developments in veterinary medicine and comparative oncology.

### Reproducing paper results
For the morphospace analysis we provided all the data necessary for reproducing our results. We suggest to download and unzip this whole repository.

### 1. AI-powered image analysis and single-cell feature extraction

The pipeline for image analysis is already publishes and validated. Details can be found at [Histology single-cell identification pipeline
](https://github.com/qalid7/compath).


### 2. Analysis of morphospace
Morphospace analysis bundle can be found in the [Morphospace folder](https://github.com/simonpcastillo/PanSpeciesHistology/tree/main/Morphospace). It runs on R/Rstudio platforms. In the [Morphospace folder](https://github.com/simonpcastillo/PanSpeciesHistology/tree/main/Morphospace), the `PanSpeciesHistology.Rproj` can be opened with Rstudio. The main script can be found at `R_scripts/main_morphospace.R`. The first three lines of the main script install (if necessary) and load the required packages and functions to your R environment.

    ```{r}
    if (!require("pacman")) install.packages("pacman")
    pacman::p_load(ggplot2, devtools, dynRB,reshape2,vegan,factoextra, dplyr, corrplot, ggrepel)
    source('Morphospace/R_scripts/ggbiplot2.R')
    ```
Under the label `#0. Data load and preparation`, there are the steps for preparing input data. The lines 10 and 11, load the input data to your R environment. The complete dataset is at [Morphospace/Data](https://github.com/simonpcastillo/PanSpeciesHistology/tree/main/Morphospace/Data). Then, data is formated according cell classes: animal lymphocytes (animal-l), human lymphocytes (human-l), animal tumour cells (animal-t), and human tumour cells (human-t).

    ```{r}
      animal = read.csv('Morphospace/Data/animal.csv')
      human = read.csv('Morphospace/Data/humanlung.csv')
      
      animal2= animal %>%
      filter(class %in% c('l','t')) %>
      mutate(class2 = paste0('animal-',class))
      
      human2= human %>%
      filter(class %in% c('l','t')) %>%
      mutate(class2 = paste0('human-',class))
    ```
Under the label `#1. PCA` (lines 24-26), the step for running a principal componen analysis on the data. Then, under the label `#2. Volumes overlap over PC1, PC2, and PC3` the step that compute volume overlap between the first three dimensions of the PCA. Code for plot-making are under the label `#3. PCA visualisation` (it makes a general plot across species).

<p align="center"> 
<img src="https://github.com/simonpcastillo/PanSpeciesHistology/blob/main/img/all.png" width="300" height="300">
</p>

Finally, a higher resolution analysis of morphospace overlap between human an non-human spacies follows the label `#II. Species-specific overlap` (line 76). It includes data preparation, PCA and overlap. It computes an average human/non-human overlap for the two classes `#3. Average overlap for animal-l and animal-t per sp.` (line 120), which is correlated with species' specific model balanced accuracy `#4. Correlation between morphospace overlap and balanced accurracy`.




