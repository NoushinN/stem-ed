#load the expression data (xlsx)
library(readxl)
library(here)
require(gdata)
library(dplyr)
exp = read_excel("Sema3C-Vector_allData.xlsx", sheet = 1)

cleanexp <- exp[,-c(8:21)]
View(cleanexp)
cleanexp1 <- cleanexp[,-1]
cleanexp2 <- cleanexp1[c(7, 1, 2, 3, 4, 5, 6)]
View(cleanexp2)

write.csv(cleanexp2, "genes_removed_unwanted_columns.csv", row.names = FALSE)

# ----------------------------------------------------------------------------

exp1 = read.csv("genes_removed_unwanted_columns.csv", header=TRUE, row.names = NULL)
View(exp1)
sum(duplicated(exp1$GeneName))

exp_normalized = read.csv("normalized_counts.csv", header=TRUE, row.names = 1)
View(exp_normalized)

# ----------------------------------------------------------------------------

new_data <- cleanexp %>%
  filter(GeneName %in% c("SEMA3C", "AKR1C1", "AKR1C2", "AKR1C3", "UGT2B10", "UGT2B11", "UGT2B15", "UGT2B17"))
ensemble_gene_list <- new_data$Ensembl


new_data7 <- cleanexp %>%
  filter(GeneName %in% c("SEMA3C", "AKR1C1", "AKR1C2", "UGT2B10", "UGT2B11", "UGT2B15", "UGT2B17"))
ensemble_gene_list <- new_data7$Ensembl

# ----------------------------------------------------------------------------

ensexp <- new_data7[,-1]
ensexp2 <- ensexp[c(7, 1, 2, 3, 4, 5, 6)]
View(ensexp2)

write.csv(ensexp2, "7-gene.csv", row.names = FALSE)
# ----------------------------------------------------------------------------

# generate plot
library(ggplot2)
library(RColorBrewer)

ensexp2 = read.csv("8-gene.csv", header=TRUE, row.names = 1)
View(ensexp2)
# ----------------------------------------------------------------------------
ensexp2 = read.csv("7-gene.csv", header=TRUE, row.names = 1)
View(ensexp2)

class(ensexp2)
ensexp2 <- as.matrix(ensexp2)

datm <- reshape2::melt(as.matrix(ensexp2))
View(datm)
colnames(datm) <- c("Gene","Treatment","Expression")


ggplot(datm, aes(x=Treatment, y=Expression)) +
  geom_bar(fill='#A4A4A4', color="darkred", stat = "identity") +
  #coord_cartesian(ylim = c(0, 20000)) +
  scale_y_log10() +
  facet_wrap(~Gene, ncol=4, scales = "free") +
  theme(
    axis.text.x = element_text(size = 6, color="black", angle = 90),
    axis.text.y = element_text(size = 5, color="black"),
    axis.title = element_text(size = 7, color="black"),
    plot.title = element_text(size = 10, color="black"),
    panel.grid.major = element_line(size=0.2),
    panel.grid.minor = element_line(size=0.1),				
    legend.position="bottom") + 
  ylab("normalized gene count") +
  xlab("") + 
  ggtitle("7 Gene comparisons") 



ggplot(datm, aes(x=Treatment, y=Expression)) +
  geom_boxplot(fill='#A4A4A4', color="darkred") +
  #coord_cartesian(ylim = c(0, 20000)) +
  scale_y_log10() +
  facet_wrap(~Gene, ncol=4, scales = "free") +
  theme(
    axis.text.x = element_text(size = 6, color="black", angle = 90),
    axis.text.y = element_text(size = 5, color="black"),
    axis.title = element_text(size = 7, color="black"),
    plot.title = element_text(size = 10, color="black"),
    panel.grid.major = element_line(size=0.2),
    panel.grid.minor = element_line(size=0.1),				
    legend.position="bottom") + 
  ylab("normalized gene count") +
  xlab("") + 
  ggtitle("7 Gene comparisons") 

# ----------------------------------------------------------------------------

datm$Group <- ""
datm$Group[which(datm$Treatment  == "Sema3C1")] <- "Sema3C"
datm$Group[which(datm$Treatment    == "Sema3C2")] <- "Sema3C"
datm$Group[which(datm$Treatment    == "Sema3C3")] <- "Sema3C"
datm$Group[which(datm$Treatment    == "Vector1")] <- "Control"
datm$Group[which(datm$Treatment    == "Vector2")] <- "Control"
datm$Group[which(datm$Treatment    == "Vector3")] <- "Control"


datm$Color <- ""
datm$Color[which(datm$Treatment  == "Sema3C1")] <- "red"
datm$Color[which(datm$Treatment    == "Sema3C2")] <- "red"
datm$Color[which(datm$Treatment    == "Sema3C3")] <- "red"
datm$Color[which(datm$Treatment    == "Vector1")] <- "blue"
datm$Color[which(datm$Treatment    == "Vector2")] <- "blue"
datm$Color[which(datm$Treatment    == "Vector3")] <- "blue"

View(datm)

ggplot(datm, aes(x=Group, y=Expression)) +
  geom_bar(fill=rgb(0.1,0.4,0.5,0.7), color="darkred", stat = "identity") +
  #coord_cartesian(ylim = c(0, 20000)) +
  scale_y_log10() +
  scale_fill_identity() +
  facet_wrap(~Gene, ncol=4, scales = "free") +
  theme(
    axis.text.x = element_text(size = 6, color="black", angle = 90),
    axis.text.y = element_text(size = 5, color="black"),
    axis.title = element_text(size = 7, color="black"),
    plot.title = element_text(size = 10, color="black"),
    panel.grid.major = element_line(size=0.2),
    panel.grid.minor = element_line(size=0.1),				
    legend.position="bottom") + 
  ylab("normalized gene count") +
  xlab("") + 
  ggtitle("7 Gene comparisons") 


ggplot(datm) +
  geom_point(aes(x = Gene, y = Expression,
                 color = Group)) +
  scale_y_log10() +
  xlab("Genes") +
  ylab("Normalized Counts") +
  ggtitle("7 Gene Panel") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) 

# ----------------------------------------------------------------------------
install.packages("corrplot")
library(corrplot)

t(ensexp2)
dat <-cor(t(ensexp2))
corrplot(dat, method="color")
corrplot(dat, method="number")
corrplot(dat, type="lower", order="hclust", col=c("black", "white"),
         bg="lightblue")

