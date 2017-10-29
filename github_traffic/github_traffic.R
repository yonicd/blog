library(RSelenium)
library(viridis)
library(XML)
library(ggplot2)
library(plyr)
library(dplyr)

gh_user <- 'yonicd'
gh_pass <- 'sidi6557'


repos <- c('shinyHeatmaply','regexSelect','rpdf','gunflow','lmmen',
           'ggedit','slickR','sinew','d3Tree','texPreview','shinyCanvas','jsTree')
gh_team <- rep(c('yonicd','metrumresearchgroup'),c(5,7))

repos <- file.path(gh_team,repos)

github_traffic <- function(gh_user,gh_pass,repos){

rD <- rsDriver(verbose = FALSE)
remDr <- rD[["client"]]

remDr$navigate(sprintf('https://github.com/%s/graphs/traffic',repos[1]))
webElem <- remDr$findElement(using = 'id', value = "login_field")
webElem$setElementAttribute(attributeName = 'value',value = gh_user)
webElem <- remDr$findElement(using = 'id', value = "password")
webElem$setElementAttribute(attributeName = 'value',value = gh_pass)
webElem=remDr$findElement(using = 'xpath','//*[@id="login"]/form/div[4]/input[3]')
webElem$clickElement()
Sys.sleep(1)

out <- plyr::llply(repos,function(repo){
  remDr$navigate(sprintf('https://github.com/%s/graphs/traffic',repo))
  Sys.sleep(1)
  out <- XML::htmlParse(remDr$getPageSource(),asText = TRUE)
  sapply(c('clones','visitors'),function(type){
  XML::getNodeSet(out,sprintf(sprintf('//*[@id="js-%s-graph"]/div/div[1]/svg/g/g',type)))
},simplify = FALSE,USE.NAMES = TRUE)
},.progress = 'text')

names(out) <- repos

remDr$close()
rD[["server"]]$stop()

return(out)
}

plot_data_html <- github_traffic(gh_user=gh_user,
                            gh_pass=gh_pass,
                            repos=repos)

plot_data <- plyr::ldply(plot_data_html,function(repo){
  plyr::mdply(names(repo),function(type){
    
    dat <- repo[[type]]
  
    if(is.null(dat)) return(NULL)
    
    yticks_total <- as.numeric(sapply(getNodeSet(dat[[2]],'g'),XML::xmlValue))
    yticks_unique <- as.numeric(sapply(getNodeSet(dat[[5]],'g'),XML::xmlValue))
    
    x <- data.frame(type=type,
                    date = as.Date(sapply(getNodeSet(dat[[1]],'g'),XML::xmlValue),format = '%m/%d'),
                    total = as.numeric(sapply(getNodeSet(dat[[3]],'circle'),XML::xmlGetAttr,name = 'cy')),
                    unique = as.numeric(sapply(getNodeSet(dat[[4]],'circle'),XML::xmlGetAttr,name = 'cy')))
    
    x$total <- scales::rescale(x$total,rev(range(yticks_total)))
    x$unique <- scales::rescale(x$unique,rev(range(yticks_unique)))
    
    x%>%reshape2::melt(.,c('type','date'),variable.name=c('metric'))
  })
},.id='repo')%>%select(-X1)


# rD <- rsDriver(verbose = FALSE,port=4444L)
# remDr <- rD$client
# remDr$close()

thiswd <- getwd()
setwd('~/projects/blog')

saveRDS(plot_data,file = sprintf('github_traffic/data/%s_gh_traffic.rds',format(Sys.time(),format = '%Y%m%d_%H%M')))

myfile <- list.files('github_traffic/data',full.names = TRUE)

plot_data_df <- plyr::mdply(myfile,readRDS)
levels(plot_data_df$X1) <- gsub('_gh(.*?)$','',basename(myfile))
names(plot_data_df)[1] <- 'fetch_date'

plot_data_df <- plot_data_df%>%
  group_by(repo,type,date,metric)%>%
  do(.,tail(.,1))%>%
  ungroup()%>%
  mutate(repo=gsub('^(.*?)/','',repo),
         val=ceiling(value))

p <- plot_data_df%>%
  ggplot(aes(x=date,
             y=repo,
             fill=val))+
  geom_tile(colour='white',width=.95)+
  geom_hline(yintercept = c(0,(1:length(repos))+0.5),colour='grey90')+
  scale_fill_viridis(name='Count')+
  facet_grid(type~metric)+
  scale_x_date(date_breaks = "1 day",date_labels = "%m/%d")+
  theme_minimal()+
  labs(title=sprintf('Github Team: %s | %s',
                     paste0(unique(gh_team),collapse = ','), 
                     Sys.time()))+
  theme(panel.grid.major  = element_blank(),
        axis.text.x = element_text(angle=90),
        panel.grid.minor = element_blank(),
        axis.title = element_blank())

htmlwidgets::saveWidget(plotly::ggplotly(p),file = '~/projects/yonicd.github.io/github_traffic/github_traffic.html',selfcontained = TRUE)

system('git add github_traffic')
system('git commit -m "update traffic"')
system('git push origin master')

setwd(thiswd)
