#R for Data Science by Hadley Wickham
#Script author: William Morgan

##### Chapter 5: Data Transformation #####
#Objectives - 
  #get comfortable with the tidyverse library for cleaning data
  #specifically, use filter(), arrange(), select(), mutate(), and summarise()

### Section 5.1: Introduction ###
#We're going to be using data on flights departing NYC in 2013, so load it up
library('tidyverse') #take a note on how dplyr, stats interfere with each other; use base::filter() to access the base R filter() 
library('nycflights13')
library('Lahman')

#get a brief preview of the data we're working with and store it for later use
nycflights13::flights
flights <- nycflights13::flights

## dplyr basics ##
#filter() - pick observations by their values (subsetting)
#arrange() - order the rows 
#select() - pick variables by their names
#mutate() - create new variables from functions of existing variables
#summarise() - collapse many values down to a single summary
#group_by() - apply any of the above functions by groups

#all of these functions have the same general syntax - function(data_frame, how_to_modify_df)
  #they all output a new dataframe
##################

### Section 5.2: Filter rows with filter() ###
#filter() allows us to subset observations based on their values
jan1 <- filter(flights, month == 1, day == 1) #choose the df to modify, state the conditions you want to meet

#be careful with comparisons with floats - why are both of these false?
sqrt(2)^2 == 2
1/49 * 49 == 1 

#to get around this, you can use near(a,b) to make these comparisons
near(sqrt(2)^2, 2)
near(1/49*49, 1)

#another useful operation is %in%, which checks if an object is an element of something else
nov_dec <- filter(flights, month %in% c(11,12)) #condition to evaluate is month == 11 | month == 12

#remember Demorgan's laws?
  # !(x & y) == !x | !y
  # !(x | y) == !x & !y
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

#is.na() can also be used within filter() to help clean up missing data quickly
filter(flights, !is.na(year)) #drop flights missing the year

#filter() by default will only select observations that evaluate to True, excluding False and NA values
  #to grab those NA values, you have to ask for them explicitly
filter(flights, is.na(month) | month == 12)

#between(<variable> , <lower_bound> , <upper_bound>) is another commonly used filtering technique
filter(flights, between(month, 1,3)) #grab all flights from January to March


### Section 5.3: Arrange rows with arrange() ###
#arrange() is basically just a sorting command
arrange(flights, year, month, day)

#use desc(<variable>) to sort in descending order
arrange(flights, desc(year), month, day)

#NOTE: missing values are always sorted at the end
df <- tibble(x = c(5, 2, NA)) #practice tibble to highlight NA sorting values
arrange(df, x)
arrange(df, desc(x))

## Practice question ##
# how could you use arrange() to sort all missing values to the top? (hint - use is.na())
#   arrange(df, desc(is.na(x))) #missing values evaluate to True (1) and then get brought to the top when sort in descending order
#######################


### Section 5.4: Select columns with select() ###
#select() is a simple way to cut down data sets with tons of unnecessary variables 
select(flights, year, month, day) #select columns by name
select(flights, year:day) #select all columns b/w year and day (inclusive)
select(flights, -(year:day)) #select all columns outside of year and day (also inclusive)

## functions that will help you with select() ##
# starts_with(<"string">) - matches names that begin with "string"
# ends_with(<"string">) - matches names that end with "string"
# contains(<"string">) - matches names that contain "string"
# matches(<regexp>) - matches strings according to the regular expression
# num_range(<"varname">, i:j) - grabs variables with varnamesi, varnamesi+1, ..., varnamesj
################################################

#select() can be used to rename variables, but it will only keep variables that are explicitly mentioned
  #instead, use rename(<df>, new_name = oldname)
rename(flights, tail_num = tailnum)

#another option is to use select() with the everything() helper
  #really good for bringing specific variables to the front of the df
select(flights, time_hour, air_time, everything())

## Practice Questions ##
# What happens if you include the name of a variable multiple times in a select() call?
#   R will only acknowledge the first mention of the variable
# 
# What does the one_of() function do? 
#   pulls variables matching elements of a character vector
# 
# How do the select helpers handle case by default? How can you change the default?
#   select helpers ignore the case by default
#   if you wish to change this default, set ignore.case = FALSE
#########################


