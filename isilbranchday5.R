exam_data <- read.delim("~/PhD isil/RMED901/RMED901_Group4/DATA/exam_data.txt")
View(exam_data)
here()
library(tidyr)
View(exam_data)
summarise(exam_data)
glimpse(exam_data)
here()

exam_data
skimr::skim(exam_data)

#tidying: removing gender initial from arm column
examdata_tidy <-
  exam_data %>%
  separate(col = "gender_arm",
           into= c(NA, "arm"),
           sep = "_" )

View(examdata_tidy)

examdata_tidy %>%
  count(patient_id)

#checking if there are duplications
examdata_tidy %>%
  count(patient_id, sort = TRUE)
?unique
unique(examdata_tidy, incomparables = FALSE)
duplicated(examdata_tidy, incomparables = FALSE, fromLast = FALSE)
#none of them are duplicated

# changing name of baseline condition
examdata_titlenames_tidy <-
  examdata_tidy %>%
  separate(col = "baseline_condition",
           into= c("baseline_condition", NA),
           sep = "_" )
# changing name of baseline temp cat (removing text, leaving number)
examdata_titlenames_tidy <-
  examdata_titlenames_tidy %>%
  separate(col = "baseline_temp_cat",
           into= c("baseline_temp_cat", NA),
           sep = "_" )
# changing name of baseline esr cat (removing text, leaving number)
examdata_titlenames_tidy <-
  examdata_titlenames_tidy %>%
  separate(col = "baseline_esr_cat",
           into= c("baseline_esr_cat", NA),
           sep = "_" )
# changing name of strep_resistance (removing text, leaving category number)
examdata_titlenames_tidy <-
  examdata_titlenames_tidy %>%
  separate(col = "strep_resistance",
           into= c("strep_resistance", NA, NA),
           sep = "_" )

## changing name of X6m_radiologic (removing text, leaving category number)
examdata_titlenames_tidy <-
  examdata_titlenames_tidy %>%
  separate(col = "X6m_radiologic",
           into= c("X6m_radiologic", NA, NA),
           sep = "_" )

#changing a column name
colnames(examdata_titlenames_tidy)[12] = "X6m_radiologic"
