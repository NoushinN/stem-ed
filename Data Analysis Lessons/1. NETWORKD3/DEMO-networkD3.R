###DEMO for NetworkD3###
# Lessons are adapted, created, and organized by Noushin Nabavi, PhD.

setwd("~/STEM_Education/RStudio Workshops/NETWORKD3")
getwd()

#Install and load networkD3 package
install.packages("networkD3")
library(networkD3)


# Genetic Network 

#Make Edge List
from <- c("Gene1","Gene1", "Gene3","Gene4","Gene5", "Gene6")
to <-   c("Protein1","Protein2","Protein3", "Protein4", "Protein5","Protein6")

gene.net <- data.frame(from, to)

#Check Edge List
View(gene.net)

#Plot Simple Network from Edge List - interactive html widget
simpleNetwork(gene.net)

#Customise widget
simpleNetwork(gene.net, 
              fontSize = 25, 
              nodeColour = "#3182bd",
              fontFamily = "sans-serif",
              zoom = TRUE)


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
