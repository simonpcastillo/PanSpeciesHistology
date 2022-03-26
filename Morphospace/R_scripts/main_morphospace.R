if (!require("pacman")) install.packages("pacman")
pacman::p_load(ggplot2, devtools, dynRB,reshape2,vegan,factoextra, dplyr, corrplot, ggrepel)
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

#1. PCA
      pca2 <- prcomp(merged[, c(6,9:34)], scale = T) #All morphometric features
      mergedwithPCA = cbind(merged, pca2$x) #Bind PCA axis values to the morphometric features

#2. Volumes overlap over PC1, PC2, and PC3
      r <- dynRB_VPa(mergedwithPCA[,c(35,36:38)]);  r$result %>% View

#3. PCA visualisation
      #a. biplot
      ggbiplot2(pca2, choices = c(1,2), obs.scale = 1, 
                var.scale = 1, 
                groups = merged.species, ellipse = TRUE, var.col = 'gray30',
                circle = FALSE, alpha=0.03, varname.abbrev = FALSE, var.axes = F) + 
        #guides(color='none')+
        scale_color_manual(values = c('blue', 'greenyellow','darkturquoise', 'darkgreen'))+
        geom_hline(yintercept = 0, lty=2, lwd=.2, col='red')+
        geom_vline(xintercept = 0, lty=2, lwd=.2, col='red')+
        coord_fixed(ratio = 1)+
        theme_minimal()
      #b. variance explained by dimensions
      fviz_eig(pca2, addlabels = TRUE, ylim = c(0, 55),
               barfill = 'gray70',linecolor = 'blue',barcolor = 'gray70',main = '', 
               ylab='Explained variance (%)',
               xlab= 'PCA dimensions',
      ) +
        scale_y_continuous(breaks = seq(0,60,by=10))
      
      #c. Features contributions
      ## to PC1
      fviz_contrib(pca2, choice = "var", axes = 1, top = 20,color='gray70', fill = 'gray70', title='')+
        theme(axis.text.x = element_text(size = 8)) +
        scale_y_continuous(limits = c(0,25))
      
      ## to PC2
      fviz_contrib(pca2, choice = "var", axes = 2, top = 20,color='gray70', fill = 'gray70', title='')+
        theme(axis.text.x = element_text(size = 8)) +
        scale_y_continuous(limits = c(0,25))
      
      ## to PC3
      fviz_contrib(pca2, choice = "var", axes = 3, top = 20,color='gray70', fill = 'gray70', title='')+
        theme(axis.text.x = element_text(size = 8)) +
        scale_y_continuous(limits = c(0,25))
      
      #3d. Features correlation with dimensions, importance and contribution
      var <- get_pca_var(pca2)
      corrplot(var$cor[,1:3], is.corr=FALSE,col.lim = c(-1,1), tl.col='black',cl.align.text = 'l')

      corrplot(var$cos2[,1:3], is.corr=FALSE,tl.col = 'black',col = viridis::cividis(n=200), cl.align.text = 'l')

      corrplot(var$contrib[,1:3], is.corr=FALSE, col = viridis::viridis(n=200), , tl.col = 'black',cl.align.text = 'l')

######
#II. Species-specific overlap
######
      
#0. Data preparation
      spname = c('CANFAM', 'MUSPUT', 'GALMOH', 'LEMCAT', 'PANTRO',
                 'DASBYR', 'SARHAR', 'MELURS','OSTTET', 'LEPFAL', 
                 'CYACYA','SPHHUM', 'CAPHIR', 'SUSBAR', 'LEOCHR',
                 'CRAHEA', 'NASNAS', 'GONOXY', 'VARPRA', 'BITARI')
      sample = unique(animal2$sample)
      sample2spname = data.frame(spname, sample)
      
      overlap_df= data.frame()
      for (o in 1:length(sample)) {
        
        animal3 = animal2[animal2$sample == sample[o],]
        
        
        merged3 = rbind(animal3, human2)
        merged.species3 <- merged3[,35]
        unique(merged3$class2)
        
#1. PCA
        pca3 <- prcomp(merged3[, c(6,9:34)], scale = T) #All morphometric features
        mergedwithPCA = cbind(merged3, pca3$x) #Bind PCA axis values to the morphometric features
        
#2. Volumes overlap
        r <- dynRB_VPa(mergedwithPCA[,c(35,36:38)])
        
        overlap_l = r$result[r$result$V1 == 'human-l' & r$result$V2 == 'animal-l' ,3] #Fraction of animal-l covered by human-l
        overlap_t = r$result[r$result$V1 == 'human-t' & r$result$V2 == 'animal-t' ,3] #Fraction of animal-t covered by human-t
        spp = spname[o]
        
        if(length(overlap_l) == 0){overlap_l<- NaN}
        if(length(overlap_t) == 0){overlap_t<- NaN}
        overlap_df=rbind(overlap_df, data.frame(spp, overlap_l, overlap_t))
        
      }
  
        ov_l= overlap_df[, 1:2]
        ov_t= overlap_df[, c(1,3)]
        names(ov_l) = names(ov_t) = c('Species.code', 'Overlap')
        over= rbind(ov_l,ov_t)
        over=over[complete.cases(over),]
      
#3. Average overlap for animal-l and animal-t per sp.
        sum_overlap = over %>%
          group_by(Species.code) %>%
          summarise_all(funs(mean))    
        
        
#4. Correlation between morphospace overlap and balanced accurracy
        BAcc =read.csv('Data/Model_accuracy/Data/balancedAccuracy_classification.csv')
        colnames(sum_overlap)[1] <- colnames(BAcc)[1] <- 'Species.code'
        
        OvAc=merge(BAcc,sum_overlap, by='Species.code' )
        cor.test(OvAc$Overlap, OvAc$CBA)
    
        OvAc%>%
        ggplot(aes(Overlap*100, CBA, label= Species.code))+
          geom_point()+
          labs(x='Mean morphospace overlap (%)', y = 'Balanced accuracy')+
          geom_text_repel(size=3)+
          theme_minimal()      

        