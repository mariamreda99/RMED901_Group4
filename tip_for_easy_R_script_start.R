# INFO
# Purpose: A simple template script to install and load packages with the least code possible 
# Created: 11.09.2023

# Install package packman for easily and simple code to install and load libraries
# Invisible inhibits R to write output on console, purpose is to minimize clutter in console
invisible(install.packages(pacman))

# Run pacman to install and load the listed libraries
pacman::p_load(ggplot2, tidyverse, here)

# View your Rproject home directory
here()