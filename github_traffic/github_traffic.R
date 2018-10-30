pkgs <- c("viridis","svglite","dplyr","purrr","ggplot2","gh","tidyr")
x    <- setdiff(pkgs,rownames(installed.packages()))
if(length(x)>0) 
  install.packages(x)

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
                       .id    = 'type')%>%
    dplyr::mutate(type = dplyr::case_when(
      type==1~'views',
      type==2~'clones'
        ))

  return(ret)
}

plot_traffic <- function(dat){
  dat %>%
    tidyr::gather(key = 'stat',value='value',count,uniques)%>%
    ggplot2::ggplot(ggplot2::aes(x=timestamp,
               y=repo,
               fill=value))+
    ggplot2::geom_tile(colour='white',width=.95,alpha=0.75)+
    ggplot2::geom_hline(yintercept = c(0,(1:length(unique(dat$repo)))+0.5),colour='grey90')+
    viridis::scale_fill_viridis(name='Count',direction = -1)+
    ggplot2::facet_grid(.~stat) +
    ggplot2::theme_minimal()+
    ggplot2::theme(panel.grid.major  = ggplot2::element_blank(),
          axis.text.x = ggplot2::element_text(angle=90),
          panel.grid.minor = ggplot2::element_blank(),
          axis.title = ggplot2::element_blank())
}

repos <- c(
  'yonicd/carbonate',
  'yonicd/noplyr',
  'yonicd/shinyHeatmaply',
  'yonicd/Elections',
  'yonicd/covrpage',
  'yonicd/rpdf',
  'yonicd/rsam',
  'yonicd/regexSelect',
  'yonicd/tidycheckUsage',
  'yonicd/ripe',
  'yonicd/lmmen',
  'metrumresearchgroup/ggedit',
  'metrumresearchgroup/sinew',
  'metrumresearchgroup/slickR',
  'metrumresearchgroup/d3Tree',
  'metrumresearchgroup/texPreview',
  'metrumresearchgroup/jsTree',
  'metrumresearchgroup/shinyCanvas',
  'metrumresearchgroup/vcs'  
)

x <- repos%>%
  purrr::map_df(fetch_view_data, 
              gh_pat = Sys.getenv('GITHUB_PAT'))

svglite::svglite(file.path(getwd(),'public/img/github_traffic.svg'),standalone = TRUE)
  plot_traffic(x)
dev.off()

# system('git add public')
# system('git add github_traffic')
# system('git commit -m "update traffic [skip ci]"')
# system('git push origin master')
# 
