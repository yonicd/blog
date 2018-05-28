fetch_view_type <- function(owner,repo,type,gh_pat){
  
  this_dat <- gh::gh('/repos/:owner/:repo/traffic/:type',
                     owner  = owner,
                     repo   = repo,
                     type   = type,
                     .token = gh_pat)
  
  
  if(length(this_dat[[type]])==0)
    return(NULL)
  
  ret <- this_dat[[type]]%>%
    purrr::transpose()%>%
    dplyr::as_tibble()%>%
    dplyr::mutate(
      timestamp = as.Date(gsub('T(.*?)$','',purrr::flatten_chr(timestamp))),
      count  = purrr::flatten_dbl(count),
      uniques  = purrr::flatten_dbl(uniques),
      repo = repo
    )
  
  ret
}

fetch_view_data <- function(repo, gh_pat){
  
  types <- dplyr::data_frame(type = c('views','clones'))

  ret <- purrr::map_df(types$type,
                       fetch_view_type,
                       gh_pat = gh_pat,
                       owner  = dirname(repo),
                       repo   = basename(repo),
                       .id    = 'type')
  
  ret$type <- factor(ret$type,
                     labels = c('views','clones')[1:max(ret$type)])
  
  return(ret)
}

plot_traffic <- function(dat){
  dat %>%
    tidyr::gather(key = 'stat',value='value',count,uniques)%>%
    ggplot(aes(x=timestamp,
               y=repo,
               fill=value))+
    geom_tile(colour='white',width=.95,alpha=0.75)+
    geom_hline(yintercept = c(0,(1:length(unique(dat$repo)))+0.5),colour='grey90')+
    scale_fill_viridis(name='Count',direction = -1)+
    facet_grid(.~stat) +
    theme_minimal()+
    theme(panel.grid.major  = element_blank(),
          axis.text.x = element_text(angle=90),
          panel.grid.minor = element_blank(),
          axis.title = element_blank())
}

library(magrittr)

yonicd_repos <- vcs::list_repos(user = 'yonicd')%>%purrr::flatten_chr()
metrum_repos <- vcs::list_repos(user = 'metrumresearchgroup')%>%purrr::flatten_chr()
metrum_repos <- metrum_repos[c(1:8,10)]

x <- c(yonicd_repos,metrum_repos)%>%
  purrr::map_df(fetch_view_data, 
              gh_pat = Sys.getenv('GITHUB_PAT'))

svglite(file.path(getwd(),'public/img/github_traffic.svg'),standalone = TRUE)
plot_traffic(x)
dev.off()

system('git add public')
system('git add github_traffic')
system('git commit -m "update traffic"')
system('git push origin master')