### Section 5.5: Add new variables with mutate() ###
#variables created from mutate() are stored at the end of the df, so let's create a smaller version of flights to work with
flights_sml <- select(flights,
                      year:day,
                      ends_with('delay'),
                      distance,
                      air_time
)

#practice using mutate to generate three new variables: gain, speed, and gain_per_hour
mutate(flights_sml,
       gain = arr_delay - dep_delay, # <new_varname> = bla bla bla
       speed = distance / air_time * 60,
       gain_per_hour = gain / hours  #note how you can refer to columns you've just created
)

#if you only want to keep the new variables, use transmute()
transmute(flights_sml,
       gain = arr_delay - dep_delay, # <new_varname> = bla bla bla
       speed = distance / air_time * 60,
       gain_per_hour = gain / hours  #note how you can refer to columns you've just created
)

# NOTE: it is important the function you use in mutate() is vectorised
#   that is, it takes a vector of values as an input and returns a vector of the same length

## List of vectorised functions ##
# arithmetic operators - +, -, *, /, ^
# logs - log(), log2(), log10()
# offsets - lead(), lag()
# cumulative/rolling aggregates - cumsum(), cumprod(), cummin(), cummax(), cummean()
# logical comparisons
# ranking - min_rank(), row_number(), etc.
##################################

## Practice questions ##
# Convert dep_time and sched_dep_time to minutes past midnight
# mutate(flights,
#        dep_time = toString(dep_time),
#        dep_minutes = as.numeric(substr(dep_time, nchar(dep_time)-2, nchar(dep_time))), #grab the number of minutes past the hour
#        dep_hours = round(as.numeric(dep_time, -2)) * 60, #round down to nearest hour and convert to minutes
#        dep_time = dep_hours + dep_time
# )
#
# Find the 10 most delayed flights
# ranked <- 
#   mutate(flights, delay_rank = percent_rank(dep_delay)) %>%
#   arrange(., desc(delay_rank)) 
# ranked[1:10, ]
#########################


### Section 5.6: Grouped summaries with summarise() ###
#summarise() will collapse the data according to a given function
summarise(flights, delay = mean(dep_delay, na.rm = T))

#it is especially useful when used with group_by()
by_day <- 
  group_by(flights, year, month, day) %>%
  summarise(., delay = mean(dep_delay, na.rm = T))

#The pipe operator %>% is an amazing way to combine multiple operations
by_dist <- flights %>%
  group_by(dist) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm=T),
    delay = mean(arr_delay, na.rm=T)
  ) %>%
  filter(count > 20, dest != "HNL")

#Behind the scenes, x %>% f(y) turns into f(x,y) and x %>% f(y) %>% g(z) turns into g(f(x,y))

#NOTE: Whenever you're doing aggregation, it is usually important to keep track of missing values by removing them or counting them

#as an example, let's investigate which plans have the highest delays
not_cancelled <- flights %>%
  filter(!is.na(dep_delay) | !is.na(arr_delay))

delays <- not_cancelled %>%
  group_by(tailnum) %>% #tailnum is the identifier for unique planes
  summarise(
    delay = mean(arr_delay)
  )

#plot the delays to get an idea of the distribution 
ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

#Are there actually some planes that have 300 minute delays?? 
  #it might be useful to check out how many flights these long waiting planes have gone on
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay, na.rm = T),
    count = n()
  )

ggplot(delays, mapping = aes(x = delay, y = count)) +
  geom_point(alpha = 1/10) +
  coord_flip() #we could have easily just switched delay and count, but I have written it to practice using coord_flip()

#Check out those results - the planes with the fewest amount of flights exhibit the most amount of variation (this should be intuitive)

#In order to get a better look at the average delays, filter out observations with very counts
delays %>%
  filter(count > 25) %>%
  ggplot(mapping = aes(x = count, y = delay)) +
    geom_point(alpha = 1/10)

#To explore this kind of variation more, let's look at the Batting data set from the Lahman package
batting <- as_tibble(Lahman::Batting)

