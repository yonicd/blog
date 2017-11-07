thisstate <- 'Connecticut'

this_atf <- atf_data

# removed for scaling (Wyoming has 30 firearms per 100 persons in 2016)
if(thisstate!='Wyoming') 
  this_atf <- this_atf%>%filter(state!='Wyoming')

this_atf$chosen <- this_atf$state==thisstate

atf_marginal <- this_atf%>%
  filter(year==2016)%>%
  filter(rate>3|state==thisstate)%>%
  mutate(chosen=state==thisstate)

this_atf%>% 
  ggplot(aes(x=year,y=rate,group=state.abb))+
  geom_line()+
  ggrepel::geom_label_repel(aes(label=state.abb,fill=chosen),
                            data=atf_marginal,
                            show.legend = FALSE,
                            segment.alpha = .3,
                            segment.colour = 'blue')+
  facet_wrap(~Division)+
  scale_x_continuous(breaks=2010:2016,labels = 10:16,limits = c(2010,2017))+
  theme_minimal()+
  labs(title = 'Rate of Firearm Registration Per 100 individuals (age>17)',
       subtitle = 'Label indicates states in 2016 with rate above 3 Firearms per 100 (Blue is selected state)',
       caption = 'Source: Bureau of Alcohol, Firearms and Explosives',
       x = 'Year',
       y = 'Rate per 100 Individuals (age>17)')

atf_marginal <- atf_data%>%
  filter(year==2016)%>%
  filter(base_rate>1|state==thisstate)%>%
  mutate(chosen=state==thisstate)

atf_data%>%
  ggplot(aes(x=year,y=base_rate,group=state.abb))+
  geom_line()+
  geom_point(data=atf_marginal)+
  ggrepel::geom_label_repel(aes(label=state.abb,fill=chosen),
                            data=atf_marginal,
                            show.legend = FALSE,
                            segment.alpha = .3,
                            segment.colour = 'blue')+
  facet_wrap(~Division)+
  scale_x_continuous(breaks=2010:2016,limits = c(2010,2017))+
  theme_minimal()+
  labs(title = 'Rate of Firearm Registration Per 100 individuals (age>17,Base year 2010)',
       subtitle = 'Label indicates states in 2016 with rate of change above 100% (Blue is selected state)',
       caption = 'Source: Bureau of Alcohol, Firearms and Explosives',
       x = 'Year',
       y = 'Rate of Change (Base year 2010)')
