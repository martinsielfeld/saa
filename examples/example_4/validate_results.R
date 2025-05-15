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
## Source: Datos Abiertos MINEDUC - SAE 2020
##
#####################################################################

## Settings:
rm(list = ls())
options(scipen = 999)

## Set working directory:
if(Sys.info()["user"] == 'mds237'){
  mainFolder = 'C:/Users/mds237/Desktop/Yale/Codes/school-choice-assignment-algorithm'
} else if(Sys.info()["user"] == ''){ ## Add user
  mainFolder = '' ## Add folder to data folder
}

## Install and load packages:
packages <- c("data.table","stringr")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)){install.packages(new_packages)}
sapply(packages,require,character.only=T,quietly=T)

## Check example 1 iputs:
{
  ## Load:
  assignment_r = fread(paste0(mainFolder,'/data/example_4/results_official_r.csv'),integer64='numeric')
  assignment_py = fread(paste0(mainFolder,'/data/example_4/results_official_py.csv'),integer64='numeric')
  assignment_junji = fread(paste0(mainFolder,'/data/example_4/results_junji_2025.csv'),integer64='numeric')
  
  ## Filter:
  assignment_junji = assignment_junji[status == 'ListaPriorizados']
  
  ## Check programs:
  nrow(unique(rbind(assignment_junji[,.(applicant_id,program_id)],assignment_r[,.(applicant_id,program_id)]))) == nrow(assignment_r)
  nrow(unique(rbind(assignment_junji[,.(applicant_id,program_id)],assignment_py[,.(applicant_id,program_id)]))) == nrow(assignment_py)
  nrow(unique(rbind(assignment_r[,.(applicant_id,program_id)],assignment_py[,.(applicant_id,program_id)]))) == nrow(assignment_r)
  
  ## Check applications:
  nrow(unique(rbind(applications1_py,applications1_r))) == nrow(applications1_r)
  nrow(unique(rbind(applications1_py,applications1_r))) == nrow(applications1_py)
}