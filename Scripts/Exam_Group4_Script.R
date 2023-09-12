# INFO ####

# Install packages and load the listed libraries ####
invisible(install.packages(pacman))

pacman::p_load(ggplot2, tidyverse, here)

# View your Rproject home directory path ####
here()

# Read data ####
df <- 