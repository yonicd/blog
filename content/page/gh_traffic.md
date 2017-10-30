---
title: GitHub Waffle Heatmap
---

![](https://yonicd.netlify.com/img/github_traffic.svg)

# How we got this:

## Load libraries  
```r
library(RSelenium)
library(ggedit)
library(svglite)
library(viridis)
library(XML)
library(ggplot2)
library(plyr)
library(dplyr)
```

## Set GitHub Credentials
```r
gh_user <- 'github user'
gh_pass <- 'github pass'
```

## Define the GitHub repos
```r
gh_team <- rep(c('yonicd','metrumresearchgroup'),c(5,7))

repos <- c('shinyHeatmaply','regexSelect','rpdf','gunflow','lmmen',
           'ggedit','slickR','sinew','d3Tree','texPreview','shinyCanvas',
           'jsTree')

repos <- file.path(gh_team,repos)
```

## Retrieve data from GitHub traffic using RSelenium

```r
github_traffic <- function(gh_user,gh_pass,repos){

rD <- rsDriver(verbose = FALSE)
remDr <- rD[["client"]]

remDr$navigate(sprintf('https://github.com/%s/graphs/traffic',repos[1]))
webElem <- remDr$findElement(using = 'id', value = "login_field")
webElem$setElementAttribute(attributeName = 'value',value = gh_user)
webElem <- remDr$findElement(using = 'id', value = "password")
webElem$setElementAttribute(attributeName = 'value',value = gh_pass)
webElem=remDr$findElement(using = 'xpath',
'//*[@id="login"]/form/div[4]/input[3]')
webElem$clickElement()
Sys.sleep(1)

out <- plyr::llply(repos,function(repo){
  remDr$navigate(sprintf('https://github.com/%s/graphs/traffic',repo))
  Sys.sleep(1)
  out <- XML::htmlParse(remDr$getPageSource(),asText = TRUE)
  sapply(c('clones','visitors'),function(type){
  XML::getNodeSet(out,
  sprintf(sprintf('//*[@id="js-%s-graph"]/div/div[1]/svg/g/g',type)))
},simplify = FALSE,USE.NAMES = TRUE)
},.progress = 'text')

names(out) <- repos

remDr$close()
rD[["server"]]$stop()

return(out)
}
```

### Run the function
```r
plot_data_html <- github_traffic(gh_user=gh_user,
                            gh_pass=gh_pass,
                            repos=repos)
```

## Failsafe if Rselenium Crashes
```r
# rD <- rsDriver(verbose = FALSE,port=4444L)
# remDr <- rD$client
# remDr$close()
```

## Transform d3 scales to R scales
```r
plot_data <- plyr::ldply(plot_data_html,function(repo){
  plyr::mdply(names(repo),function(type){
    
    dat <- repo[[type]]
  
    if(is.null(dat)) return(NULL)
    
    yticks_total <- as.numeric(sapply(getNodeSet(dat[[2]],'g'),XML::xmlValue))
    y_mult_total <- as.numeric(gsub('[)]','',gsub('^(.*?),','',
    xmlAttrs(tail(getNodeSet(dat[[2]],'g'),1)[[1]])[2])))
    
    yticks_unique <- as.numeric(sapply(getNodeSet(dat[[5]],'g'),XML::xmlValue))
    y_mult_unique <- as.numeric(gsub('[)]','',gsub('^(.*?),','',
    xmlAttrs(tail(getNodeSet(dat[[5]],'g'),1)[[1]])[2])))
    
    
    x <- data.frame(type=type,
                    date = as.Date(sapply(getNodeSet(dat[[1]],'g'),XML::xmlValue),format = '%m/%d'),
                    total = as.numeric(sapply(getNodeSet(dat[[3]],'circle'),XML::xmlGetAttr,name = 'cy')),
                    unique = as.numeric(sapply(getNodeSet(dat[[4]],'circle'),XML::xmlGetAttr,name = 'cy')))

    x$total <- scales::rescale(x$total,
    rev(range(yticks_total))/((193-y_mult_total)/193))
    
    x$unique <- scales::rescale(x$unique,
    rev(range(yticks_unique))/((193-y_mult_unique)/193))
    
    x%>%reshape2::melt(.,c('type','date'),variable.name=c('metric'))
  })
},.id='repo')%>%select(-X1)
```

## Save file to disk as RDS
```r
saveRDS(plot_data,file = sprintf('github_traffic/data/%s_gh_traffic.rds',
                                 format(Sys.time(),format = '%Y%m%d_%H%M')))
```

## Read in all historical data
```r
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
```

## Create waffle heatmap

```r
plot_list <- plyr::dlply(plot_data_df,c('type'),.fun = function(dat){
 p <- dat%>%
    ggplot(aes(x=date,
               y=repo,
               fill=val))+
    geom_tile(colour='white',width=.95)+
    geom_hline(yintercept = c(0,(1:length(unique(dat$repo)))+0.5),colour='grey90')+
    scale_fill_viridis(name='Count')+
    facet_grid(.~metric)+
    # uncomment if you want every date on x-axis
    # scale_x_date(date_breaks = "1 day",date_labels = "%m/%d")+
    theme_minimal()+
    theme(panel.grid.major  = element_blank(),
          axis.text.x = element_text(angle=90),
          panel.grid.minor = element_blank(),
          axis.title = element_blank())
 
 if(dat$type[1] =='clones'){
   p <- p +
     labs(title=sprintf('GitHub Team: %s | %s',
     paste0(unique(dat$team),collapse = ','),Sys.time()),
          subtitle='Clones')
 }else{
   p <- p +
     labs(subtitle='Visitors')
 }
 
 p
})
```

## Save to disk
```r
pl <- ggedit::as.gglist(plot_list)
svglite(file.path(getwd(),'public/img/github_traffic.svg'),standalone = TRUE)
print(pl,plot.layout=list(list(rows=1,cols=1:2),list(rows=2,cols=1:2)))
dev.off()
```

![](https://yonicd.netlify.com/img/github_traffic.svg)
