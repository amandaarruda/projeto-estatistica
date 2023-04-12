source('util.R')

cabecalho <- dashboardHeader(title = 'Vendas de Carros')

barra_lateral <- dashboardSidebar()

corpo_pagina <- dashboardBody(
  fluidRow(
    infoBox(title = '',subtitle = 'Registros',
            value = nrow(dados),color = 'navy' ),
    
    infoBox(title = '',subtitle = 'Modelos',
            value = length(unique(dados$MODELO)),color = 'blue' ),
    
    infoBox(title = '',subtitle = 'Estados',
            value = length(unique(dados$UF)),color = 'purple' )
    
  ), # FIM LINHA BOXES INFORMATIVOS
  
  fluidRow(
    column(width = 12,
      # colunas: 1 a 12.
      box(width = '100%',
        column(width = 3,
               selectInput(inputId = "idModelos",label = "Modelo:",
                           choices = sort( unique(dados$MODELO) ),
                           selected = 'corolla xei 16v')
        ),
        column(width = 3,
               selectizeInput("idUf","Estados:", 
                              choices = sort( unique(dados$UF) ),
                              options = list(maxItems = 3),
                              selected = 'df'),),
        column(width = 3,
               sliderInput("idAno",
                           "Ano do automóvel:",
                           min = min(dados$ANO),
                           max = max(dados$ANO),
                           value = 2022,sep = "")),
        
        actionButton("idExecuta","Consultar",class = 'btn-success')
      )
    )
  ), 
  fluidRow(
    column(width = 12,
      box(width = '100%',
         column(width = 8, plotlyOutput("grafico_media_valores") ),
         column(width = 4, plotlyOutput("grafico_boxplot_preco") )
      )       
    )
  ), #FIM PRIMEIRA LINHA GRAFICOS
  fluidRow(
    column(width = 12,
     box(width = '100%',
         column(width = 8, plotlyOutput("grafico_km_valor") ),
         column(width = 4, plotlyOutput("grafico_tabela_preco") )
     ) 
    )
  ), # FIM SEGUNDA LINHA GRÁFICOS
  fluidRow(
    column(width = 12,
           box(width = '100%',
               column(width = 3,plotlyOutput("grafico_pie_direcao") ),
               column(width = 9,plotlyOutput("grafico_bar_cor") )
           ) 
    )
  )# FIM TERCEIRA LINHA GRÁFICOS
  
  
) # FIM DO DASHBOARDBODY

dashboardPage(header = cabecalho,
              sidebar = barra_lateral,
              body = corpo_pagina)
