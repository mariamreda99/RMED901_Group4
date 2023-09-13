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
