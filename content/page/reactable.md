---
title: "GitHub Activity Reactable"
author: "Jonathan Sidi"
date: '2019-12-14'
output: 
  html_document:
    keep_md: true
---




 

 

```r
reactable::reactable(tbl_md, 
          pagination = FALSE, 
          highlight = TRUE, 
          height = 500,
          defaultSortOrder = "desc",
          defaultSorted = c("views"),
          rowStyle = function(index) {
            if (tbl_md[index, "type"] =='owner') {
              list(background = "rgba(0, 0, 0, 0.05)")
            }
          }
)
```

<!--html_preserve--><div id="htmlwidget-6d50701eac2a11062c72" class="reactable html-widget" style="width:auto;height:500px;"></div>
<script type="application/json" data-for="htmlwidget-6d50701eac2a11062c72">{"x":{"tag":{"name":"Reactable","attribs":{"data":{"type":["owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","owner","member","member","member","member","member","member","member","member","member","member","member","member","member","member","member","member","member","member","member","member","member","member"],"owner":["yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","yonicd","hrbrmstr","jonocarroll","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","metrumresearchgroup","ropenscilabs","talgalili","ThinkR-open","yuliasidi"],"repo":["blog","bplyr","carbonate","chunky","ciderhouse","CIMDO","cookr","covrfail","covrwarn","d3","details","EconomistLetter","Elections","foreman","gdigest","ghnet","GitHubAPI","gitLogs","gunflow","helpdesk","issue","lmmen","places","potus_public_schedule","reactor","regexSelect","revisionist","ripe","rpdf","rsam","rtravis","SearchTree","shinyghap","shinyHeatmaply","shinyProf","shinyselect","sinew_presentation","slackr-app","slackteams","supermarketprices","taseR","texsnippets","tidycheckUsage","tidyghql","toddlr","trying.lockedata.starters","slackr","ggeasy","covrpage","d3Tree","ggedit","jsTree","qibble","shinyCanvas","shinyglmnet","shredder","sinew","slickR","stantools","texblocks","texPreview","tic.covrpage","TorstenHeaders","vcs","tic.covrpage","heatmaply","remedy","condor"],"views":[2,25,63,0,0,6,0,0,0,0,216,0,6,33,0,0,0,1,0,22,3,65,3,1,20,36,0,71,24,13,0,0,0,58,4,0,1,4,43,1,4,0,0,1,1,0,387,662,67,167,290,84,6,20,0,170,9,315,0,1,150,0,2,2,0,656,103,0],"viewers":[2,5,49,0,0,6,0,0,0,0,87,0,5,14,0,0,0,1,0,12,3,20,1,1,12,13,0,30,22,7,0,0,0,30,4,0,1,2,13,1,2,0,0,1,1,0,217,336,17,57,229,62,1,18,0,43,7,86,0,1,30,0,2,2,0,416,75,0],"clones":[0,0,1,1,0,0,1,1,1,0,22,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,6,0,0,0,1,0,0,0,0,0,1,17,1,1,1,0,0,0,0,3,5,2,2,2,0,0,0,1,9,0,8,0,0,18,1,4,0,0,13,1,0],"cloners":[0,0,1,1,0,0,1,1,1,0,16,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,6,0,0,0,1,0,0,0,0,0,1,13,1,1,1,0,0,0,0,3,4,1,2,2,0,0,0,1,9,0,7,0,0,17,1,4,0,0,13,1,0]},"columns":[{"accessor":"type","name":"type","type":"character"},{"accessor":"owner","name":"owner","type":"character"},{"accessor":"repo","name":"repo","type":"character"},{"accessor":"views","name":"views","type":"numeric"},{"accessor":"viewers","name":"viewers","type":"numeric"},{"accessor":"clones","name":"clones","type":"numeric"},{"accessor":"cloners","name":"cloners","type":"numeric"}],"defaultSortDesc":true,"defaultSorted":[{"id":"views","desc":true}],"defaultPageSize":68,"paginationType":"numbers","showPageInfo":true,"minRows":1,"highlight":true,"rowStyle":[{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},{"background":"rgba(0, 0, 0, 0.05)"},null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],"height":"500px","dataKey":"261b8f29b81c351f0f07d5bbfba33cca"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
