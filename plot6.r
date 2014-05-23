library(ggplot2)
library(reshape)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

yearOverYearEmissionChange <- 
  function(nei, label) {
    annualEmissions <- 
      setNames(
        aggregate(
          x = nei$Emissions, 
          by = list(nei$year), 
          FUN = sum),
        c('year', 'emissions'))

    laggedEmissions <- 
      c(
        annualEmissions$emissions[1], 
        head(
          annualEmissions$emissions, 
          n = length(annualEmissions$emissions) - 1))

    yoyChangeEmissions <- annualEmissions$emissions / laggedEmissions - 1

    yoyEmissionsTimeSeries <- 
      setNames(
        data.frame(annualEmissions$year, yoyChangeEmissions),
        c('year', label)) 

    return(yoyEmissionsTimeSeries)
  }

losAngelesNei <- nei[nei$type == 'ON-ROAD' & nei$fips == '06037', ]
baltimoreNei <- nei[nei$type == 'ON-ROAD' & nei$fips == '24510', ]

mergedEmissionChanges <-
  merge( 
    yearOverYearEmissionChange(nei = baltimoreNei, label = 'baltimore'),
    yearOverYearEmissionChange(nei = losAngelesNei, label = 'losAngeles'),
    by = "year")

meltedMergedEmissionChanges <- 
  setNames(  
    melt(mergedEmissionChanges, c("year")),
    c('year', 'county', 'yoyEmissionsChange'))
# To properly format the plot x-axis 
meltedMergedEmissionChanges$year <- 
  as.character(meltedMergedEmissionChanges$year)

png("plot6.png", width = 768, height = 480)

print(
  ggplot(
      meltedMergedEmissionChanges, 
      aes(x = year, y = yoyEmissionsChange, 
      fill = county)) + 
    geom_bar(stat = "identity", position="dodge") + 
    xlab("Year") + 
    ylab(expression("Year-over-year PM"[2.5]*" emissions change")) + 
    scale_y_continuous(breaks = round(seq(-0.7, 0.2, 0.1), 2)) +
    scale_fill_discrete(name="County", labels=c("Baltimore", "Los Angeles")) + 
    ggtitle(expression("Baltimore and Los Angeles:  year-over-year motor vehicle PM"[2.5]*" emissions change (1999-2008)")))

dev.off()

