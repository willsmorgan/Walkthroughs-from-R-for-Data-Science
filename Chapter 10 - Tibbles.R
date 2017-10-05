#R for Data Science by Hadley Wickham
#Script author: William Morgan

##### Chapter 10: Tibbles #####
# Objectives - 
  # Learn how to create Tibbles and understand how they differ from traditional data.frames

# Extra - 
  # refer to vignette('tibbles') for more information

library('tidyverse')

### Section 10.2 Introduction ###
# You can force existing data frames to tibbles using as_tibble(); we'll start with the data set 'iris'
as_tibble('iris')

# Tibbles can also be assembled from vectors with tibble()
tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y,
)

# Small technical note - 
  # tibbles do not change the types of inputs (strings to factors)
  # doesn't change the names of variables or create rownames
  # tibbles can have variable names that are not valid R names (non-syntactic)
    # when you create a variable with a non-syntactic name, you refer to it with the backtick " ` "
my_tib <- tibble(
  `:P` = 'face',
  `  ` = 'spaces',
  `2000` = 'numbers'
)

# You can also create tibbles using tribble(), which is short for transposed tibble
  # It's required for you to specify column headings in a formula format (starting with ~)
tribble(
  ~x, ~y, ~z,
  
  'a', 2, 3.6,
  'b', 1, 8.5
)


### Section 10.3: Tibbles and Data Frames ###
# You should've noticed already, but tibbles print more information than data frames (including type)
tibble(
  a = runif(1000),
  b = 1:1e3,
  e = sample(letters, 1e3, replace = T)
)

# You can explicitly print data frames with print(), setting additional arguments like n = . (set number of rows to display) or width = . (how many columns to display)
nycflights13::flights %>%
  print(n = 10, width = Inf)

# Tibbles can be subsetted with $ and [['col_name']]
df <- tibble(
  x = 1:5,
  y = runif(5),
)

df$x
df[['x']]
df[[1]]

df %>% .$x     #use .$colname in a pipeline
