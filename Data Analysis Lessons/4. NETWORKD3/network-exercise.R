###DEMO for NetworkD3 example exercise###
# Lessons are adapted and organized by Noushin Nabavi, PhD.


# load package dependencies
library(networkD3)
library(here)
library(data.table)


# Load Human Network 
network <- fread(here("Data Analysis Lessons", "4. NETWORKD3", "data", "IPAC_data.csv"))

#Make Edge List
from <- network$FROM
to <-   network$TO

member.net <- data.frame(from, to)

#Check Edge List
View(member.net)

#Plot Simple Network from Edge List - interactive html widget
simpleNetwork(member.net)

#Customise widget
simpleNetwork(member.net, 
              fontSize = 12, 
              nodeColour = "#afafaf",
              fontFamily = "sans-serif",
              zoom = TRUE, opacity = 1)


# Anatomy Network Analysis 
#Read in data: product nodes & links between of physiology
nodes <- read.csv(file.choose(), sep = ",", header = TRUE)
links <- read.csv(file.choose(), sep = ",", header = TRUE)

#Check anatomy data: note additional attributes (link values, node groups)
View(nodes)
View(links)

#Plot basic anatomy network
forceNetwork(Nodes = nodes, Links = links,
             NodeID = "name", Group = "group",
             Source = "from", Target = "to", Value = "weight")

#Customise widget
forceNetwork(Nodes = nodes, Links = links,
             NodeID = "name", Group = "group",
             Source = "from", Target = "to", Value = "weight",
             legend = TRUE, 
             fontSize = 50,
             opacity = 1, 
             charge = -500,
             zoom = TRUE)


# Create a D3 JavaScript force directed network graph.
## Bigger Network example 
data(MisLinks)
data(MisNodes)

View(MisLinks)
View(MisNodes)

forceNetwork(Nodes = MisNodes, Links = MisLinks,
             NodeID = "name", Group = "group",
             Source = "source", Target = "target", Value = "value",
             legend = TRUE, 
             fontSize = 50,
             opacity = 1, 
             charge = -500,
             zoom = TRUE)
