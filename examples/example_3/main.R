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

## Load function:
source('src/baseSAA.R',encoding='UTF-8')

## Load data:
{
  ## For algorithm:
  vacancies = fread('data/example_3/vacancies_r.csv')
  applications = fread('data/example_3/applications_r.csv')
}

## Prep data:
{
  ## Soft Boston:
  softBoston = applications[,.(applicant_id,grade_id,program_id,ranking,quota_id,
                               priority_profile=priority_profile_ori)]
  
  ## DA:
  baseDA = applications[,.(applicant_id,grade_id,program_id,ranking,quota_id,
                           priority_profile=priority_profile_edi)]
}

## Lets compare Soft Boston vs. DA assignment - no transfer:
{
  ## Soft Boston:
  results_1 = baseSAA(apps=softBoston,vacs=vacancies,get_cutoffs=T,transfer_capacity=F,
                      iters=100)
  
  ## DA:
  results_2 = baseSAA(apps=baseDA,vacs=vacancies,get_cutoffs=T,transfer_capacity=F,
                      iters=100)
  
  ## Soft Boston:
  results_3 = baseSAA(apps=softBoston,vacs=vacancies,get_cutoffs=T,transfer_capacity=T,
                      iters=100)
  
  ## DA:
  results_4 = baseSAA(apps=baseDA,vacs=vacancies,get_cutoffs=T,transfer_capacity=T,
                      iters=100)
}

## Export:
{
  ## Export results:
  fwrite(results_1$assignment,'data/example_3/results_boston_r_v1.csv')
  fwrite(results_2$assignment,'data/example_3/results_da_r_v1.csv')
  fwrite(results_3$assignment,'data/example_3/results_boston_r_v2.csv')
  fwrite(results_4$assignment,'data/example_3/results_da_r_v2.csv')
  
  ## Export cutoffs:
  fwrite(results_1$cutoffs,'data/example_3/cutoffs_boston_r_v1.csv')
  fwrite(results_2$cutoffs,'data/example_3/cutoffs_da_r_v1.csv')
  fwrite(results_3$cutoffs,'data/example_3/cutoffs_boston_r_v2.csv')
  fwrite(results_4$cutoffs,'data/example_3/cutoffs_da_r_v2.csv')
}
