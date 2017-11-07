this_tot <- tot%>%filter(year==2016)

this_tot$chosen=as.numeric((this_tot$state==thisstate))  

this_tot%>%
  ggplot(aes(x=from_pct,y=to_pct,fill=cut(within_pct,5,include.lowest = TRUE)))+
  ggrepel::geom_label_repel(aes(label=state_grade),alpha=.7)+
  scale_fill_brewer(palette = "RdYlBu",direction = -1,name='Internal Rate')+
  geom_point(aes(size=chosen),show.legend = FALSE,data=this_tot)+
  theme_minimal(base_size = plot_size)+
  labs(title='Inflow, Outflow and Internal Firearms Rate per 100',
       subtitle='Label Attributes: Higher grades reflect stricter gunlaws, * reflects state with background checks',
       caption = "Sources: Bureau of Alcohol, Firearms and Explosives (2016)\n Law Center To Prevent Gun Violence",
       x='Outflow Rate',y='Inflow Rate')