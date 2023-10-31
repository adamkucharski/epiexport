# As of June 2014, the OpenFlights/Airline Route Mapper Route Database contains 67663 routes between 3321 airports on 548 airlines spanning the globe, as shown in the map above. Each entry contains the following information:
# Airline 	2-letter (IATA) or 3-letter (ICAO) code of the airline.
# Airline ID 	Unique OpenFlights identifier for airline (see Airline).
# Source airport 	3-letter (IATA) or 4-letter (ICAO) code of the source airport.
# Source airport ID 	Unique OpenFlights identifier for source airport (see Airport)
# Destination airport 	3-letter (IATA) or 4-letter (ICAO) code of the destination airport.
# Destination airport ID 	Unique OpenFlights identifier for destination airport (see Airport)
# Codeshare 	"Y" if this flight is a codeshare (that is, not operated by Airline, but another carrier), empty otherwise.
# Stops 	Number of stops on this flight ("0" for direct)
# Equipment 	3-letter codes for plane type(s) generally used on this flight, separated by spaces

flight_url <- "https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat"
flight_data <- rio::import(file = flight_url) |> rename(source_airport=V3,destination_airport=V4)

# Estimate Wuhan

daily_wuhan_iata <- 3300 # Value from Imai et al based on IATA data

mean_flight_frequency_per_day <- 1/7 # User defined
mean_passengers_per_flight <- 150 # User defined
  
wuhan_flights <- flight_data |> filter(source_airport=="WUH")
daily_outbound <- nrow(wuhan_flights)*mean_flight_frequency_per_day*mean_passengers_per_flight

# Total cases domestically
number_cases <- function(n_cases_abroad,
                         daily_outbound,
                         catchment_population,
                         incubation_period,
                         onset_to_detection){
  
  n_cases_est <- (daily_outbound/catchment_population)*(incubation_period+onset_to_detection)
  
  n_cases_est
  # Need to calculate CI on total cases
  # successes = n_cases_abroad, probability = p_detected
  
}


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
