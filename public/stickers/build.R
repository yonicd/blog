hexbin <- vcs::ls_remote('maxogden/hexbin',branch = 'gh-pages',subdir = 'hexagons',full.names = TRUE)

hexbin_names <- tools::file_path_sans_ext(basename(hexbin))
hexbin_names <- gsub('^CodeFor','',hexbin_names)

RS <- vcs::ls_remote('rstudio/hex-stickers',subdir = 'PNG',full.names = TRUE)[-c(2,3)]
RS_names <- tools::file_path_sans_ext(basename(RS))

thinkr <- vcs::ls_remote('ThinkR-open/visuals',subdir = 'hexes',full.names = TRUE)
thinkr_names <- tools::file_path_sans_ext(basename(thinkr))
thinkr_names <- gsub('^(.*?)hex-','',thinkr_names)

me <- vcs::ls_remote('yonicd/hex',subdir = 'images/logos',full.names = TRUE)
me_names <- tools::file_path_sans_ext(basename(me))

x <- c(me,thinkr,RS,hexbin)
x_names <- c(me_names,thinkr_names,RS_names,hexbin_names)

library(slickR)

p <- lapply(slick_div(x,links = x,css = htmltools::css(marginLeft='auto',marginRight='auto',height = '100px')),function(x) {
  names(x$children[[1]]$attribs)[1] <- 'data-lazy' 
  x
})


p1 <- slickR::slickR(p) + 
  slickR::settings(slidesToShow = 5,lazyLoad = 'ondemand',slidesToScroll = 5,centerMode = FALSE,autoplay = TRUE,autoplaySpeed = 3000)

p2 <- slickR::slickR(x_names,slideType = 'p') + slickR::settings(slidesToShow = 5,arrows = FALSE,slidesToScroll = 5,centerMode = FALSE,autoplay = TRUE,autoplaySpeed = 3000)

stickers <- p1 %synch% p2

htmlwidgets::saveWidget(stickers,file = 'index.html',selfcontained = FALSE,libdir = 'assets')
