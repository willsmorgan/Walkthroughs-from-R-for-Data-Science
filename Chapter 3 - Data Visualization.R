#R for Data Science - Hadley Wickham
#Script author: William  Morgan

##### Chapter 3: Data Visualization #####

#Objectives -
#This is the beginning of a set of scripts walking through Hadley Wickham's book;
#It is meant to be a personal guide for learning R as I progress through the chapters and as a reference for any other students of R

#Notes -
#Some sections of the chapter may be skipped due to length or if I'm feeling particularly lazy
#########################################

### Section 3.2: First Steps ###
library('tidyverse')

#Take a peek at the structure of the mpg data set contained in ggplot2
ggplot2::mpg 

#Let's begin with a plot of fuel efficiency against engine size
ggplot(data = mpg) + #tell ggplot the data set it is using 
  geom_point(mapping = aes(x = displ, y = hwy)) #add a layer of points to the plot with a mapping and specified points

#Generalize the above code so you can remember it later
#ggplot(data = <DATA>) + 
#   <GEOM_FN>(mapping = aes(<MAPPINGS>))
#

#Practice making a scatterplot of hwy vs cyl
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = hwy, y = cyl))


### Section 3.3: Aesthetic Mappings ###
#Definition - Aesthetic
#an aesthetic is a visual property of the objects in a plot
#this can include the size, shape, or color of your points

#Add some pizazz to the original aesthetic we created with the fuel efficieny graph
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) #the color is automatically set and unique to each class of vehicle

#Instead of setting color according to class, try setting size instead
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class)) 

#alpha (transparency) and shape can also be set according to class
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class)) 

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class)) 

#We can also set the aesthetic properties of the plot within the geom function
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = 'blue') 


### Section 3.5: Facets ###
#You can split your plot into facets, which can be particularly useful for factor variables

#To facet your plot by a single variable, add facet_wrap the the original ggplot() command
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class)) +
  facet_wrap(~ class, nrow = 2) #make sure you're putting in a discrete variable

#To facet your plot on a combination of variables, add facet_grid() to the plot call
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

### Section 3.6 Geometric Objects ###
#A geom is the geometrical object that is used to plot the points in your graph
  #scatterplots use geom_point(), bar charts use bar geoms, etc.

#show the differences between geom_point and geom_line
ggplot(data = mpg) + 
  geom_point(mapping = aes(x=displ, y=hwy))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x=displ, y=hwy))

#keep in mind that certain not all aesthetics work with each geom
ggplot(data = mpg) + 
  geom_point(mapping = aes(x=displ, y=hwy, linetype=drv)) #linetype = '' is automatically ignored

#linetype can be split and color coded by a chosen variable
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x=displ, y=hwy, linetype=drv)) 

#if you just want to group without coloring, use the group = '' argument
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x=displ, y=hwy, group=drv)) 

#you can layer several geometric objects
ggplot(data = mpg) + 
  geom_point(mapping = aes(x=displ, y=hwy, color = drv)) + 
  geom_smooth(mapping = aes(x=displ, y=hwy, color=drv))

#To clean up our code, pass the mapping argument through ggplot()
ggplot(data = mpg, mapping = aes(x=displ, y=hwy, color=drv)) + 
  geom_point() + 
  geom_smooth()

#Putting a mapping in a geom will treat it as a local mapping for the current layer
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) +
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE) #observe how all class points are plotted, but the line is only for subcompact cars

#Practice graphs to replicate
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + #top-left
  geom_point(stroke = 3) +
  geom_smooth(color = 'blue', se= F)

ggplot(data = mpg) + #top-right
  geom_point(mapping = aes(x = displ, y = hwy), stroke = 2.5) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv), se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + #mid-left
  geom_point() +
  geom_smooth(se = F)

ggplot(data = mpg) + #mid-right
  geom_smooth(mapping = aes(x = displ, y = hwy), se = F) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))

ggplot(data = mpg) + #bottom-left
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv), se = F) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))

#I don't feel like doing the bottom right so suck it up

### Section 3.7: Statistical Transformations ###
#Definition - stat
  #A stat is an algorithm that is used to transform the data when making a graph
  #histograms do this when they count the num_obs in the bins

#check which stat a geom might by looking at the default on the geom's documentation
  #stats can usually be used interchangeably with the geom's that use them


### Section 3.8: Position Adjustments ###
#Coloring a bar chart can be done with color = '' (outline) or fill = '' (fills the bar) in the aesthetic
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, color = cut)) 

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut)) 

#fill can also be attributed to another variable in order to stack each bar
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

#if you don't want to stack but still want the fill, change the position argument of the geom
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity") #places each object exactly where it falls in the context of the graph (notice transparency to reduce overlapping)

ggplot(data = diamonds, mapping = aes(x = cut, color = clarity)) + 
  geom_bar(fill = NA, position = "identity") #reduces overlapping by getting rid of fill

#position = 'fill' is like stacking, but equalizes the height of each bar
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = 'fill')

#position = 'dodge' places overlapping objects beside each other
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = 'dodge')

#sometimes, bar graphs can hide overlapping points and conceal clumps of data
  #use position = 'jitter' to slightly add some noise to each point to reveal clumps again
ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = 'jitter')


### Section 3.9: Coordinate Systems ###
#coord_flip() switches the x and y axes 
#coord_quickmap() automatically sets the aspect ratio correctly for maps (important for spatial data) 
#coor_polar() uses polar coordinates

### Section 3.10: The layered grammar of graphing (Chapter review) ###

#We now have a basic working template for graphing with ggplot2

#ggplot(data = <DATA>) + 
#  <GEOM_FUNCTION>(
#    mapping = aes(<MAPPINGS>),
#    stat = <STAT>, 
#    position = <POSITION>
#  ) +
#  <COORDINATE_FUNCTION> +
#  <FACET_FUNCT
