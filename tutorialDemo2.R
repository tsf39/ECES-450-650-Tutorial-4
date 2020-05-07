library(MicrobeDS)
library(microbiome)
library(dplyr)
library(vegan)
data(MovingPictures)

# Pick the metadata for this subject and sort the
# samples by time

# Pick the data and modify variable names
pseq <- MovingPictures
s <- "F4" # Selected subject
b <- "UBERON:feces" # Selected body site

# Let us pick a subset
pseq <- subset_samples(MovingPictures, host_subject_id == s & body_site == b) 

# Rename variables
sample_data(pseq)$subject <- sample_data(pseq)$host_subject_id
sample_data(pseq)$sample <- sample_data(pseq)$X.SampleID

# Tidy up the time point information (convert from dates to days)
sample_data(pseq)$time <- as.numeric(as.Date(gsub(" 0:00", "", as.character(sample_data(pseq)$collection_timestamp)), "%m/%d/%Y") - as.Date("10/21/08", "%m/%d/%Y"))

# Order the entries by time
df <- meta(pseq) %>% arrange(time)

# Calculate the beta diversity between each time point and
# the baseline (first) time point
beta <- c() # Baseline similarity
s0 <- subset(df, time == 0)$sample
# Let us transform to relative abundance for Bray-Curtis calculations
a <- abundances(transform(pseq, "compositional")) 
for (tp in df$time[-1]) {
  # Pick the samples for this subject
  # If the same time point has more than one sample,
  # pick one at random
  st <- sample(subset(df, time == tp)$sample, 1)
  # Beta diversity between the current time point and baseline
  b <- vegdist(rbind(a[, s0], a[, st]), method = "bray")
  # Add to the list
  beta <- rbind(beta, c(tp, b))
}
colnames(beta) <- c("time", "beta")
beta <- as.data.frame(beta)

theme_set(theme_bw(20))
library(ggplot2)
p <- ggplot(beta, aes(x = time, y = beta)) +
  geom_point() +
  geom_line() +
  geom_smooth() +
  labs(x = "Time (Days)", y = "Beta diversity (Bray-Curtis)")
print(p)