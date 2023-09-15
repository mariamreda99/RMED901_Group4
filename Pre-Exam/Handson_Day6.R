myData <-read_delim(here("Data","tidy_consultation_2023-09-11.txt"), delim="\t")
view(myData)
myData %>% 
  select(age, gender)

#to refer to column with number use ''

select (-age) #To remove age column 

#changing order of columns 
#select(write the order you want)

#to specify what to start with 
select (year, everything())


#select (starts_with ("D12")), ends_with(), contains(), matches()
#mutate()
#(assigning bec im changing dataset)

#To change character variables to numeric ones 
myData<- 
  myData %>% 
  mutate(year= as.numeric(year),
         nConsultations= as.numeric(nConsultations))

#creating an ID column
mutate(ID = 1:n())

#convert F and M for genders 
mydata<-
  myData %>% 
  mutate(gender = if_else(gender == "Kvinner", "F", "M"))

#counting the stuff in the column 
count(gender)

#creating column for consultations before and after 2015 
myData<-
  myData %>% 
mutate(consBefore2015 = if_else(year >= 2015, "No", "Yes"))
view(myData)


mutate(gender = if_else(gender == "Kvinner", "F", "M"))

myData %>% 
mutate(gender = case_when(gender == "Kvinner" ~ "F",
                 gender == "Menn" ~ "M", 
                 gender == "Ikke spesifisert" ~ "Not specified",
                 TRUE ~ "Other"))
view(myData)

#== in a condition, but only = if we are changing or assigning 

#can use 0 and 1 without strings instead of yes and no 

#arrange()

#if you want to see the highest values on top

#arrange desc(column you want )

summary(myData)

library(skimr)
#skimr::skim(myData)
fix_windows_histograms()
skim(myData)

#grouping my data by gender 
#for example for men and women 
group by(gender) %>% 
  summarise (max(Consultations, na.rm = T), min(nConsultations, na.rm = T))


#merging_datasets
myData22<-read_delim(here("data", "exam_data_join.txt"))
myData<-myData
myData<- merge(myData,myData22,by="patient_id")
view(myData)


