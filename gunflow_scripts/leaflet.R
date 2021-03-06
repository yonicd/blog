input <- list(
  year=2016,
  thisstate = 'Connecticut',
  type = 'Inflow',
  scale = 'State'
)

gun_mat1 <- switch(input$type,
                   Inflow={
                     gun_mat%>%
                       dplyr::filter(year==input$year)%>%
                       dplyr::group_by(to)%>%
                       dplyr::mutate(value1=ifelse(to==from,NA,value),pct=100*value1/sum(value1,na.rm = TRUE))%>%
                       dplyr::filter(to==input$thisstate)%>%
                       dplyr::rename(state=from)       
                   },
                   Outflow={
                     gun_mat%>%
                       dplyr::filter(year==input$year)%>%
                       dplyr::group_by(from)%>%
                       dplyr::mutate(value1=ifelse(to==from,NA,value),pct=100*value1/sum(value1,na.rm = TRUE))%>%
                       dplyr::filter(from==input$thisstate)%>%
                       dplyr::rename(state=to)
                   })

mydata <- states@data   
mydata <- mydata%>%
  rename(state=name)%>%
  mutate(state=as.character(state))%>%
  left_join(gun_mat1%>%ungroup%>%select(state,value1,value,pct),by='state')

states@data$pct <- mydata$pct
states@data$level <- mydata$value1
states@data$value <- mydata$value
states@data$density <- NULL

df <- states

d <- switch(input$scale,
            National={
              seq(0,35)
            },
            State={
              df$pct
            })

pal <- colorNumeric(
  palette = "RdYlBu",
  domain = d,na.color = 'black',reverse = TRUE)

m <- leaflet(df) %>%
  setView(-96, 37.8, 4) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))


labels <- switch (input$type,
                  Inflow={
                    sprintf(
                      "Of the %s Out of State Firearms Recovered in <strong>%s</strong><br/>%g%% of them originating from <strong>%s</strong><br/>Total Firearms Recovered in <strong>%s</strong> : %s",
                      sum(df$level,na.rm = TRUE),
                      input$thisstate,
                      round(df$pct,2),
                      states$name,
                      input$thisstate,
                      sum(df$value,na.rm = TRUE)
                    )
                  },
                  Outflow={
                    sprintf(
                      'Of the %s Out of State Firearms Originating from <strong>%s</strong><br/>%g%% were Recovered in <strong>%s</strong><br/>Total Firearms Originating from <strong>%s</strong> : %s',
                      sum(df$level,na.rm = TRUE),
                      input$thisstate,
                      round(df$pct,2),
                      states$name,
                      input$thisstate,
                      sum(df$value,na.rm = TRUE)
                    ) 
                  }
)%>% lapply(htmltools::HTML)

leafout <- m %>% addPolygons(
  fillColor = ~pal(pct),
  weight = 2,
  smoothFactor = 0.2,
  stroke=FALSE,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,
  highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 1,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))%>% 
  addLegend(pal = pal, values = switch(input$scale,National=0:35,State=~pct), opacity = 0.7, title = 'Percent',
            position = "bottomright",na.label = 'Selected State') 