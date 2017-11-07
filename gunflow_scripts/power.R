this_net_dat <- network_dat[[6]]

this_net_dat$alpha_pow$chosen <- as.numeric((this_net_dat$alpha_pow$state==thisstate))

this_net_dat$alpha_pow%>%
  ggplot(aes(x=neg,y=pos,label=state,fill=Division))+
  geom_hline(yintercept = 0,linetype=2) + 
  geom_vline(xintercept = 0,linetype=2) + 
  ggrepel::geom_label_repel()+theme_minimal(base_size = plot_size)+
  geom_point(aes(size=chosen),show.legend = FALSE,data=this_net_dat$alpha_pow) +
  scale_y_continuous(limits = c(-4,4)) +
  scale_x_continuous(limits = c(-4,4)) + 
  labs(x='(<== WEAKER | STRONGER ==>)\nLevel of Antagonistic Relations',
       y='Level of Cooperative Relations\n(<== STRONGER | WEAKER ==>)',
       title = "State Power Centrality of Interstate Firearms Directed Graph",
       subtitle=paste(c("Cooperative Relations: If ego has neighbors who have many connections to others,",
                        "making ego more powerful, because it has the 'right' connections.",
                        "\nAntagonistic Relations: If ego has weak neighbors it increases the ego centrality power"),
                      collapse='\n'),
       caption = sprintf("Source: Bureau of Alcohol, Firearms and Explosives (2016)"))