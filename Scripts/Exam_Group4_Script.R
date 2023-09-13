# EXAM Group 4 ####

# Load packages ####
library(tidyverse)
library(here)

# View your Rproject home directory path ####
here()

# Read data ####
df_main <- read_delim(here("data", "exam_data.txt"), delim = "\t")
df_add <- read_delim(here("data", "exam_data_join.txt"))

# Explore data ####

head(df_main)
summary(df_main)
glimpse(df_main)
head(df_add)
skimr::skim(df_main)
tail(df_main)

## Check for duplications ####
df_main %>%
  unique()
# this does not show any duplicates, but several patients are registered twice (at different times)

#checking if there are duplications
df_main %>%
  count(patient_id, sort = TRUE)
?unique
unique(df_main, incomparables = FALSE)
duplicated(df_main, incomparables = FALSE, fromLast = FALSE)

# Tidy the data ####
#changing a column name of column starting with a number, which R does not like
colnames(df_main)[12] = "X6m_radiologic"

# Separate columns that contain different data types ####

# gender_arm: first part contains gender, this is double information and is deleted. Second part stored as variable arm

df_main <- df_main %>%
  separate(col = gender_arm, 
           into = c(NA, "arm"), 
           sep = "_")


# baseline_condition: keep the first part, as it is the numeric categorical and is listed in codebook. Shorten variable name baseline to "base", otherwise it will be very long
df_main <- df_main %>%
  separate(col = baseline_condition, 
           into = c("base_condition_cat", NA), 
           sep = "_")

# baseline_temp_cat: levels are not explicitly listed in codebook, keep both parts of variable after splitting into category level and text description.
df_main <- df_main %>%
  separate(col = baseline_temp_cat, 
           into = c("base_temp_cat", "base_temp_txt"), 
           sep = "_") %>% glimpse()

# baseline_esr_cat: levels are not explicitly listed in codebook, keep both parts of variable after splitting into category level and text description.
df_main <- df_main %>%
  separate(col = baseline_esr_cat, 
           into = c("base_esr_cat", "base_esr_txt"), 
           sep = "_") %>% glimpse()

# strep_resistance: levels are not explicitly listed in codebook, keep both parts of variable after splitting into category level and text description.
df_main <- df_main %>%
  separate(col = strep_resistance, 
           into = c("strep_resistance_cat", "strep_resistance_txt", "strep_resistance_range"), 
           sep = "_") %>% 
  glimpse()


# 6m_radiologic: split at postition 2 since the description text contains underscores, and change variable names to start with a character 
df_main <- df_main %>%
  separate(col = X6m_radiologic, 
           into = c("radiologic_6mon_cat", NA, "radiologic_6mon_txt"), 
           sep = c(1,2))
  
# Do something with baseline_cavitation?
# baseline_cavitation: make new variable base_cavitation that reflects the codebook
df_main <- df_main %>% 
  mutate(base_cavitation = case_when(
              baseline_cavitation == "yes" ~ 1,
              baseline_cavitation == "no" ~ 2))
glimpse(df_main)

# Relocate base_cavitation to before baseline_cavitation to conserve the system
df_main <- df_main %>% relocate(base_cavitation, .before = baseline_cavitation)

# Rename baseline_cavitation
df_main <- df_main %>% rename(base_cavitation_txt = baseline_cavitation )

## Unique ####
# Dataset df_main is unique
df_main %>% unique()

# But some patients have several treatments
# N patient id = 107 
# N observations = 141
df_main %>% summarise(max(patient_id))
df_main <- df_main %>% arrange(-desc(patient_id))

## Join datasets ####
df <- full_join(df_main, df_add, by = "patient_id")

# Reorder added variables to be grouped with the categorical data
df <- df %>% relocate(baseline_temp, .before = base_temp_cat)
df <- df %>% relocate(baseline_esr, .before = base_esr_cat)

# Order dataset observations by patient_id
df <- df %>% arrange(-desc(patient_id))

#Removing the unnecessary columns (year, month, baseline_esr_cat) ####
#Removing month
df <- df %>%
  df <- subset(df, select = -c(month))
view(df)

#Removing year
df <- df
df <- subset(df, select = -c(year))
view(df)

#Removing baseline_esr_cat 
df <- df
df <- subset(df, select = -c(base_esr_cat))
view(df)

#Changing baseline_cavitation to yes=1, no=0



#Changining improved to TRUE=1, NO=0 



#Changing gender to M=0, F=1 

