# R for Data Science by Hadley Wickham
# Script author: William Morgan

##### Chapter 11: Data Import #####
#Objectives - 
  # Learn how to load different types of data in R

library('tidyverse')

### Section 11.2: Getting Started ###
# List of common functions to import data
  # readcsv() - reads comma delimited files
  # readcsv2() - read semicolon delimited files (common in countries that use comma as decimal place)
  # read_tsv() - tab delimited files
  # read_delim() - reads files with any delimiter
  # read_fwf() - fixed witdh files (?)
  # read_table() - read common variation of fixed width files where columns are separated by white space
  # read_log() - reads Apache style log files (? - check out webreadr)

# Let's practice:
heights <- read.csv("data/heights.csv") #not a real file, just practice for syntax

# csvs can be 'read' in by actually specifying the data
read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

# You can skip lines the "skip" argument, or ignore comments with the "comment" argument
read_csv(
  "I want to skip this line
  x,y,z
  1,2,3",
  skip = 1
)

read_csv(
  "# This is a commentd line
  x,y,z
  1,2,3",
  comment = '#'
)

# If you know your data does not have column names, set this argument: col_names = F
read_csv("1,2,3 \n4, 5, 6", col_names = F) # \n is an escape character to add a new line - it will be covered later when we review strings

# Column names can also be specified manually with the same argument
read_csv("1, 1, 1, \n1, 1, 1", col_names = c("col1", "col2", "col3"))

# Missing values can also be identified with a specific value
read_csv("1, 1, 1, \n1, ., .", na = "." , col_names = F)

## Technical note - 
  # read.csv is the base R function for importing csvs, but the tidyr function can perform much better
  # read_csv will also create tibbles instead of data frames

## Skipping Section 11.4: Parsing ##

### Section 11.5: Writing to a file ###
# write_csv () and write_tsv() are two common functions you'll use
  # they both automatically encode in UTF-8
  # dates and date-times are in ISO8601 format for easy parsing elsewhere

# the feather package implements a fast binary file format that can be shared across programming languages
library('feather')
write_feather(mlem, 'mlem.feather')
read_feather('mlem')


### Section 11.6: Other types of data ###
# the haven package reads SPSS, Stata, and SAS files
# readxl for .xls and .xlsx 
# DBI along with a database specific package (RMySQL, RSQLite, etc.) allows you to run SQL queries against a database and return a data frame
# jsonlite for hierarchical .json data
# xml2 for .xml