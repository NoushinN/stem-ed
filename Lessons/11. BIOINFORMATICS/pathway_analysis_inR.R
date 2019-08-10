###DEMO for gene pathway analysis###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# An R package for Reactome Pathway Analysis
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("ReactomePA", version = "3.8")


library(ReactomePA)
browseVignettes("ReactomePA")


de <- wt_res_all$ensgene



library(org.Hs.eg.db)
library(DOSE)
library(ReactomePA)

library(GSEABase)
library(hgu95av2.db)
library(GO.db)


## ------------------------------------------------------------------------
library(ReactomePA)
data(geneList)
de <- names(geneList)[abs(geneList) > 1.5]
head(de)
x <- enrichPathway(gene=de,pvalueCutoff=0.05, readable=T)
head(as.data.frame(x))

## ----fig.height=6, fig.width=12------------------------------------------
barplot(x, showCategory=8)

## ----fig.height=6, fig.width=12------------------------------------------
dotplot(x, showCategory=15)

## ----fig.height=10, fig.width=10-----------------------------------------
emapplot(x)

## ----fig.height=8, fig.width=8-------------------------------------------
cnetplot(x, categorySize="pvalue", foldChange=geneList)

## ----fig.height=8, fig.width=13, eval=FALSE------------------------------
#  require(clusterProfiler)
#  data(gcSample)
#  res <- compareCluster(gcSample, fun="enrichPathway")
#  dotplot(res)

## ------------------------------------------------------------------------
y <- gsePathway(geneList, nPerm=10000,
                pvalueCutoff=0.2,
                pAdjustMethod="BH", verbose=FALSE)
res <- as.data.frame(y)
head(res)

## ----fig.height=8, fig.width=8-------------------------------------------
emapplot(y, color="pvalue")

## ----fig.height=7, fig.width=10------------------------------------------
gseaplot(y, geneSetID = "R-HSA-69242")

## ----fig.height=8, fig.width=8-------------------------------------------
viewPathway("E2F mediated regulation of DNA replication", readable=TRUE, foldChange=geneList)






# convert gene id
library(org.Dm.eg.db)
gene.id <- AnnotationDbi::select(org.Dm.eg.db, names(wt_res_all$ensgene), "ENTREZID", "FLYBASE")
names(statistic) <- gene.id[,2]
rownames(exprs.pasilla) <- gene.id[,2]

# GO_dme
load(system.file("data", "GO_dme.rda", package = "gsean"))

# GSEA
set.seed(1)
result.GSEA <- gsean(GO_dme, statistic, exprs.pasilla)
invisible(capture.output(p <- GSEA.barplot(result.GSEA, category = 'pathway',
                                           score = 'NES', top = 50, pvalue = 'padj',
                                           sort = 'padj', numChar = 110) + 
                           theme(plot.margin = margin(10, 10, 10, 50))))
plotly::ggplotly(p)

