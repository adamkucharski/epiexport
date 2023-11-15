
# Load flight data for UK

library(rio)
flight_data_major <- rio::import("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1123230/avi0301.ods",sheet=2)

# Benchmark to UK
lhr_UK_data <- flight_data_major |> filter(Var.3=="Heathrow Airport")
lhr_flights_open <- flight_data |> filter(source_airport=="LHR")

lhr_2019 <- (1e3*as.numeric(lhr_UK_data$Var.5)/2)/365
flights_out <- nrow(lhr_flights_open)

# Scaling factor
scale_f <- lhr_2019/flights_out

# Other tools to explore: 
# #https://opensky-network.org/data/data-tools#d4
