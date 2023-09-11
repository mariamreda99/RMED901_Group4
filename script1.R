library(tidyverse)
library(modeldata)

data(ames)

ames %>%
  group_by(Garage_Type) %>%
  count(Paved_Drive)

detchd <- ames %>%
	select(Longitude, Latitude, Sale_Price, Garage_Type, Paved_Drive) %>%
	filter(Garage_Type == "Detchd")

my_fun <- function(a, b){
	a_price <- detchd %>%
		filter(Paved_Drive == a) %>%
		pull(Sale_Price)
	
	b_price <- detchd %>%
		filter(Paved_Drive == b) %>%
		pull(Sale_Price)
	
	return(
		t.test(a_price, b_price)
	)
}

my_fun("Dirt_Gravel", "Paved")

jjjjøpkøk

bjnkkn

ggygihy
mariamhelloworld 
#himariam

# addition sentence by Isil, vers2

# Bente wrote:
paste("Hello world")
#"changes made"
64+24

Hello_myname_is_MariamReda
MariamReda_Hello_Universe 

making_change_to_branch_Mariam 