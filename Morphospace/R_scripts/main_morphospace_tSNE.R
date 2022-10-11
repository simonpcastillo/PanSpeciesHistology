if (!require("pacman")) install.packages("pacman")
pacman::p_load(ggplot2, devtools, dynRB,reshape2,vegan,factoextra, dplyr, corrplot, ggrepel, tibble, Rtsne)
source('R_scripts/ggbiplot2.R')

######
##I. Species-specific overlap
######

#0. Data load and preparation
      animal = read.csv('Data/animal.csv')
      human = read.csv('Data/humanlung.csv')
      
      animal2= animal %>%
        filter(class %in% c('l','t')) %>%
        mutate(class2 = paste0('animal-',class))
      
      human2= human %>%
        filter(class %in% c('l','t')) %>%
        mutate(class2 = paste0('human-',class))
      
      merged = rbind(animal2, human2)
      merged.species <- merged[,35]

#1. tSNE
      species_meta <- merged %>%
      mutate(ID = 1:nrow(merged))%>%
      select(ID, sample, class, class2)


    tSNE_fit <- merged %>%
      mutate(ID = 1:nrow(merged))%>%
      select(where(is.numeric)) %>%
      column_to_rownames("ID") %>%
      scale() %>%
      Rtsne(check_duplicates=FALSE,perplexity=50, theta=0.0)


    tSNE_df <- tSNE_fit$Y %>%
      as.data.frame() %>%
      rename(tSNE1="V1",
             tSNE2="V2") %>%
      mutate(ID=row_number())


    tSNE_df <- tSNE_df %>%
      inner_join(species_meta, by="ID")

#2. Morphospace overlap over tSNE1 and tSNE2
    r_tsne <- dynRB_VPa(tSNE_df[,c(6,1:2)]);  r_tsne$result %>% View


#3. Morphospace overlap summary
    spname = c('CANFAM', 'MUSPUT', 'GALMOH', 'LEMCAT', 'PANTRO',
                 'DASBYR', 'SARHAR', 'MELURS','OSTTET', 'LEPFAL', 
                 'CYACYA','SPHHUM', 'CAPHIR', 'SUSBAR', 'LEOCHR',
                 'CRAHEA', 'NASNAS', 'GONOXY', 'VARPRA', 'BITARI')
    sample = unique(animal2$sample)
    sample2spname = data.frame(spname, sample)
      
    overlap_df= data.frame()

    for (o in 1:length(sample)) {
              animal3 = tSNE_df[tSNE_df$sample == sample[o],]
              merged3 = rbind(animal3, tSNE_df[tSNE_df$class2 %in% c('human-t', 'human-l'),])

              r_tsne <- dynRB_VPa(merged3[,c(6,1:2)]);

              overlap_hT_hL = r_tsne$result[r_tsne$result$V1 == 'human-l' & r_tsne$result$V2 == 'human-t' ,3]
              overlap_hT_aT = r_tsne$result[r_tsne$result$V1 == 'animal-t' & r_tsne$result$V2 == 'human-t' ,3]
              overlap_hT_aL = r_tsne$result[r_tsne$result$V1 == 'animal-l' & r_tsne$result$V2 == 'human-t' ,3]
              overlap_hL_hT = r_tsne$result[r_tsne$result$V1 == 'human-t' & r_tsne$result$V2 == 'human-l' ,3]
              overlap_hL_aT = r_tsne$result[r_tsne$result$V1 == 'animal-t' & r_tsne$result$V2 == 'human-l' ,3]
              overlap_hL_aL = r_tsne$result[r_tsne$result$V1 == 'animal-l' & r_tsne$result$V2 == 'human-l' ,3]
              overlap_aT_hT = r_tsne$result[r_tsne$result$V1 == 'human-t' & r_tsne$result$V2 == 'animal-t' ,3]
              overlap_aT_hL = r_tsne$result[r_tsne$result$V1 == 'human-l' & r_tsne$result$V2 == 'animal-t' ,3]
              overlap_aT_aL = r_tsne$result[r_tsne$result$V1 == 'animal-l' & r_tsne$result$V2 == 'animal-t' ,3]
              overlap_aL_hT = r_tsne$result[r_tsne$result$V1 == 'human-t' & r_tsne$result$V2 == 'animal-l' ,3]
              overlap_aL_hL = r_tsne$result[r_tsne$result$V1 == 'human-l' & r_tsne$result$V2 == 'animal-l' ,3]
              overlap_aL_aT = r_tsne$result[r_tsne$result$V1 == 'animal-t' & r_tsne$result$V2 == 'animal-l' ,3]

              spp = spname[o]

              if(length(overlap_hT_hL) == 0){overlap_hT_hL<- NaN}
              if(length(overlap_hT_aT) == 0){overlap_hT_aT<- NaN}
              if(length(overlap_hT_aL) == 0){overlap_hT_aL<- NaN}
              if(length(overlap_hL_hT) == 0){overlap_hL_hT<- NaN}
              if(length(overlap_hL_aT) == 0){overlap_hL_aT<- NaN}
              if(length(overlap_hL_aL) == 0){overlap_hL_aL<- NaN}
              if(length(overlap_aT_hT) == 0){overlap_aT_hT<- NaN}
              if(length(overlap_aT_hL) == 0){overlap_aT_hL<- NaN}
              if(length(overlap_aT_aL) == 0){overlap_aT_aL<- NaN}
              if(length(overlap_aL_hT) == 0){overlap_aL_hT<- NaN}
              if(length(overlap_aL_hL) == 0){overlap_aL_hL<- NaN}
              if(length(overlap_aL_aT) == 0){overlap_aL_aT<- NaN}


              overlap_df=rbind(overlap_df, data.frame(spp,
                                                      overlap_hT_hL,
                                                      overlap_hT_aT,
                                                      overlap_hT_aL,
                                                      overlap_hL_hT,
                                                      overlap_hL_aT,
                                                      overlap_hL_aL,
                                                      overlap_aT_hT,
                                                      overlap_aT_hL,
                                                      overlap_aT_aL,
                                                      overlap_aL_hT,
                                                      overlap_aL_hL,
                                                      overlap_aL_aT))
                                                      }


    ov_l= overlap_df[, c(1,12)]
    ov_t= overlap_df[, c(1,8)]
    names(ov_l) = names(ov_t) = c('Species.code', 'Overlap')
    over= rbind(ov_l,ov_t)
    over=over[complete.cases(over),]

#4. Average overlap for animal-l and animal-t per sp.
     sum_overlap = over %>%
          group_by(Species.code) %>%
          summarise_all(funs(mean))
        
#5. Correlation between morphospace overlap and balanced accurracy
    BAcc =read.csv('Data/Model_accuracy/Data/balancedAccuracy_classification.csv')
    colnames(sum_overlap)[1] <- colnames(BAcc)[1] <- 'Species.code'
    OvAc=merge(BAcc,sum_overlap, by='Species.code' )
    cor.test(OvAc$Overlap, OvAc$CBA)

        