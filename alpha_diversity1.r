# import necessary libraries
library(microbiome)
library(openxlsx)
library(ggpubr)

# Getting the data to work on
data(dietswap)
pseq <- dietswap
ps1 <- dietswap
q()
# calculate diversity indicators
tab <- alpha(pseq, index = "all")

# save results as excel file
write.xlsx(tab, "alpha_diversity.xlsx", colName = TRUE, rownames= TRUE)

# preparing data for visualization
ps1.meta <- meta(ps1)

# add shannon diversity to the meta data column
ps1.meta$shannon <- tab$diversity_shannon

# we want to compare differences in Shannon index between bmi group of the study subjects.
bmi <- levels(ps1.meta$bmi_group)
# all the possible combinations 
bmi.pairs <- combn(seq_along(bmi),2, simplify = FALSE, FUN = function(i)bmi[i])

# violin plot
p1 <- ggviolin(ps1.meta, x = "bmi_group", y = "shannon", add = "boxplot", fill = "bmi_group",palette = c("#a6cee3", "#b2df8a", "#fdbf6f"))
p2 <- p1 + stat_compare_means(comparisons = bmi.pairs)
print(p2)
