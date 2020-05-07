# ECES 450
# Tutorial 4
# PERMANOVA

# Load libraries
library(microbiome)
library(ggplot2)
library(dplyr)

# Probiotics intervention example data
data(peerj32) 


#---------------------------------------------------------------------------------------------------------------

#Data in R is stored in data frame objects, which have tabular data and named row/column headers
ls(peerj32)


#The 'microbiome' package utilizes the 'phyloseq' package, which specifies data structures for genetic data
pseq <- peerj32$phyloseq

# Phyloseq object has OTU, taxa, and metadata
pseq



#peerj32 data set tracks intestinal microbial counts for persons before/after treatment with probiotic vs. placebo
head(sample_data(pseq))



# Display first 10 OTU abundances for first 5 samples
otu_table(pseq)[1:10,1:5]


# Get summary information
summarize_phyloseq(pseq)


#-----------------------------------------------------------------------------------------------------------------

# Calculate relative abundances
pseq.rel <- microbiome::transform(pseq, "compositional")
otu <- abundances(pseq.rel)
meta <- meta(pseq.rel)


# Visualize microbiome variation
# Observe population density 
# Plot = Non-metric Multidimensional Scaling
# Distance = Bray-Curtis
# Labels = Treatment Group (Probiotic vs. Placbeo)
p <- plot_landscape(pseq.rel, method = "NMDS", distance = "bray", col = "group", size = 3)
print(p)
# Plot available in Rplots.pdf


#-----------------------------------------------------------------------------------------------------------------

# PERMANOVA significance test for group-level differences
# Examine if  group (probiotics vs. placebo) has a significant effect on overall gut microbiota composition
library(vegan)

# Label samples by Treatment Group
# Perform 99 permutations
# Use Bray-Curtis for distance measure
permanova <- adonis(t(otu) ~ group, data = meta, permutations=99, method = "bray")

# P-value = Statistical Confidence of coming from same distribution
print(as.data.frame(permanova$aov.tab)["group", "Pr(>F)"])
# Low p-value indicates that probiotic and placebo microbiomes are DIFFERENT communities


#----------------------------------------------------------------------------------------------------------------

# PERMANOVA conclusions depend on assumption that group variances are similar
# Use ANOVA to assess if avg. group distributions are similar
dist <- vegdist(t(otu))
anova(betadisper(dist, meta$group))
# ANOVA indicates group variances are very similar (p-value high)


# Identify which taxa are strongest separators of treatment groups
coef <- coefficients(permanova)["group1",]
top.coef <- coef[rev(order(abs(coef)))[1:20]]
par(mar = c(3, 14, 2, 1))
barplot(sort(top.coef), horiz = T, las = 1, main = "Top taxa")
# Plot available in Rplots.pdf



