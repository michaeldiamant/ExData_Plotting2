library(ggplot2)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

baltimoreNei <- nei[nei$fips == '24510',]

annualPerSourceBaltimoreEmissions <- 
  setNames(
    aggregate(
      x = baltimoreNei$Emissions, 
      by = list(baltimoreNei$year, baltimoreNei$type), 
      FUN = sum),
    c('year', 'sourceType', 'emissions'))

png("plot3.png", width = 768, height = 480)

print(
  ggplot(annualPerSourceBaltimoreEmissions, aes(x = year, y = emissions)) + 
    geom_point() + 
    geom_smooth(method = "lm", fill = NA, color = "red") +
    facet_grid(. ~ sourceType) + 
    xlab("Year") + 
    ylab(expression("PM"[2.5]*" emissions (tons)")) +
    ggtitle(expression("Baltimore, MD annual total PM"[2.5]*" emissions by source type (1999-2008)")) + 
    theme(legend.position = "none"))

dev.off()
