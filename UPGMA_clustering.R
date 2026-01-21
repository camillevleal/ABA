# Before start, download the distance matrix in Geneious
# Open it, find and replace the empty cells for 100
# Erase the 100 in the first line and column
# Save it

# Load the package
library(ape)
library(dendextend)

setwd("/Users/lealc/Library/CloudStorage/OneDrive-SmithsonianInstitution/Documents/Taxonomy_and_Phylogeny/Molecular Biodiversity MBDC+Florida/Final_data")  # Replace with the full path to your folder

# Load similarity matrix
dist_matrix <- read.csv("18S_identy_matrix.csv", header=TRUE, row.names=1, sep=",")

# Convert data frame to a numeric matrix
dist_matrix <- as.matrix(dist_matrix)

# Convert similarity (percent) to dissimilarity (distance) by normalizing
dist_matrix <- 1 - (dist_matrix / 100)  # Normalize and invert

# Convert to a distance object
dist_object <- as.dist(dist_matrix)

# Perform UPGMA clustering using hclust
upgma_tree <- hclust(dist_object, method = "average")  # "average" corresponds to UPGMA

# Save as a high-resolution PDF
pdf("UPGMA_dendrogram_18S_33.pdf", width=20, height=10)
plot(upgma_tree, main="UPGMA Clustering of 18S_33 Sponge DNA Samples", cex=0.3)  # Reduce label size
dev.off()

# Choose a height threshold to cut the tree (adjust based on your data)
cut_height <- 0.33  

# Create clusters
clusters <- cutree(upgma_tree, h=cut_height)

# Count the number of clusters
table(clusters)

# Add cluster labels to samples
clustered_samples <- data.frame(Sample=names(clusters), Cluster=clusters)
write.csv(clustered_samples, "Clustered_Samples_18S_33.csv", row.names=FALSE)

# Plot only a subset (e.g., first 100 clusters)
sub_tree <- as.dendrogram(upgma_tree)
sub_tree <- prune(sub_tree, names(clusters)[1:100])  # Adjust to show a subset

# Plot the reduced tree
plot(sub_tree, main="Subset of UPGMA Clustering")

# Save the tree in Newick format
write.tree(as.phylo(upgma_tree), file = "UPGMA_tree_18S_33.newick")



