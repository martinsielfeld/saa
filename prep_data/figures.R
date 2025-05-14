#####################################################################
##
## Prep data
##
## The following code prepares the data for the School Assignment 
## Algorithm examples
##
## Author: Martin Sielfeld
## Last editor: Martin Sielfeld
##
## Created: 2024/09/12
## Last edition: 2024/09/12
##
## Source: Datos Abiertos MINEDUC
##
#####################################################################

## Settings:
rm(list = ls())
options(scipen = 999)

## Install and load packages:
packages <- c("data.table","ggplot2","stringr","scales","SyncRNG")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)){install.packages(new_packages)}
sapply(packages,require,character.only=T,quietly=T)

## Functions:
specify_decimal <- function(x, k) trimws(format(round(x, k), nsmall=k))

## Load data:
{
  ## Inputs
  applications = fread('data/example_3/applications_r.csv')
  
  ## Results
  res_bos_py_v1 = fread('data/example_3/results_boston_py_v1.csv')
  res_bos_r_v1 = fread('data/example_3/results_boston_r_v1.csv')
  res_da_py_v1 = fread('data/example_3/results_da_py_v1.csv')
  res_da_r_v1 = fread('data/example_3/results_da_r_v1.csv')
  res_bos_py_v2 = fread('data/example_3/results_boston_py_v2.csv')
  res_bos_r_v2 = fread('data/example_3/results_boston_r_v2.csv')
  res_da_py_v2 = fread('data/example_3/results_da_py_v2.csv')
  res_da_r_v2 = fread('data/example_3/results_da_r_v2.csv')
  
  ## Cutoffs:
  cut_bos_py_v1 = fread('data/example_3/cutoffs_boston_py_v1.csv')
  cut_bos_r_v1 = fread('data/example_3/cutoffs_boston_r_v1.csv')
  cut_da_py_v1 = fread('data/example_3/cutoffs_da_py_v1.csv')
  cut_da_r_v1 = fread('data/example_3/cutoffs_da_r_v1.csv')
  cut_bos_py_v2 = fread('data/example_3/cutoffs_boston_py_v2.csv')
  cut_bos_r_v2 = fread('data/example_3/cutoffs_boston_r_v2.csv')
  cut_da_py_v2 = fread('data/example_3/cutoffs_da_py_v2.csv')
  cut_da_r_v2 = fread('data/example_3/cutoffs_da_r_v2.csv')
}

## Get length:
{
  maxl = max(str_length(c(res_bos_py_v1$score,res_bos_py_v2$score,res_bos_r_v1$score,res_bos_r_v2$score,
                          res_da_py_v1$score,res_da_py_v2$score,res_da_r_v1$score,res_da_r_v2$score)))
}

## Check if results in R are the same as in Python:
{
  ## Boston basic - r vs python:
  res_bos_py_v1 = res_bos_py_v1[order(iter,program_id,quota_id,-score)]
  res_bos_r_v1 = res_bos_r_v1[order(iter,program_id,quota_id,-score)]
  data_boston_v1 = rbind(res_bos_py_v1,res_bos_r_v1)
  data_boston_v1[,score := specify_decimal(score,maxl)]
  nrow(unique(data_boston_v1)) == nrow(res_bos_py_v1)
  
  ## DA basic - r vs python:
  res_da_py_v1 = res_da_py_v1[order(iter,program_id,quota_id,-score)]
  res_da_r_v1 = res_da_r_v1[order(iter,program_id,quota_id,-score)]
  data_da_v1 = rbind(res_da_py_v1,res_da_r_v1)
  data_da_v1[,score := specify_decimal(score,maxl)]
  nrow(unique(data_da_v1)) == nrow(res_da_py_v1)
  
  ## Boston basic - r vs python:
  res_bos_py_v2 = res_bos_py_v2[order(iter,program_id,quota_id,-score)]
  res_bos_r_v2 = res_bos_r_v2[order(iter,program_id,quota_id,-score)]
  data_boston_v2 = rbind(res_bos_py_v2,res_bos_r_v2)
  data_boston_v2[,score := specify_decimal(score,maxl)]
  nrow(unique(data_boston_v2)) == nrow(res_bos_py_v2)
  
  ## DA basic - r vs python:
  res_da_py_v2 = res_da_py_v2[order(iter,program_id,quota_id,-score)]
  res_da_r_v2 = res_da_r_v2[order(iter,program_id,quota_id,-score)]
  data_da_v2 = rbind(res_da_py_v2,res_da_r_v2)
  data_da_v2[,score := specify_decimal(score,maxl)]
  nrow(unique(data_da_v2)) == nrow(res_da_py_v2)
  
  ## Clean:
  rm(data_boston_v1,data_boston_v2,data_da_v1,data_da_v2)
}

