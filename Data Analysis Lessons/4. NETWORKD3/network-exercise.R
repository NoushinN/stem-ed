###DEMO for NetworkD3 example exercise###
# Lessons are adapted and organized by Noushin Nabavi, PhD.


# load package dependencies
library(networkD3)
library(here)
library(data.table)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(reshape2)
library(formattable)
library(tibble)
library(heatmap3)
library(ggrepel)


#-------------------------------------------------------------------------------

# Load Human Network 
network <- fread(here("IPAC_data.csv"))

#only read first names
network$FROM <- gsub("^(.*?)\\s.*", "\\1", network$FROM)

#-------------------------------------------------------------------------------


#Make Edge List
from <- network$FROM
to <-   network$TO

# network design
member.net <- data.frame(from, to)

#Check Edge List
View(member.net)

#Plot Simple Network from Edge List - interactive html widget
simpleNetwork(member.net)

#Customise widget
simpleNetwork(member.net, 
              fontSize = 12, 
              nodeColour = "#AA4371",
              fontFamily = "sans-serif",
              zoom = FALSE, opacity = 1, linkDistance = 100,
              linkColour = "#37004D", charge = -30)


#-------------------------------------------------------------------------------

links <- separate_rows(network, TO, convert = TRUE) %>%
  select(FROM, TO, Weight)


nodes <- network %>%
  select(FROM, TO) %>%
  rename(name = FROM, group = TO)

nodes$group <- as.numeric(as.factor(nodes$group))

#network$ID <- 1:nrow(network)
#network$FROM <- as.numeric(as.factor(network$FROM))
#y <- network %>%
#  spread(key = FROM, value =TO)  


#Check anatomy data: note additional attributes (link values, node groups)
View(nodes)
View(links)


ColourScale <- 'd3.scaleOrdinal()
            .domain(["lions", "tigers"])
           .range(["#FF6900", "#694489"]);'


#Plot basic anatomy network
forceNetwork(Nodes = nodes, Links = links,
             NodeID = "name", Group = "group",
             Source = "FROM", Target = "TO", Value = "Weight", 
             height = 500, width = 1000, fontSize = 20, opacity = 0.7, 
             colourScale =JS(ColourScale), 
             zoom = T, legend = T)




#Customise widget
forceNetwork(Nodes = nodes, Links = links,
             NodeID = "name", Group = "group",
             Source = "FROM", Target = "TO", Value = "Weight",
             legend = TRUE, 
             fontSize = 50,
             opacity = 1, 
             charge = -500,
             colourScale = "d3.scale.category20b()",
             zoom = TRUE)


#-------------------------------------------------------------------------------

# load GBA+ data
gba <- readxl::read_xlsx(here("gba.xlsx"))

ministry <- gba %>%
  dplyr::select(Ministry) %>%
  arrange(desc(Ministry)) 

op <- par(mar = c(20,4,4,1) + 0.4)
barplot(table(ministry), las = 2, col = rainbow(30), font=1) 

#-------------------------------------------------------------------------------

ministry <- gba %>%
  dplyr::select(Ministry) %>%
  arrange(desc(Ministry)) %>%
  count(Ministry) %>%
  mutate(Percentage = prop.table(n) * 100) %>%
  na.omit() 


ggplot(ministry, aes(Ministry)) + 
  geom_bar(fill = "steelblue") +
  theme_minimal()


min <- gba %>%
  select(Ministry) %>%
  arrange(desc(Ministry)) 


ggplot(ministry, aes(x = Ministry, y = Percentage, fill = Ministry)) +
  geom_bar(stat = "identity") +
  scale_color_brewer(palette="Dark2") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  coord_polar("y", start=0) +  
  theme(axis.text.x=element_blank()) +
  geom_label_repel(aes(label = round(Percentage)), size=5, show.legend = F, nudge_x = 1) +
  guides(fill = guide_legend(title = "Group"))



