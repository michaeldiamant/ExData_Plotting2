nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

baltimoreNei <- nei[nei$fips == '24510', ]

annualBaltimoreEmissions <- 
  setNames(
    aggregate(
      x = baltimoreNei$Emissions, 
      by = list(baltimoreNei$year), 
      FUN = sum),
    c('year', 'emissions'))

png("plot2.png", width = 480, height = 480)

plot(
  x = annualBaltimoreEmissions$year, 
  y = annualBaltimoreEmissions$emissions, 
  xlab = "Year", 
  ylab = expression("PM"[2.5]*" emissions (tons)"), 
  pch = 15, 
  main = expression("Baltimore, MD annual total PM"[2.5]*" emissions (1999-2008)"))

abline(
  lm(annualBaltimoreEmissions$emissions ~ annualBaltimoreEmissions$year), 
  lwd = 2, 
  col = "red")

dev.off()
