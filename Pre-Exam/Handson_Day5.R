install.packages("tidyverse")
library(tidyverse)
install.packages("here")
library(here)
#Reading_the_data
read_csv(here("DATA","Konsultasjoner.csv"))
myData<-read_csv(here("Data", "Konsultasjoner.csv"))
myData<-read.csv2(here("DATA","Konsultasjoner.csv"))
myData
#Viewing_headandtail
head(myData,7)
tail(myData,15)

#Viewing
view(myData)
summary(myData)
glimpse(myData)
install.packages("skimr")
library(skimr)
skimr::skim(myData)
install.packages("naniar")
library(naniar)

#missing
naniar::gg_miss_var(myData)
naniar::gg_miss_case(myData)#Shows missing in each row

#$ ACESSES THE ELEMENT IN THE SET
myData$alder

#tidyverse_code 
#Start by writing what you want, then pipe the commands 
#afterwards if you have many steps afterwards
myData$alder %<% 
  head()

#make it longer not wider 
myData<-
  myData %>% 
    pivot_longer(
    names_sep = " ", #names seperated
    names_to = c(NA,"year"),
    values_to = "nConsultations",
    cols = starts_with("Konsultasjoner") #columns start with
  )

#Pivot_wider to make it wider 
myData<-
  myData%>%
  rename(age=alder,
         gender=kjoenn,
         diagnosis=diagnose)
myData

#distinct 
#Removes duplicated rows 

#count()
#investigates categorical variables 
myData%>% 
  count(age)
#never use it on your original dataset bec it might be lost 

myData%>%
  count(ID, sort=T)

#savetidydata
fileName<- paste0("tidy_consultation_", Sys.Date(), ".txt")
write_delim (myData, 
            file=here("Data, fileName"), delim="\t")
fileName