ggplot(ministry, aes(x = Ministry, y = Percentage, fill = Ministry)) +
  geom_bar(stat = "identity") +
  scale_color_brewer(palette="Dark2") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  coord_polar() +
  theme_linedraw() +theme(axis.ticks =element_blank(), axis.text.y =element_blank(), axis.title=element_blank(), axis.text.x=element_text(size = 12,angle = 45)) 



#-------------------------------------------------------------------------------

# registered sectors
sector <- gba %>%
  dplyr::select(Sector...4) %>%
  arrange(desc(Sector...4)) %>%
  count(Sector...4) %>%
  mutate(Percentage = prop.table(n) * 100) %>%
  mutate(Sector = Sector...4) %>%
  na.omit() 


ggplot(sector, aes(x = Sector, y = Percentage, fill = Sector)) +
  geom_bar(stat = "identity") +
  scale_color_brewer(palette="Dark2") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  coord_polar("y", start=0) +
  geom_label_repel(aes(label = round(Percentage)), size=5, show.legend = F, nudge_x = 1) +
  guides(fill = guide_legend(title = "Group"))


ggplot(sector, aes(x = Sector, y = Percentage, fill = Sector)) +
  geom_bar(stat = "identity") +
  scale_color_brewer(palette="Dark2") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  coord_polar() + 
  theme_linedraw() +theme(axis.ticks =element_blank(), axis.text.y =element_blank(), axis.title=element_blank(), axis.text.x=element_text(size = 12,angle = 45)) 




sector <- gba %>%
  dplyr::select(Sector...4) %>%
  arrange(desc(Sector...4))

op <- par(mar = c(20,4,4,1) + 0.4)
barplot(table(sector), las = 2, col = rainbow(7), font=1)

#-------------------------------------------------------------------------------

# attended sectors

sector <- gba %>%
  dplyr::select(`Sector...8`, `Attended Count`, `%...12`) %>%
  rename(Sector = `Sector...8`, Count = `Attended Count`, Percentage = `%...12`) %>%
  arrange(desc(Sector)) %>%
  mutate(Percentage = round(Percentage * 100)) %>%
  na.omit() %>%
  slice(2:nrow(gba))
  


ggplot(sector, aes(x = Sector, y = Percentage, fill = Sector)) +
  geom_bar(stat = "identity") +
  scale_color_brewer(palette="Dark2") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  coord_polar("y", start=0) +
  geom_label_repel(aes(label = round(Percentage)), size=5, show.legend = F, nudge_x = 1) +
  guides(fill = guide_legend(title = "Group")) +
  theme_linedraw() +theme(axis.ticks =element_blank(), axis.text.y =element_blank(), axis.title=element_blank(), axis.text.x=element_text(size = 12,angle = 45)) 


ggplot(sector, aes(x = Sector, y = Percentage, fill = Sector)) +
  geom_bar(stat = "identity") +
  scale_color_brewer(palette="Dark2") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  coord_polar() + 
  theme_linedraw() +theme(axis.ticks =element_blank(), axis.text.y =element_blank(), axis.title=element_blank(), axis.text.x=element_text(size = 12,angle = 45)) 




sector <- gba %>%
  dplyr::select(Sector...4) %>%
  arrange(desc(Sector...4))

op <- par(mar = c(20,4,4,1) + 0.4)
barplot(table(sector), las = 2, col = rainbow(7), font=1)




#-------------------------------------------------------------------------------

attendance <- gba %>%
  dplyr::select(Registered, Attended) 

attendance_clean <- slice(attendance, 1:64)

factor(attendance_clean$Registered) 
factor(attendance_clean$Attended) 


ggplot(attendance_clean) + 
        geom_bar(aes(Registered)) +
        facet_wrap(~Attended) +
        facet_grid(Registered ~ Attended, labeller = label_both) +
  theme(
    strip.background = element_rect(
      color="black", fill="#FC4E07", size=1.5, linetype="solid"
    )
  )


tabplot::tableplot(gba)



