shinyServer(function(input, output) {
  
  dados_select <- eventReactive(input$idExecuta,{
    
    print(input$idOpcionais)
    
    resultado <- dados %>% 
      filter(MODELO == input$idModelos & 
               UF %in% input$idUf)
    
    for (c in input$idOpcionais) {
      resultado <- resultado %>%
        filter_at(vars(c), all_vars(. == 1))
    }
    resultado
    
  },ignoreNULL = F)
  
  output$teste <- renderText({
    paste('DADOS:', nrow(dados_select())) 
  })
  
  output$grafico_media_valores <- renderPlotly({
    ## VALOR MÉDIO AO LONGO TEMPO
    media_data <- dados_select() %>%
      group_by(DATA_COLETA_METADADOS,UF) %>%
      summarise(mediaValor = mean(VALOR),.groups = 'drop')
    
    ggplotly(
      media_data %>%
        ggplot() +
        geom_line(aes(x = DATA_COLETA_METADADOS, y = mediaValor,
                      group = UF, color = UF),
                  size = 1) + ggtitle("Média de preço por dia - Linha") +
        scale_color_brewer(palette = 'Dark2')
    )
  })
  
  output$grafico_boxplot_preco <- renderPlotly({
    ggplotly(
      dados_select() %>%
        ggplot() + 
        geom_boxplot(aes(x = UF, y = VALOR, fill = UF))+
        ggtitle('Mín, Máx e Média - Boxplot')+
        theme(legend.position = 'none') +
        scale_fill_brewer(palette = 'Dark2')
    )
  })
  
  output$grafico_km_valor <- renderPlotly({
    ggplotly( dados_select() %>% 
                ggplot()+
                geom_point(aes(x = QUILOMETRAGEM, y = VALOR,color = UF) )+
                ggtitle("Distribuição do preço e KM por estado - Scatterplot")+
                scale_color_brewer(palette="Dark2")
    )
  })
  
  # Criando a tabela de resumo de preços
  output$grafico_tabela_preco <- renderTable({
    summary_data <- dados_select() %>%
      group_by(VALOR) %>%
        summarise(media = mean(VALOR),
                  mediana = median(VALOR),
                  moda = mode(VALOR),
                  desvio_padrao = sd(VALOR),
                  minimo = min(VALOR),
                  maximo = max(VALOR))
    summary_data
  
    layout(title = 'Estatísticas')

  })
  
  output$grafico_pie_direcao <- renderPlotly({
    freq_direcao <- dados_select() %>% 
      group_by(DIREÇÃO) %>%
      summarise(qtd = n()) %>%
      mutate(prop = qtd / sum(qtd) *100) %>%
      mutate(ypos = cumsum(prop)- 0.5*prop )
    
    plot_ly(freq_direcao, labels = ~DIREÇÃO, values = ~prop  , type = 'pie',
            textinfo = 'label+percent',showlegend = FALSE) %>%
      layout(title = 'Quantidade por Direção')
  })
  
  output$grafico_bar_cor <- renderPlotly({ggplotly(
    dados_select() %>%
      group_by(COR) %>%
      summarise(QTD = n() ) %>%
      ggplot() +
      geom_bar(aes(x = reorder(COR,QTD ),y = QTD,fill=QTD),stat = 'identity' )+
      ggtitle("Quantidade por Cor - Histograma") + xlab('COR')
  )
  })
  
})
