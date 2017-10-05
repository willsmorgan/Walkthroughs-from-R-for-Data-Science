#R for Data Science by Hadley Wickham
#Script author: William Morgan

##### Chapter 12: Tidy Data #####
# Objectives - Learn the basics of tidy data
  # spreading and gathering (basically moving between wide and long formats) 
  # separating and uniting (splitting and unsplitting numeric columns)

# Notes - sections excluded from this script should still be read, I just didn't feel it needed to be in here

library('tidyverse')

### Section 12.3: Spreading and Gathering ###
# Tidy up tables 4a and 4b into long form
table4a #notice the format - which columns do we want to 'gather' and what do we call them?
table4a <- table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases") 

table4b <- table4b %>%
  gater(`1999`, `2000`, key = "year", value = "population")

left_join(table4a, table4b)

# Use spread() to change table2 to a wide format
table2
table2 <- table2 %>%
  spread(key = 'type', value = 'count')

### Section 12.4: Separating and Uniting ### 
# separate the 'rate' column of table3 using separate()
table3 %>%
  separate(rate, into = c("cases", "population"))

# the separator can be specified with the sep = "" argument, and the default separator is non-alphanumeric characters
# the convert = TRUE argument will also convert the split character vectors back into numerics

# unite() works pretty much the same way and isn't all that useful, so it is not included here



