###DEMO for RNASeq differentially expressed genes Analysis###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# Load library for DESeq2
library(DESeq2)
vignette("DESeq2") # to ask for help

# Load library for RColorBrewer
library(RColorBrewer)

# Load library for pheatmap
library(pheatmap)

# Load library for tidyverse
library(tidyverse)

# Metadata creation
# Create genotype vector
genotype <- c("wt", "wt", "wt", "wt", "wt", "wt")

# Create condition vector
condition <- c("control", "siRNA", "control", "siRNA", "control", "siRNA")

# Create data frame
rnaseq_metadata <- data.frame(genotype, condition)

# Assign the row names of the data frame
rownames(rnaseq_metadata) <- c("X1NC", "X1siRNA", "X2NC", "X2siRNA", "X3NC","X3siRNA")
View(rnaseq_metadata)

#-------------------------------------------------------------------------------------

#load the expression data (xlsx)

require(gdata)
exp = read.xls("OU_Txome_AssignedReads_NormalizedRPM.xlsx", sheet = 1, stringsAsFactors = FALSE)


#explore the expression dataset
View(exp)
dim(exp)
head(exp)

# Remove second column as well as last 6 from expression dataset
cleanexp <- exp[,-(2)]
cleanexp <- cleanexp[,-c(8:13)]
View(cleanexp)
apply(cleanexp, 2, summary)

# keep a copy of this new data 
write.csv(cleanexp, "removed_unwanted_columns.csv", row.names = FALSE)

#-------------------------------------------------------------------------------------

# re-load cleaned up csv gene expression data.frame into R
exp = read.csv("removed_unwanted_columns.csv", header=TRUE, row.names = 1)

exp <-round(exp,0) #the "-1" excludes column 1


# Organizing the data for DESeq2
# bringing in data for DESeq2: check sample order 
all(rownames(rnaseq_metadata) == colnames(exp))

# if not in order, need to re-order
match(colnames(exp), rownames(rnaseq_metadata))
idx <- match(colnames(exp), rownames(rnaseq_metadata)) 
reordered_metadata <- rnaseq_metadata[idx,]   
View(reordered_metadata)


# check sample order again
all(rownames(rnaseq_metadata) == colnames(exp))

#-------------------------------------------------------------------------------------

# create DESeq2 object
dds_wt <- DESeqDataSetFromMatrix(countData = exp,
                                 colData = rnaseq_metadata,
                                 design = ~ condition)
# Count normalization
dds_wt <- estimateSizeFactors(dds_wt)
sizeFactors(dds_wt)

# extract normalized counts
normalized_wt_counts <- counts(dds_wt, normalized = TRUE)
View(normalized_wt_counts)

#-------------------------------------------------------------------------------------

# QC methods to identify how similar the biological replicates are with one another
# Hierarchical correlation
# unsupervised clustering analyses: log transformation (vst = variance stabiliting stransformation)
vsd_wt <- vst(dds_wt, blind = TRUE)

# Hierarchical heatmap
# extract the vst matrix from the object
vsd_mat_wt <- assay(vsd_wt)

# compute pairwise correlation values
vsd_cor_wt <- cor(vsd_mat_wt)
View(vsd_cor_wt)

# correlation values between each sample
# 1 as highest correlation 
# biological replicates should cluster together and the conditions separate
pheatmap(vsd_cor_wt, annotation = select(rnaseq_metadata, condition))

# The biological replicates cluster together and the samples in different conditions cluster separately. 
# There are no outliers or samples with low correlation values relative to all other samples.

#-------------------------------------------------------------------------------------

# unsupervised clustering analyses
# Principal component analysis
plotPCA(vsd_wt, intgroup = "condition")

# 93% of variance come from sample groups and only 3% of variance comes from same condition groups

#-------------------------------------------------------------------------------------

# DE analysis
# model fitting with DESeq
dds_wt <- DESeq(dds_wt)

# explore the results to see how well the data fit the model
# DESeq2 model exploration - mean-variance relationship

# syntax for apply(): apply(data, rows/columns, function_to_apply)
# calculating mean for each gene (each row)
mean_counts <- apply(exp[,1:3], 1, mean)

# calculating variance for each gene (each row)
variance_counts <- apply(exp[,1:3], 1, var)

# plotting relationship between mean and variance
# creating a data frame with mean and variance for every gene
df <- data.frame(mean_counts, variance_counts)

ggplot(df) + 
  geom_point(aes(x = mean_counts, y = variance_counts)) +
  scale_y_log10() +
  scale_x_log10() +
  xlab("Mean counts per gene") +
  ylab("Variance per gene")

