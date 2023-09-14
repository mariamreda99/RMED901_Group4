# RMED901 Data science with R for medical researchers 
# Created on: 12.09.2023
# Written by: Group 4
# Group members: Mariam Reda, Isil Kucuka, Bente Sved Skottvoll, Mari Eskild Rasmussen
# Purpose: Group project for evaluating progress of learning output using R, package tidyverse and coworking by shared GitHub repository
=======

#Task #1 
Create an RStudio project (done on 11.09.2023) 
 
#Task #2 Read and tidy the dataset 
 
We agreed to work first individually (on different branches), then compare our scripts and merge them into one. 

Checklist: 
-Are there unique obs in the dataset? (Duplications?) 
Ans: Gender is repeated in the gender column, and also in gender_arm variable Duplications: 


-Are there any columns starting in a number, containing space? 
Ans: no 
-Are all variables as columns? 
Ans: Yes 
-Are there any columns containing combined variables? 
Ans: Yes, gender_arm variable and baseline_condition, baseline_temp_cat, baseline_esr_cat, strep_resistance, X6m_radiologic.

-Recommended changes

1) Removing the gender from the arm variable
2) Sort the years and patient ids
3) Improved variable can be changed to TRUE=1, False=0
4) baseline cavitation can be changed to Yes=1, no=0
5) Keeping the numbers (values rating the answers) in the condition variables instead of the text
6) Removing the number from the variable 6m_radiologic at the beginning
7) changing gender to 0,1 
8) changing control and intervention to 0,1 

#Day 2
#Making Changes to the dataset 

____ISIL____
tidied the data
checked for duplicates
changed the columns that include both the category number and the explanation of the category, further info:

CATEGORIES:
baseline condition:
1= Good
2= Fair
3= Poor

baseline_temp_cat:
1= 98-98.9F
2= 99-99.9F
3= 100-100.9F
4= 101F+

baseline_esr_cat:
2= 11-20
3= 21-50
4= 51+

strep_resistance:
1= sens 0-8
2= mod 8-99
3= resist 100+

X6m_radiologic:
1= Death
2= Considerable deterioration
3= Moderate deterioration
4= No change
5= Moderate improvement
6= Considerable improvement


# Maris log

#start
Exam work started on day 4 of the course (monday 11.09.23). We created the github group-project.

Day 5
Tidying the data. Used the separate function to divide the columns that contained different data types. Renamed columns. Explored the data. 

Day 6
Exploring the data. We used some time colaborating when merging the files from day 5, resolving conflicts. 

Day 7
Task line 60-64:
"Stratify your data by a categorical column and report min, max, mean and sd of a numeric column for a defined set of observations" - I used the group by, filter and summarise function.

Task line 73: "Do erythrocyte sedimentation rate in mm per hour at baseline and baseline temperature have a linear relationship?""
Visualizing the data using ggplot. I tested different versions of dot plots and stratefied for different variables. .

