library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)
library(shinydashboard)

dados <- read.csv("dados_shiny_2022081822.csv")

options(warn = -1)

View(dados %>% filter(DATA_COLETA_METADADOS == max(dados$DATA_COLETA_METADADOS))
)
