if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyr, betareg, emmeans, lmtest, multcompView)


df_Acc = read.csv('Model_accuracy/Data/CompleteAccuracy_classification.csv')


# 1. Comparing overall balanced accuracy accross tumours types
      
      shapiro.test(df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('mean'),]$values  )
      anova(aov(data=df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('mean') & df_Acc$Tumor.type!='Sex-cord stromal',], values~Tumor.type))
      mean(df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('mean') & df_Acc$Tumor.type!='Sex-cord stromal',]$values, na.rm = TRUE)
      
      # Correlation between balanced accuracy and number of annotations per sample
      cor.test(df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('mean'),]$values, 
                         df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('mean'),]$total)
      
      # Test difference in the balanced accuracy between tumour types (Sex-cord stromal, N=1)
      mod0 <- betareg(data=df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('mean') & !is.na(df_Acc$values) & df_Acc$Tumor.type != 'Sex-cord stromal',], 
                      values~Tumor.type, link = "logit")
      mod0a <- betareg(data=df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('mean') & !is.na(df_Acc$values) & df_Acc$Tumor.type != 'Sex-cord stromal',], 
                       values~1, link = "logit")
      lrtest(mod0a, mod0)
      summary(mod0)
      marginal0 = emmeans(mod0, ~ Tumor.type)
      pairs(marginal0, adjust="tukey")



# 2. Comparing lymphocytes, cnacer cells and stromal cells' balanced accuracy accross tumours types

      #Lymphocyes
      modLa <- betareg(data=df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('Lymphocyte') & !is.na(df_Acc$values) & df_Acc$Tumor.type != 'Sex-cord stromal',], 
                       values~1, link = "logit")
      modLb <- betareg(data=df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('Lymphocyte') & !is.na(df_Acc$values) & df_Acc$Tumor.type != 'Sex-cord stromal',], 
                       values~Tumor.type, link = "logit")
      lrtest(modLa, modLb)
      summary(modLb)
      
      marginal = emmeans(modLb, ~ Tumor.type)
      pairs(marginal, adjust="tukey")
      
      #Tumour cells
      mod2a <- betareg(data=df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('Cancer') & !is.na(df_Acc$values) & df_Acc$Tumor.type != 'Sex-cord stromal',], 
                       values~1, link = "logit")
      mod2 <- betareg(data=df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('Cancer') & !is.na(df_Acc$values) & df_Acc$Tumor.type != 'Sex-cord stromal',], 
                      values~Tumor.type, link = "logit")
      lrtest(mod2a,mod2)
      summary(mod2)
      
      marginal2 = emmeans(mod2, ~ Tumor.type)
      pairs(marginal2, adjust="tukey")
      
      #Stromal cells
      modSa <- betareg(data=df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('Stromal') & !is.na(df_Acc$values) & df_Acc$Tumor.type != 'Sex-cord stromal',], 
                       values~1, link = "logit")
      modSb <- betareg(data=df_Acc[df_Acc$X == 'Balanced Accuracy' & df_Acc$class %in% c('Stromal') & !is.na(df_Acc$values) & df_Acc$Tumor.type != 'Sex-cord stromal',], 
                       values~Tumor.type, link = "logit")
      
      lrtest(modSa, modSb)
      summary(modSb)
      marginal3 = emmeans(modSb, ~ Tumor.type)
      pairs(marginal3, adjust="tukey")