# RMED901_Group4_Exam 
Created on: 12.09.2023 
Group members: Mariam Reda, Isil Kucuka, Bente Sved Skottvoll, Mari Eskild Rasmussen 
Task #1 Create an RStudio project (done on 11.09.2023)
Task #2 Read and tidy the dataset 
We agreed to work first individually (on different branches), then compare our scripts and merge them into one. 
Checklist: 
-Are there unique obs in the dataset? (Duplications?) 
Ans: Gender is repeated in the gender column, and also in gender_arm variable
Duplications: 
-In month variable, there are some repeated values
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
6) 
