nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

annualEmissions <- 
  setNames(
    aggregate(x = nei$Emissions, by = list(nei$year), FUN = sum),
    c('year', 'emissions'))

png("plot1.png", width = 480, height = 480)

plot(
  x = annualEmissions$year, 
  y = annualEmissions$emissions, 
  xlab = "Year", 
  ylab = expression("PM"[2.5]*" emissions (tons)"), 
  pch = 15, 
  main = expression("United States annual total PM"[2.5]*" emissions (1999-2008)"))

abline(
  lm(annualEmissions$emissions ~ annualEmissions$year), 
  lwd = 2, 
  col = "red")

dev.off()
