library(RSelenium)
library(XML)
library(ggplot2)
library(plyr)
library(dplyr)

gh_user <- 'yonicd'
gh_pass <- 'sidi6557'

gh_team <- 'metrumresearchgroup'
repos <- c('ggedit','slickR','sinew','d3Tree','texPreview','shinyCanvas','jsTree')

github_traffic <- function(gh_user,gh_pass,gh_team,repos){

rD <- rsDriver(verbose = FALSE)
remDr <- rD[["client"]]

remDr$navigate(sprintf('https://github.com/%s/%s/graphs/traffic',gh_team,repos[1]))
webElem <- remDr$findElement(using = 'id', value = "login_field")
webElem$setElementAttribute(attributeName = 'value',value = gh_user)
webElem <- remDr$findElement(using = 'id', value = "password")
webElem$setElementAttribute(attributeName = 'value',value = gh_pass)
webElem=remDr$findElement(using = 'xpath','//*[@id="login"]/form/div[4]/input[3]')
webElem$clickElement()
Sys.sleep(1)

out <- plyr::llply(repos,function(repo){
  remDr$navigate(sprintf('https://github.com/%s/%s/graphs/traffic',gh_team,repo))
  Sys.sleep(1)
  out <- XML::htmlParse(remDr$getPageSource(),asText = TRUE)
  sapply(c('clones','visitors'),function(type){
  XML::getNodeSet(out,sprintf(sprintf('//*[@id="js-%s-graph"]/div/div[1]/svg/g/g',type)))
},simplify = FALSE,USE.NAMES = TRUE)
},.progress = 'text')

names(out) <- repos

remDr$close()
rD[["server"]]$stop()

plot_data <- plyr::ldply(out,function(repo){
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


plot_data
}

# rD <- rsDriver(verbose = FALSE,port=4444L)
# remDr <- rD$client
# remDr$close()

plot_data <- github_traffic(gh_user=gh_user,
                               gh_pass=gh_pass,
                               gh_team=gh_team,
                               repos=repos)

saveRDS(plot_data,file = sprintf('~/projects/yonicd.github.io/github_traffic/data/%s_gh_traffic.rds',format(Sys.time(),format = '%Y%m%d_%H%M')))

p <- ggplot(plot_data,aes(x=date,y=value,colour=repo))+
  geom_line()+geom_point()+
  facet_grid(type~metric,scales='free_y')+
  scale_x_date(date_breaks = "1 day",date_labels = "%m/%d")+
  theme_bw()+
  theme(axis.text.x = element_text(angle=90),legend.position = 'top')+
  labs(title=sprintf('Github Team: %s | %s',gh_team, Sys.time()))

htmlwidgets::saveWidget(plotly::ggplotly(p),file = '~/projects/yonicd.github.io/github_traffic/github_traffic.html',selfcontained = TRUE)

thiswd <- getwd()
setwd('~/projects/blog')

system('git add github_traffic')
system('git commit -m "update traffic"')
system('git push origin master')

setwd(thiswd)
