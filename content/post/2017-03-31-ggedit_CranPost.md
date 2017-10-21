---
title: ggedit 0.2.0
date: 2017-03-31
subtitle: Crantastic!
tags: [Shiny, ggplot2, Reproducibility]
cran: ggedit
cran_badge: [status, downloads]
gh_repo: metrumresearchgroup/ggedit
gh_badge: [follow, star, fork]
---

We are pleased to announce the release of the ggedit package on [CRAN](https://cran.r-project.org/web/packages/ggedit/index.html). 

To install the package you can call the standard R command

```
install.packages('ggedit')
```
The source version is still tracked on [github](https://github.com/metrumresearchgroup/ggedit), which has been reorganized to be easier to navigate. 

To install the dev version:

```
devtools::install_github('metrumresearchgroup/ggedit')
```

### What is ggedit?

ggedit is an R package that is used to facilitate ggplot formatting. With ggedit, R users of all experience levels can easily move from creating ggplots to refining aesthetic details, all while maintaining portability for further reproducible research and collaboration. 

ggedit is run from an R console or as a reactive object in any Shiny application. The user inputs a ggplot object or a list of objects. The application populates Bootstrap modals with all of the elements found in each layer, scale, and theme of the ggplot objects. The user can then edit these elements and interact with the plot as changes occur. During editing, a comparison of the script is logged, which can be directly copied and shared. The application output is a nested list containing the edited layers, scales, and themes in both object and script form, so you can apply the edited objects independent of the original plot using regular ggplot2 grammar. 

Why does it matter? ggedit promotes efficient collaboration. You can share your plots with team members to make formatting changes, and they can then send any objects they’ve edited back to you for implementation. No more email chains to change a circle to a triangle!

### Updates in ggedit 0.2.0:

  - The layer modal (popups) elements have been reorganized for less clutter and easier navigation.
  - The S3 method written to plot and compare themes has been removed from the package, but can still be found on the repo, see [plot.theme](https://github.com/metrumresearchgroup/ggedit/blob/master/Miscellaneous/Utilities/plot.theme.R).

### Deploying

    - call from the console: `ggedit(p)`
    - call from the addin toolbar: highlight script of a plot object on the source editor window of RStudio and run from toolbar.
    - call as part of Shiny: use the Shiny module syntax to call the ggEdit UI elements.
        - server: `callModule(ggEdit,'pUI',obj=reactive(p))`
        - ui: `ggEditUI('pUI')`
    - if you have installed the package you can see an example of a Shiny app by executing `runApp(system.file('examples/shinyModule.R',package = 'ggedit'))`
    

### Outputs

ggedit returns a list containing 8 elements either to the global enviroment or as a reactive output in Shiny.

  - updatedPlots
    - List containing updated ggplot objects
  - updatedLayers
    - For each plot a list of updated layers (ggproto) objects
    - Portable object
  - updatedLayersElements
    - For each plot a list elements and their values in each layer
    - Can be used to update the new values in the original code
  - updatedLayerCalls
    - For each plot a list of scripts that can be run directly from the console to create a layer
  - updatedThemes
    - For each plot a list of updated theme objects
    - Portable object
    - If the user doesn't edit the theme updatedThemes will not be returned
  - updatedThemeCalls
    - For each plot a list of scripts that can be run directly from the console to create a theme
  - updatedScales
    - For each plot a list of updated scales (ggproto) objects
    - Portable object
  - updatedScaleCalls
      - For each plot a list of scripts that can be run directly from the console to create a scale

### Short Clip to use ggedit in Shiny

<p><a href="https://www.youtube.com/embed/pJ1kbd_OVwg"><img src="http://img.youtube.com/vi/pJ1kbd_OVwg/0.jpg?image_play_button_size=2x&amp;image_crop_resized=960x540&amp;image_play_button=1&amp;image_play_button_color=71aadbe0" width="400" height="225" style="width: 400px; height: 225px;"></a></p>

<hr>
<em>
Jonathan Sidi joined Metrum Research Group in 2016 after working for several years on problems in applied statistics, financial stress testing and economic forecasting in both industrial and academic settings.
</em>

<em>
To learn more about additional open-source software packages developed by Metrum Research Group please visit the Metrum <a href="https://www.metrumrg.com/try-open-source-tools/" target="_blank">website</a>.
</em>

<em>
Contact: For questions and comments, feel free to email me at: yonis@metrumrg.com or open an issue in <a href="https://github.com/metrumresearchgroup/ggedit/issues" target="_blank">github</a>.
</em>

(post originally published on [r-posts](http://r-posts.com/ggedit-0-2-0-is-now-on-cran/))