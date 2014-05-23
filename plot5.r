library(ggplot2)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

baltimoreMotorVehicleNei <- nei[nei$fips == '24510' & nei$type == 'ON-ROAD', ]

annualMotorVehicleBaltimoreEmissions <- 
  setNames(
    aggregate(
      x = baltimoreMotorVehicleNei$Emissions, 
      by = list(baltimoreMotorVehicleNei$year), 
      FUN = sum),
    c('year', 'emissions'))

png("plot5.png", width = 480, height = 480)

print(
  ggplot(annualMotorVehicleBaltimoreEmissions, aes(x = year, y = emissions)) + 
    geom_point(aes(size = 1)) + 
    geom_smooth(method = "lm", fill = NA, size = 1, color = "red") +
    xlab("Year") + 
    ylab(expression("PM"[2.5]*" emissions (tons)")) + 
    ggtitle(expression("Baltimore, MD annual motor vehicle PM"[2.5]*" emissions (1999-2008)")) + 
    theme(legend.position = "none"))

dev.off()

