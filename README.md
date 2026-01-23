# ABA - Accelerated Biodiversity Assessment
The Accelerated Biodiversity Assessment (ABA) is an approach to accelerating knowledge of marine biodiversity. ABA entails low-pass whole genome sequencing to obtain high-copy mitochondrial and nuclear genetic markers, quick morphological analysis, and different methods of collection. 

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/4b4ed914-3f19-4e4b-a0f0-56279566218f" />

## Step 1 - Collection
Every marine biodiversity assessment should be based on a good collection design. In mesophotic and deep waters, where collections usually rely on cameras on a remotely operated vehicle (ROV), some fauna may be overlooked due to their size or cryptic habitat. Any monitoring or impact assessment that relies on a single sampling approach will miss a non-trivial fraction of the community, potentially biasing conservation decisions.
  For monitoring purposes, we suggest using Autonomous Reef Monitoring Structures (ARMS) at sentinel sites and ROV collections to record macrobiodiversity in site collections. For mesophotic depths, 2 years of bottom time is sufficient for ARMS monitoring, whereas for deep depths, 5 years is required.

## Step 2 - DNA assessment
Genome skimming (low-pass whole-genome sequencing) provides a higher success rate in recovering barcoding markers (18S rRNA, 28S rRNA, and mitochondrial COX1) on the first attempt than PCR-based methods. For this reason, this comes as the fastest and most reliable method for barcoding assessment.

## Step 3 - AcceSponge Pipeline
Quality control report raw samples
Trimming
Quality control report trimmed samples
Metagenome assembly
Mitogenome annotation
CustomBlast with 18S/28S database
Annotation of contigs contain ribossomal sequences
Extraction of 18S, 28S and COX1
Alignment with the database
Alignment inspection
Maximum Likelihood tree
Distance Matrix
UPGMA analysis
Diversity analysis

## Step 4 - Report to inform conservation
Based on the data generated, we can produce reports to inform decision-makers and provide subsidies to support conservation-related decisions.