# variance increases with mean (expected for RNAseq count data)
# range in values for variance is greater for lower mean counts than higher mean counts (also expected for RNAseq count data)

# DESeq2 model exploration - dispersion estimates
plotDispEsts(dds_wt)

# each black dot is a gene with associated mean in dispersion values
# dispersion values decrease with increasing mean therefore good fit
# The assumptions DESeq2 makes are that the dispersions should generally decrease with increasing mean and that they should more or less follow the fitted line.


# DESeq2 model exploration - contrasts
wt_res <- results(dds_wt, 
        contrast = c("condition", "siRNA", "control"),
        alpha = 0.05)

# lower alpha values indicate less probability of identifying a gene as DE when it is not
# using commonly used alpha value of 0.05
# control is the base level, siRNA is the level to compare, and condition is the condition factor

# explore the 
plotMA(wt_res, ylim = c(-8,8))

# DE genes are colored red 
# LFC shrinkage
wt_res <- lfcShrink(dds_wt, 
                  contrast = c("condition", "siRNA", "control"),
                  res = wt_res)

plotMA(wt_res, ylim = c(-8,8)) 
# more restricted log2 change values


#-------------------------------------------------------------------------------------

# explore DEG: DESeq2 results
mcols(wt_res)
head(wt_res, n = 10)
summary(wt_res)

wt_res <- results(dds_wt, 
                  contrast = c("condition", "siRNA", "control"),
                  alpha = 0.05,
                  lfcThreshold = 0.32) #1.25 FC threshold

wt_res <- lfcShrink(dds_wt, 
                    contrast = c("condition", "siRNA", "control"),
                    res = wt_res)

summary(wt_res)
View(wt_res)

#-------------------------------------------------------------------------------------
# extract the significant DE genes 
library(plyr)
wt_res_sig <-subset(wt_res, padj <0.05) 
View(wt_res_sig)
summary(wt_res_sig)
wt_res_sig
class(wt_res_sig)

wt_res_sig <- rownames_to_column(as.data.frame(wt_res_sig), var = "ensgene")

wt_res_sig <- wt_res_sig %>%
  arrange(padj)

#-------------------------------------------------------------------------------------
devtools::install_github("stephenturner/annotables")
library(annotables)
library(tibble)
wt_res_all <- as.data.frame(wt_res_sig) %>%
  dplyr::left_join(x = wt_res_sig,
                   y = grcm38[,c("ensgene", "symbol", "description")],
                   by = "ensgene")

View(wt_res_all)

#-------------------------------------------------------------------------------------
# Visualization of results

#subset normalized counts to significant genes
sig_norm_counts_wt <- normalized_wt_counts[wt_res_sig$ensgene, ]

# chose a color palette from rcolorbrewer
display.brewer.all()
heat_colors <- brewer.pal(6, "YlOrRd")

# run heatmap
pheatmap(sig_norm_counts_wt,
         color = heat_colors,
         cluster_rows = TRUE,
         show_rownames = FALSE,
         annotation = select(rnaseq_metadata, condition),
         scale = "row")

# run volcanoplot
wt_res_all <- wt_res_all %>%
  mutate(threshold = padj <0.05)

# write-out the genes
write.csv(wt_res_all[,-8:-10], "sig_genes_1.25FC_0.05.csv", row.names = FALSE)


ggplot(wt_res_all) +
  geom_point(aes(x = log2FoldChange, y = -log10(padj),
                 color = threshold)) +
  xlab("log2 fold change") +
  ylab("-log10 adjusted p-value") +
  ylim(0,20) +
  theme(legend.position = "none",
        plot.title = element_text(size = rel(1.5), hjust = 0.5),
        axis.title = element_text(size = rel(1.25)))

#-------------------------------------------------------------------------------------

# visualize top 20 genes
top_20 <- data.frame(sig_norm_counts_wt)[1:20,] %>%
  rownames_to_column(var = "ensgene")

library(tidyr)
top_20 <- gather(top_20,
                 key = "samplename",
                 value ="normalized_counts",
                 2:7) 

top_20 <- inner_join(top_20,
                     rownames_to_column(rnaseq_metadata, var = "samplename"),
                     by = "samplename")

ggplot(top_20) +
  geom_point(aes(x = ensgene, y = normalized_counts,
                 color = condition)) +
  scale_y_log10() +
  xlab("Genes") +
  ylab("Normalized Counts") +
  ggtitle("Top 20 Significant DE Genes") +
  theme_bw() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        theme(plot.title = element_text(hjust = 0.5)) 

#-------------------------------------------------------------------------------------
  
# RNA-Seq DE analysis summary - setup
