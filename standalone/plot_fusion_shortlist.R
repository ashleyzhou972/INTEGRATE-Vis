###################
rm(list = ls())
library(biomaRt)
library(TempusVCF)
library(magrittr)
setwd('/Users/naihui.zhou/rna/bio-6262-fusion-visualization')
shortlist <- read.csv("shortlist_1124.csv")
shortlist <- shortlist %>% tidyr::separate(fusion, into=c("gene5", "gene3"), 
                                           sep = '-',  remove = F)

samples <- read.csv("./all_samples.csv")

fusion1 <-subset(samples, gene_5 == 'SMARCA2' & gene_3 == 'UHRF2')
fusion1 <- fusion1 %>% dplyr::mutate(direct_support = as.numeric(direct_support),
                                     indirect_support = as.numeric(indirect_support),
                                     total_support = direct_support + indirect_support) %>%
  dplyr::filter(total_support  > 20) %>% dplyr::arrange(total_support)

data.table::fwrite(fusion1, )

samples_shortlist <- subset(samples, gene_5 %in% shortlist$gene5 & 
                              gene_3 %in% shortlist$gene3 &
                              rank_all_samples==1)

temp <- subset(samples, gene_5 == 'SMARCA2' & gene_3 == 'UHRF2')

samples_dedup <- samples_shortlist %>% dplyr::group_by(gene_5, gene_3) %>%
  dplyr::arrange(gene_5, gene_3,desc(direct_support), desc(indirect_support)) %>%
  dplyr::filter(dplyr::row_number()==1) %>%
  dplyr::select(gene_5, gene_3, breakpoint_5, breakpoint_3, transcript_5, transcript_3, id) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(fusion = paste0(gene_5, '-', gene_3)) %>%
  dplyr::ungroup()

#167View(subset(samples_dedup, gene_5 == 'SMARCA2' & gene_3 == 'UHRF2'))

tsqc_links <- paste0("https://tsqc.securetempus.com/analyses/", samples_dedup$id, "/fusions")
tsqc_df <-cbind.data.frame(samples_dedup$fusion, tsqc_links)
data.table::fwrite(tsqc_df, "tsqc_links_wave1.csv")

## get ENSG from ENST
ensembl <- useEnsembl(biomart = "genes")
ensembl <- useDataset(dataset = "hsapiens_gene_ensembl", mart = ensembl)
ensg_5 <- getBM(filters= "ensembl_transcript_id", attributes= c("ensembl_transcript_id","ensembl_gene_id"),values=samples_dedup$transcript_5,mart= ensembl)
ensg_3 <- getBM(filters= "ensembl_transcript_id", attributes= c("ensembl_transcript_id","ensembl_gene_id"),values=samples_dedup$transcript_3,mart= ensembl)
colnames(ensg_5) <- c('transcript_5', 'ensg_5')
colnames(ensg_3) <- c("transcript_3", 'ensg_3')
samples_mapped <- samples_dedup %>% dplyr::left_join(ensg_5) %>% dplyr::left_join(ensg_3)

#samples_mapped[samples_mapped$gene_5 =='SOS1','ensg_5'] <-'ENSG00000115904'  
samples_mapped <-dplyr::select(samples_mapped, -id)

data.table::fwrite(samples_mapped, "samples_mapped_wave1.csv")
