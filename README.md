# AI-powered pan-species computational pathology: bridging clinic and wildlife care


[![bio shield](https://img.shields.io/static/v1?label=bioRxiv&message=10.1101/2022.03.05.482261v1&color=RED)](https://www.biorxiv.org/content/10.1101/2022.03.05.482261v1)

<p align="center"> 
Khalid AbdulJabbar, Simon P. Castillo, Katherine Hughes, Hannah Davidson, Amy M. Boddy, Lisa M. Abegglen, Elizabeth P. Murchison, Trevor A. Graham, Simon Spiro, Chiara Palmieri, Yinyin Yuan
</p>

Contact: [Khalid AbdulJabbar](khalid.abduljabbar@icr.ac.uk), [Simon Castillo](simon.castillo@icr.ac.uk), or [Yinyin Yuan](yinyin.yuan@icr.ac.uk)

## Overview

### Reproducing paper results
For reproduction of te results we suggest to download and unzip this whole repository.

### Analysis of morphospace
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

finally, a higher resolution analysis of morphospace overlap between human an non-human spacies follows the label `#II. Species-specific overlap` (line 76). It includes data preparation, PCA and overlap. It computes an average human/non-human overlap for the two classes `#3. Average overlap for animal-l and animal-t per sp.` (line 120), which is correlated with species' specific model balanced accuracy `#4. Correlation between morphospace overlap and balanced accurracy`.




