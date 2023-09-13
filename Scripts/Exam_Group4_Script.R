# INFO ####

# Install packages and load the listed libraries ####
invisible(install.packages(pacman))

pacman::p_load(ggplot2, tidyverse, here)

# View your Rproject home directory path ####
here()

# Read data ####
df_main <- read_delim(here("data", "exam_data.txt"), delim = "\t")
df_add <- read_delim(here("data", "exam_data_join.txt"))

# Tidying #### 
head(df_main)
tail(df_main)
## Separate columns####
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
  separate(col = '6m_radiologic', 
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
df <- df %>%
  select(-year, -month, -base_esr_cat)

View(df)

#Create a set of new columns: #####


#Changing gender to M=0, F=1 
df <- df %>% 
  mutate(Gender_Numeric = if_else(df$gender == "F", 1, 0))

#Changing F to C 
install.packages("weathermetrics")
library (weathermetrics)
df <- df %>% 
  mutate(baseline_temp_C = fahrenheit.to.celsius(df$baseline_temp, round = 2))


# a column cutting "baseline_esr" score into quartiles (4 equal parts); HINT: cut() function
?cut()
df <- df %>%
  mutate(base_esr_quartiles = cut(baseline_esr, 4))

df %>%
  count(base_esr_quartiles) # I used count to see that 4 groups are created


# - a column checking whether there was a streptomycin resistance after being given highest dose of



#Set the order of the columns 
df %>% 
  select(patient_id, gender, arm, everything())
view(df)

#Arranging patient id in an ascending order
df <- df %>% 
  arrange(patient_id)
view(df)


# Explore Data

## Summary
summary(df)
skimr::skim(df)

## Explore missing values



# count()
# df_main %>% naniar::gg_miss_var()