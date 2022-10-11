# AI-powered pan-species computational pathology: bridging clinic and wildlife care


[![bio shield](https://img.shields.io/static/v1?label=bioRxiv&message=10.1101/2022.03.05.482261v1&color=RED)](https://www.biorxiv.org/content/10.1101/2022.03.05.482261v1)

<p align='center'>
    <img src= 'https://github.com/simonpcastillo/PanSpeciesHistology/blob/main/img/panspp.png' width="300" height="250">
 </p>


<p align="center"> 
Khalid AbdulJabbar, Simon P. Castillo, Katherine Hughes, Hannah Davidson, Amy M. Boddy, Lisa M. Abegglen, Elizabeth P. Murchison, Trevor A. Graham, Simon Spiro, Carlo C. Maley, Luca Aresu, Chiara Palmieri, Yinyin Yuan
</p>

Contact: [Khalid AbdulJabbar](mailto:khalid.abduljabbar@icr.ac.uk), [Simon Castillo](mailto:simon.castillo@icr.ac.uk), or [Yinyin Yuan](mailto:yyuan6@mdanderson.orh)

To know more: [panspecies.ai](https://panspecies.ai) | [yuanlab.org](https://yuanlab.org/projects.html) 

## Overview

We  conducted the first pan-species study of computational comparative pathology using a supervised convolutional neural network algorithm trained on human samples and tested in 20 non-human species. The artificial intelligence algorithm achieves high accuracy in single-cell classificationacross species and proved to contribute to the scoring of immune infiltration through the use of spatial statistics.

A new metric, named morphospace overlap, was developed to guide rational deployment of this technology on new samples and improve the interpretation of performance metrics. This study provides the foundation and guidelines for transferring artificial intelligence technologies to veterinary pathology based on a new understanding of morphological conservation, which could vastly accelerate new developments in veterinary medicine and comparative oncology.

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
From the label `#1. tSNE` (line 24), the pipeline starts computing tSNE dimension reduction and posterior computation of morphospace overlap resulting in a dataframe (sum_overlap) with summary overlap for each species of the cohort 0 and cells used for training the human-lung model.
<p align="center"> 
<img src="https://github.com/simonpcastillo/PanSpeciesHistology/blob/main/img/all.png" width="300" height="300">
</p>




