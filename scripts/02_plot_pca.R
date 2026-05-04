library(tidyverse)
library(ggrepel)

# Load PCA
pca <- read.table("sparrow_pca.eigenvec", header = FALSE)

colnames(pca)[3:4] <- c("PC1", "PC2")

# Load populations
pops <- read.table("populations_plink.txt", header = FALSE)
colnames(pops) <- c("FID", "IID", "Population")

pca <- left_join(pca, pops, by = c("V1" = "FID", "V2" = "IID"))

# Load eigenvalues
eigenval <- scan("sparrow_pca.eigenval")
pve <- eigenval / sum(eigenval) * 100

# Centroids
centroids <- pca %>%
  group_by(Population) %>%
  summarise(PC1 = mean(PC1), PC2 = mean(PC2), .groups = "drop")

# PCA plot
p <- ggplot(pca, aes(PC1, PC2, color = Population)) +
  geom_point(size = 2.5, alpha = 0.8) +
  geom_text_repel(
    data = centroids,
    aes(label = Population),
    color = "black",
    size = 4,
    fontface = "bold"
  ) +
  theme_classic(base_size = 15) +
  labs(
    title = "House Sparrow PCA",
    x = paste0("PC1 (", round(pve[1], 2), "%)"),
    y = paste0("PC2 (", round(pve[2], 2), "%)")
  )

ggsave("figures/PCA_main.png", p, width = 8, height = 6)
