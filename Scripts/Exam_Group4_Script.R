#Retrieving packages
library(tidyverse)
library(here)
library(skimr)
library(naniar)

#Reading the data 
myData<-read_delim(here("data", "exam_data.txt"))
myData

#Viewing_Data
view(myData)
summary(myData)
glimpse(myData)
skim(myData)

#Viewing_headandtail
head(myData,7)
tail(myData,15)

#Exploring the missing 
gg_miss_case(myData)

#Checking_duplication
myData %>% 
count(patient_id, sort = TRUE)
duplicated(myData, incomparables = FALSE, fromLast = FALSE)

#Removing the unnecessary columns (year, month, baseline_esr_cat)
#month
myData<-myData
  myData <- subset(myData, select = -c(month))
view(myData)

#year
myData<-myData
myData <- subset(myData, select = -c(year))
view(myData)

#baseline_esr_cat 
myData<-myData
myData <- subset(myData, select = -c(baseline_esr_cat))
view(myData)

#merging_datasets
myData22<-read_delim(here("data", "exam_data_join.txt"))
myData%>%
  full_join(myData22, join_by("patient_id")) %>% 
  view()


#Seperating gender_arm 
myData<- myData %>% 
  separate(col = gender_arm, 
           into = c("gender", "arm"), 
           sep = "_")













#Seperating the baseline_condition 
myData<- myData %>% 
  separate(col = "baseline_condition", 
           into = c("baseline_condition", NA), 
           sep = "_")
view(myData)

#Seperating the baseline_temp_cat
myData<- myData %>% 
  separate(col = "baseline_temp_cat", 
           into = c("baseline_temp_cat", NA), 
           sep = "_")
view(myData)

#Seperating the 6m_radiologic 
myData<- myData %>% 
  separate(col = "6m_radiologic", 
           into = c("6m_radiologic", NA, NA),
           sep = "_")
view(myData)

#Seperating strep_resistance 
myData<- myData %>% 
  separate(col = "strep_resistance", 
           into = c("strep_resistance", NA,NA),
           sep = "_")
view(myData)

#Changing baseline_cavitation to yes=1, no=0



#Changining improved to TRUE=1, NO=0 



#Changing gender to M=0, F=1 



#renaming 6m_radiologic 
myData%>%
  rename(myData, "radiologic" = "column 12")
view(myData)


