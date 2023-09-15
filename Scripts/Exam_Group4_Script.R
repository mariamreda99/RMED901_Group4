# INFO ####

#
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
examdata_tidy %>%
  count(patient_id, sort = TRUE)
?unique
unique(examdata_tidy, incomparables = FALSE)
duplicated(examdata_tidy, incomparables = FALSE, fromLast = FALSE)

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

# Task line  46: Removing the unnecessary columns (year, month, baseline_esr_cat) ####
df <- df %>%
  select(-year, -month, -base_esr_cat)


# Task line  48: #### 
# Make necessary changes in variable types
# Use glimpse to see variable types
glimpse(df)
# Do not find variable types that need to be changed

# Make code to change the categorical variables stored as data type character into numeric
df <- df %>% 
  mutate(base_condition_cat = as.numeric(base_condition_cat),
         base_temp_cat = as.numeric(base_temp_cat),
         base_cavitation = as.numeric(base_cavitation),
         base_temp_cat = as.numeric(base_temp_cat),
         strep_resistance_cat = as.numeric(strep_resistance_cat),
         radiologic_6mon_cat = as.numeric(radiologic_6mon_cat))
 
## Task line  49: Create a set of new columns: #####

### Task line  50 ####
#Changing gender to M=0, F=1 
df <- df %>% 
  mutate(Gender_Numeric = if_else(df$gender == "F", 1, 0))

#Changing F to C 
### Task line  51 ####
#Changing F to C 
#install.packages("weathermetrics")
library (weathermetrics)
df <- df %>% 
  mutate(baseline_temp_C = fahrenheit.to.celsius(df$baseline_temp, round = 2))

### Task line  52 ####
# a column cutting "baseline_esr" score into quartiles (4 equal parts); HINT: cut() function
?cut()
df <- df %>%
  mutate(base_esr_quartiles = cut(baseline_esr, 4))

df %>%
  count(base_esr_quartiles) # I used count to see that 4 groups are created

### Task line  53: Strep resistance ####
# Make a column checking whether there was a streptomycin resistance after being given highest dose of streptomycin
# rename column containing space 
df <- df %>% 
  rename(dose_strep_g = `dose_strep [g]`)

df %>% 
  summarize(max(dose_strep_g))
  
df %>% 
  count(dose_strep_g)

df <- df %>% 
  mutate(strep_res_developed = case_when(
                                dose_strep_g == 2 & strep_resistance_cat == 3 ~ "yes",
                                TRUE ~ "no")) 
# Check if correct output to new variable strep_res_developed 
df %>% 
  count(strep_res_developed, strep_resistance_cat)

## Task line  54 ####
#Set the order of the columns 
df %>% 
  select(patient_id, gender, arm, everything())
## Task line  55 ####
#Arranging patient id in an ascending order
df <- df %>% 
  arrange(patient_id)

## Missing : Task line  56 ####
# Connect above steps with a pipe (copy-paste)

# Task line  57: Exploring data ####

## Summary ####
summary(df)
skimr::skim(df)

#gender
df %>%
  count(gender)

#arm
df %>%
  count(arm)

#dose_strep
df %>%
  count(dose_strep_g)

#base_condition_cat
df %>%
  count(base_condition_cat)

#baseline_temp
df %>%
  count(baseline_temp)

#base_temp_cat
df %>%
  count(base_temp_cat)

#base_temp_txt
df %>%
  count(base_temp_txt)

#baseline_esr
df %>%
  count(baseline_esr)

#continuing line 57, explore data
df %>%
  count(gender, arm, dose_strep_g, base_condition_cat, base_temp_txt, baseline_esr) %>%
  view()
df %>%
  select(gender, arm, dose_strep_g, strep_resistance_txt, base_cavitation_txt,
         radiologic_6mon_txt, strep_res_developed)%>%
  view()
summary(df)
names(df)
tail(df$baseline_esr)
head(df$base_cavitation_txt)

## Task line  58: Explore and comment missing values ####
df %>% naniar::gg_miss_var()

## Task line 59: Stratify your data by a categorical column and report min, max, mean and sd of a numeric column. ####

df %>%
  group_by(gender) %>%
  summarise(min(baseline_esr, na.rm = T), max(baseline_esr, na.rm =T), mean(baseline_esr, na.rm = T), sd(baseline_esr, na.rm = T))
### I chose gender as the categorical value and baseline_esr as the numeric


## Task line 60: Stratify your data by a categorical column and report min, max, mean and sd of a numeric column for a defined set of observations - use pipe! ####



### Task line 61: Only for persons with baseline condition 'Fair' ####
df %>%
  group_by(gender) %>%
  filter(base_condition_cat == 2) %>%
  summarise(min(baseline_esr, na.rm = T),
            max(baseline_esr, na.rm =T), 
            mean(baseline_esr, na.rm = T), 
            sd(baseline_esr, na.rm = T))
#### baseline condition fair = 2


### Task line 62: Only for females####
df %>%
  group_by(improved) %>%
  filter(gender == "F") %>%
  summarise(min(baseline_esr, na.rm = T), 
            max(baseline_esr, na.rm = T), 
            mean(baseline_esr, na.rm = T), 
            sd(baseline_esr, na.rm = T))


