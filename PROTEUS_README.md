## How-to install microbiome-R into Proteus  

First, load R module and open R console  
`module load R/anaconda3`  
`R`  

Install BiocManager repository for microbiome library  
Install in personal directory if prompted  
`install.packages("BiocManager")`  


Do not update out-dated packages  

Install phyloseq dependency for microbiome  
`source('http://bioconductor.org/biocLite.R')`  
`biocLite('phyloseq')`  

Load BiocManager  
`library(BiocManager)`  


Install microbiome package  
`BiocManager::install("microbiome")`  

Installation may fail, but repeating the above steps should eventually work.  
 
Install dependencies for alpha diversity tutorial  
`BiocManager::install("openxlsx")`  
`BiocManager::install("ggpubr")`  

 
## Running Scripts

R scripts can be run using `R CMD BATCH <script-name.R>`  
e.g. `R CMD BATCH alpha_diversity1.R`  
Results are stored in `<script-name.Rout>`  
