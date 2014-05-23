library(ggplot2)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

coalCombustionScc <- 
  scc[
    grepl(pattern = "combustion", x = scc$SCC.Level.One, ignore.case = TRUE) &
    (
      grepl(pattern = "coal", x = scc$SCC.Level.Three, ignore.case = TRUE) |
      grepl(pattern = "lignite", x = scc$SCC.Level.Three, ignore.case = TRUE)),
  ]

coalCombustionNei <- nei[nei$SCC %in% coalCombustionScc$SCC, ]

annualCoalCombustionEmissions <- 
  setNames(
    aggregate(
      x = coalCombustionNei$Emissions, 
      by = list(coalCombustionNei$year), 
      FUN = sum),
    c('year', 'emissions'))

png("plot4.png", width = 640, height = 480)

print(
  ggplot(annualCoalCombustionEmissions, aes(x = year, y = emissions)) + 
    geom_point(aes(size = 1)) + 
    geom_smooth(method = "lm", fill = NA, size = 1, color = "red") +
    xlab("Year") + 
    ylab(expression("PM"[2.5]*" emissions (tons)")) + 
    ggtitle(expression("United States annual coal/combustion source PM"[2.5]*" emissions (1999-2008)")) + 
    theme(legend.position = "none"))

dev.off()