### Task line 63: Only for persons with baseline temperature 100-100.9F ####
df %>%
  group_by(gender) %>%
  filter(base_temp_txt == "100-100.9F") %>%
  summarise(min(baseline_esr, na.rm = T), 
            max(baseline_esr, na.rm = T), 
            mean(baseline_esr, na.rm = T), 
            sd(baseline_esr, na.rm = T))


### Task line 64: Only for persons that developed resistance to streptomycin####
df %>%
  group_by(gender) %>%
  filter(strep_res_developed == "yes") %>%
  summarise(min(baseline_esr, na.rm = T), 
            max(baseline_esr, na.rm = T), 
            mean(baseline_esr, na.rm = T), 
            sd(baseline_esr, na.rm = T))

## Task line 65: Use two categorical columns in your dataset to create a table (hint: ?count)####
df %>%
  count(strep_resistance_cat, radiologic_6mon_cat)%>%
  view()

df %>%
  count(base_condition_cat, base_temp_cat)%>%
  view()
# Day 7: Create plots that would help answer these questions: ####

library("ggplot2")
library("patchwork")
## Task line 70: Are there any correlated measurements? ####
# Variables of interest: patient_id 	arm 	dose_strep [g] 	base_condition_cat	baseline_esr_cat 	base_cavitation_txt	strep_resistance_cat	radiologic_6mon_cat	Gender_numeric	baseline_temp_C	strep_res_developed

# Baseline esr and temp
# Not correlated
ggplot(df) +
  aes(x = baseline_esr, y = baseline_temp_C) +
         geom_point(aes(color = as.factor(Gender_Numeric)))

# Baseline esr and base_condition_cat
# Correlated
ggplot(df) +
  aes(x = baseline_esr, y = baseline_temp_C) +
  geom_point(aes(color = as.factor(Gender_Numeric))) +
  facet_grid(cols = vars(base_condition_cat), rows = vars(Gender_Numeric)) + 
  theme_minimal()

ggplot(df) +
  aes(x = baseline_esr, y = baseline_temp_C) +
  geom_col(aes(fill = as.factor(Gender_Numeric))) +
  facet_grid(cols = vars(base_condition_cat), rows = vars(Gender_Numeric)) +
  theme_minimal()

ggplot(df) +
  aes(x = baseline_esr, y = baseline_temp_C) +
  geom_col(aes(fill = as.factor(Gender_Numeric))) +
  facet_grid(cols = vars(base_condition_cat), rows = vars(base_cavitation_txt)) +
  theme_minimal()
  

glimpse(df)
## Task line 71: Does the erythrocyte sedimentation rate in mm per hour at baseline distribution depend on `gender`? ####
plot71 <- ggplot(data = df) +
  aes( x = gender,
       y= baseline_esr) +
  geom_boxplot()
plot71

# Answer= no, it does not depend on gender.

## Task line 72: Does the erythrocyte sedimentation rate in mm per hour at baseline distribution depend on `baseline_temp`? ####
plot72 <- ggplot(data = df) +
  aes( x= baseline_temp,
       y = baseline_esr) +
  geom_point(
             size=2) +
  geom_smooth(
    method = "lm")
plot72
#yes, it depends on baseline_temp. There is a positive correlation.

## Task line 73: Do erythrocyte sedimentation rate in mm per hour at baseline and baseline temperature have a linear relationship? ####
ggplot(df) +
  aes( x = log(baseline_esr), 
       y = baseline_temp_C
       ) +
  geom_point() +
  geom_smooth()

ggplot(df) +
  aes( x = baseline_esr, 
       y = baseline_temp_C
  ) +
  geom_point(aes(color = improved, shape = arm)) + 
  geom_smooth(method = "lm",
              se = FALSE,
              aes(color = improved))

ggplot(df) +
  aes(  x = baseline_esr, 
        y = baseline_temp_C,
       ) +
  geom_point(aes(color = arm)) +
  geom_smooth() +
  facet_grid(rows = vars(improved))
  


## Task line 74: Does Likert score rating of radiologic response on chest x-ray at 6 months change with erythrocyte sedimentation rate in mm per hour at baseline? ####
ggplot(df) +
  aes(x = radiologic_6mon_cat, y = baseline_esr) +
  geom_point(aes(colour = as.factor(Gender_Numeric))) +
  geom_smooth(method = "lm") +
  facet_wrap(facets = vars(Gender_Numeric)) +
  labs(fill = "Gender") +
  theme_classic()

ggplot(df) +
  aes(x = radiologic_6mon_cat, y = baseline_esr) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_classic() +
  labs(title = "Low ESR at baseline implicates better Likert radiologic score at 6 months",
       caption = "ESR = erythrocyte sedimentation rate, in mm per hour at baseline") +
       ylab("ESR in mm / hour") +
       xlab("Likert radiologic score at 6 months") +
  scale_x_continuous(breaks = c(1,2,3,4,5,6))