## Check if cutoffs in R are the same as in Python:
{
  ## Boston basic - r vs python:
  cut_bos_py_v1 = cut_bos_py_v1[order(iter,program_id,quota_id)]
  cut_bos_r_v1 = cut_bos_r_v1[order(iter,program_id,quota_id)]
  data_boston_v1 = rbind(cut_bos_py_v1,cut_bos_r_v1)
  data_boston_v1[,lower_cutoff := specify_decimal(lower_cutoff,maxl)]
  data_boston_v1[,upper_cutoff := specify_decimal(upper_cutoff,maxl)]
  nrow(unique(data_boston_v1)) == nrow(cut_bos_py_v1)
  
  ## DA basic - r vs python:
  cut_da_py_v1 = cut_da_py_v1[order(iter,program_id,quota_id)]
  cut_da_r_v1 = cut_da_r_v1[order(iter,program_id,quota_id)]
  data_da_v1 = rbind(cut_da_py_v1,cut_da_r_v1)
  data_da_v1[,lower_cutoff := specify_decimal(lower_cutoff,maxl)]
  data_da_v1[,upper_cutoff := specify_decimal(upper_cutoff,maxl)]
  nrow(unique(data_da_v1)) == nrow(cut_da_py_v1)
  
  ## Boston basic - r vs python:
  cut_bos_py_v2 = cut_bos_py_v2[order(iter,program_id)]
  cut_bos_r_v2 = cut_bos_r_v2[order(iter,program_id)]
  data_boston_v2 = rbind(cut_bos_py_v2,cut_bos_r_v2)
  data_boston_v2[,lower_cutoff := specify_decimal(lower_cutoff,maxl)]
  data_boston_v2[,upper_cutoff := specify_decimal(upper_cutoff,maxl)]
  nrow(unique(data_boston_v2)) == nrow(cut_bos_py_v2)
  
  ## DA basic - r vs python:
  cut_da_py_v2 = cut_da_py_v2[order(iter,program_id)]
  cut_da_r_v2 = cut_da_r_v2[order(iter,program_id)]
  data_da_v2 = rbind(cut_da_py_v2,cut_da_r_v2)
  data_da_v2[,lower_cutoff := specify_decimal(lower_cutoff,maxl)]
  data_da_v2[,upper_cutoff := specify_decimal(upper_cutoff,maxl)]
  nrow(unique(data_da_v2)) == nrow(cut_da_py_v2)
  
  ## Clean:
  rm(data_boston_v1,data_boston_v2,data_da_v1,data_da_v2)
}

## Total assignment:
{
  data1 = rbind(res_bos_r_v1[,.(alg='Boston',cat='Hard quotas',assigned=.N),by=.(iter)],
                res_bos_r_v2[,.(alg='Boston',cat='Soft quotas',assigned=.N),by=.(iter)],
                res_da_r_v1[,.(alg='Deferred Acceptance',cat='Hard quotas',assigned=.N),by=.(iter)],
                res_da_r_v2[,.(alg='Deferred Acceptance',cat='Soft quotas',assigned=.N),by=.(iter)])
  
  ggplot(data1,aes(x=assigned,color=cat)) +
    geom_density() +
    facet_wrap(~alg) +
    scale_x_continuous(n.breaks = 10) +
    theme_bw() +
    labs(x='Total assigned',y=NULL,fill=NULL) +
    theme(legend.position = 'bottom')
  
  data2 = rbind(res_bos_r_v1[,.(alg='Boston',cat='Hard quotas',assigned=.N),by=.(iter,ranking)],
                res_bos_r_v2[,.(alg='Boston',cat='Soft quotas',assigned=.N),by=.(iter,ranking)],
                res_da_r_v1[,.(alg='Deferred Acceptance',cat='Hard quotas',assigned=.N),by=.(iter,ranking)],
                res_da_r_v2[,.(alg='Deferred Acceptance',cat='Soft quotas',assigned=.N),by=.(iter,ranking)])
  data2 = data2[,.(mean=mean(assigned),sd=sd(assigned),N=.N),by=.(alg,cat,ranking)]
  data2[,inter := qt(p=0.05/2, df=N-1,lower.tail=F) * sd/sqrt(N)]
  data2[,max := mean + inter]
  data2[,min := mean - inter]
  
  ggplot(data2) +
    geom_col(mapping=aes(x=factor(ranking),y=mean,fill=cat),position = position_dodge()) +
    geom_errorbar(mapping=aes(x=factor(ranking),ymin=min,ymax=max,group=interaction(cat,ranking)),
                  position = position_dodge()) +
    facet_wrap(~alg) +
    scale_y_continuous(n.breaks = 10) +
    theme_bw() +
    labs(x='Ranking',y='Assigned',fill=NULL) +
    theme(legend.position = 'bottom')
}

## Cutoff plot:
{
  View(cut_da_r_v2[not_filled==F,.(sd=sd(upper_cutoff)),by=.(program_id)])
  View(cut_bos_r_v2[not_filled==F,.(sd=sd(upper_cutoff)),by=.(program_id)])
  
  plot01 = 
    ggplot(cut_da_r_v2[program_id == 350,], aes(x = upper_cutoff)) +
    geom_step(aes(y=..y..),stat="ecdf", color = 'purple',size=1) +
    scale_y_continuous(labels = number_format(scale = 100, suffix = '%'),n.breaks = 11) +
    scale_x_continuous(n.breaks = 7) +
    theme_minimal() +
    theme(plot.title.position = 'plot') +
    labs(
      title = "Cuttof Cumulative Distribution Function",
      subtitle = 'Program 350',
      x = "Cutoff distribution",
      y = "Cumulative Probability")
  
  plot01
  
  ggsave(plot=plot01,filename='figures/cutoff_cumdens_da_example.png',
         dpi=300,height=4,width=6)
  
  plot02 = 
    ggplot(cut_bos_r_v2[program_id == 29,], aes(x = upper_cutoff)) +
    geom_step(aes(y=..y..),stat="ecdf", color = 'purple',size=1) +
    scale_y_continuous(labels = number_format(scale = 100, suffix = '%'),n.breaks = 11) +
    scale_x_continuous(n.breaks = 7) +
    theme_minimal() +
    theme(plot.title.position = 'plot') +
    labs(
      title = "Cuttof Cumulative Distribution Function",
      subtitle = 'Program 29',
      x = "Cutoff distribution",
      y = "Cumulative Probability")
  
  plot02
  
  ggsave(plot=plot02,filename='figures/cutoff_cumdens_boston_example.png',
         dpi=300,height=4,width=6)
}


