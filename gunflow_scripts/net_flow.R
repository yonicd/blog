this_net_flow <- net_flow%>%filter(year==2016)

this_net_flow$state <- factor(this_net_flow$state,levels = this_net_flow$state)

idx1 <- which(this_net_flow$state==c(thisstate))

this_net_flow$chosen <- ifelse(this_net_flow$state==thisstate,'State Selected','State Not Selected')

this_net_plot <- ggplot2::ggplot(this_net_flow,
                                 ggplot2::aes(x=state,y=ratio_net,
                                              fill=cut(ratio_net,
                                                       breaks = 10,
                                                       include.lowest = TRUE)))+
  ggplot2::geom_bar(stat='identity')+
  scale_fill_brewer(palette = "RdYlBu",direction = -1,name=NULL)+
  theme_minimal(base_size = plot_size)+
  labs(title='Net Firearm Flow per 100 Firearms Between States',
       subtitle='High is Net Exporter, Low is Net Importer',
       caption = "Source: Bureau of Alcohol, Firearms and Explosives (2016)",
       y='Net Ratio per 100 Firearms',x='State')+
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle=90),legend.position = 'bottom')

this_net_plot +
  geom_segment(x= idx1, 
               xend=idx1,
               y=ceiling(max(this_net_flow$ratio_net))+5,
               yend=pmax(0,this_net_flow$ratio_net[idx1]), 
               arrow = arrow(length = unit(0.5, "cm")))