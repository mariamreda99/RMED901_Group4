# INFO ####

#
library(tidyverse)
library(here)

# View your Rproject home directory path ####
here()

# Read data ####

df_main <- read_delim(here("data", "exam_data.txt"))
df_add <- read_delim(here("data", "exam_data_join.txt"))

# Explore data ####

head(df_main)
summary(df_main)
glimpse(df_main)
head(df_add)
skimr::skim(df_main)
tail(df_main)

# Tidy the data ####

# Separate columns that contain different data types ####

df_main <- df_main %>%
  separate(col = gender_arm, 
           into = c(NA, "arm"), 
           sep = "_")
## change the column gender_arm to contain only arm 


df_main <- df_main %>%
  separate(col = baseline_condition, 
           into = c("basline_condition_score", "baseline_condition_txt"), 
           sep = "_")
# Divided the column baseline condition into one for the text and one for the score

df_main <- df_main %>%
  separate(col = baseline_temp_cat, 
           into = c("baseline_temp_cat", "baseline_temp"), 
           sep = "_")
# did the same for baseline temp 

df_main <- df_main %>%
  separate(col = baseline_esr_cat, 
           into = c("baseline_esr_cat", "baseline_esr"), 
           sep = "_")
# and for esr

df_main <- df_main %>%
  separate(col = strep_resistance, 
           into = c("strep_resistance_cat", "strep_resistance", "strep_resistance_nr" ), 
           sep = "_")
# changed the strep_resistance into 3 columns 

df_main %>%
  count(df_main$strep_resistance)
# check if it looks right
 
df_main <- df_main %>%
  separate(col = '6m_radiologic',
           into = c(NA, "radiologic_6m_responce"), 
           sep = 2) 
# removed number in front of radiological responce and changed name of column to avoid number as name. The radiological responce numeric score already exist

## Check for duplications ####
df_main %>%
  unique()
# this does not show any duplicates, but several patients are registered twice (at different times)