#Let's look at the relationship between average performance and number of times at bat
batters <- batting %>%
  group_by(playerID) %>%
  summarise(
    ba = sum(H, na.rm = T) / sum(AB, na.rm = T), #batting average = hits / at bats
    ab = sum(AB, na.rm = T)
  )

batters %>%
  filter(ab > 10) %>%
  ggplot(mapping = aes(x = ab, y = ba)) +
    geom_point(alpha = 1/10) + 
    geom_smooth(se = F) #notice the different method that's being used - why is that?

#this observation is important - sorting by desc(ba) wouldn't tell us the whole story
  #if we did that, observations with very few counts (and greater variation) would skew a ranking system

#aggregation and logical subsetting go hand-in-hand
not_cancelled %>%
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) #only keep non-zero (no delay) flights to get an average delay if there is one
  ) 

## Useful summary functions ##
# measures of spread:
#   sd() - standard deviation
#   IGR() - interquartile range 
#   mad() - median absolute deviation
#   
# measures of rank:
#   min() - minimum
#   quantile(x, .25) - find a value of x between the 25th and 75th percentile
#   max() - maximum
#   range() - minimum and maximum of the argument
#   
# measures of position:
#   first() - observation indexed first
#   nth(x, j) - jth observation of x
#   last() - last observation
#   
# measures of count:
#   n() - num_obs
#   count() - num_obs
##############################

#If you ever need to remove a grouping, use ungroup()

## Practice Questions ##
# Look at the number of cancelled flights per day. Is there a pattern? (recall that arr_delay == NA implies cancelled flight)
#   Is the proportion of cancelled flights related to average delay?
cancellations <- flights %>%
  group_by(year, month, day) %>%
  summarise(
    total_flights = n(),
    total_cancelled = sum(is.na(arr_delay)),
    prop_cancelled = total_cancelled / total_flights,
    arr_delay = mean(arr_delay, na.rm=T)
  ) %>%
  #generate indicators for seasons -- still working on converting these to a single factor
  mutate(
    winter = as.numeric(month == 12 | month < 3),
    spring = as.numeric(month >= 3 | month <=5),
    summer = as.numeric(month >=6 | month <= 8),
    fall = as.numeric(month >=10 | month < 12)
  )

ggplot(data = cancellations) +
  geom_point(mapping = aes(x = prop_cancelled, y = arr_delay), alpha = 1/10) #once that season factor is created, try to split up coloring by season 

#Which carrier has the worst delays?
#  Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not?
carrier_dest_delays <- 
  flights %>%
  group_by(carrier, dest) %>%
  summarise(
    total_flights = n(),
    arr_delay = (mean(arr_delay, na.rm = T))
  ) %>%
  filter(total_flights > 365) #carrier-destination level flights that go at least once a day (on the whole)

most_dest <- flights %>%
  group_by(dest) %>%
  summarise(total_flights = n()) %>%
  filter(total_flights > 365) %>%
  arrange(desc(total_flights))

# ---------> this is just fooling around, nothing super serious

### Section 5.7: Grouped mutates and filters ###
#These are just some extra applications of dplyr on the flights set

#Find the worst ten flights per day
flights %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

#Find all destinations that have flights at least once a day (in the aggregate)
flights %>%
  group_by(dest) %>%
  filter(n() >= 365) 

## Important Note ##
# A grouped filter is a group mutate followed by an ungrouped filter
  # functions that work well in grouped mutates and filteres are called "window functions"
  # check out vignette('window-functions')


## Practice Questions ##
# Which plane (tailnum) has the worst on time record?
flights %>%
  mutate(
    on_time = as.numeric(arr_delay < 0) #indicator for having arrived on time
  ) %>%
  group_by(tailnum) %>%
  summarise(p_on_time = mean(on_time, na.rm=T)) %>% #for each plane (tailnum) calculate the proportion of on-time arrivals
  arrange(p_on_time)

# Find all destinations that are flown by at least two carriers
dest_flight <- flights %>%
  group_by(carrier, dest) %>%
  slice(c(1, n())) %>%
  ungroup() %>%
  group_by(dest) %>%
  mutate(count = 1) %>%
  summarise(tot_carriers = sum(count)) %>%
  filter(tot_carriers >= 2) %>%
  arrange(desc(tot_carriers))
