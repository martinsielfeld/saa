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
options(scipen = 999,digits = 15)

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
  vacancies = fread('data/example_4/vacancies_junji_2025.csv')
  applications = fread('data/example_4/applications_junji_2025.csv',integer64 = 'numeric')
}

## Prep data:
{
  ## DA:
  baseDA = applications[,.(applicant_id,grade_id,program_id,ranking,quota_id,priority_profile=priority_profile,lottery_number)]
}

## Lets compare Soft Boston vs. DA assignment - no transfer:
{
  ## Official assignment:
  official = baseSAA(apps=baseDA,vacs=vacancies,get_cutoffs=T,transfer_capacity=F,iters=1)
  
  ## Simulations:
  simulations = baseSAA(apps=baseDA,vacs=vacancies,get_cutoffs=T,transfer_capacity=F,
                        iters=50,get_probs=T,get_assignment=F,rand_type='py&r')
}

## Export:
{
  ## Export results:
  fwrite(official$assignment,'data/example_4/results_official_r.csv')
  
  ## Export cutoffs:
  fwrite(official$cutoffs,'data/example_4/cutoffs_official_r.csv')
  fwrite(simulations$cutoffs,'data/example_4/cutoffs_simulations_r.csv')
  
  ## Export ratex:
  fwrite(simulations$ratex,'data/example_4/ratex_simulations_r.csv')
}
