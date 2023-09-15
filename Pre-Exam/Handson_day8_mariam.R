#Handson Day 8 
library(tidyverse)
df <- medicaldata::blood_storage
df %>% 
  mutate(PVol = log(PVol)) %>%
  aov(PVol~RBC.Age.Group, data = .)

ANOVAresult %>% 
  broom::tidy()


#Prepoptherapy variable: Binary (0,1)
#Check the assumptions to decide on which test to use 

#T-test, anova are parametric 
#non-parametric: MANN-Whitney (compares 2 groups not many groups)
#kruskal-wallis: non parametric groups, if it is significant, then one group is different from the other. if not significant, then this is where you stop, useless to proceed. 

#simple_regression 
#linear regression assumes linear relationship between two variables (gotta check the plot to see if I can fit a line, if scattered then it is pointless bec there is no linear relationship)

df %>% 
  lm(PVol~Age, data = .) %>%
  broom::tidy()
#lm(depedentent variable-Age (the one im trying to see the dependent variable on)

#Adding the confounders in the model
df %>% 
  lm(PVol~Age + PreopPSA, data = .) %>%
  broom::tidy()



