# OpenSkies data ----------------------------------------------------------

# Load openSkies package (not used currently)
library(openSkies)

wuhan_departures <- getAirportDepartures(airport = "WUH", startTime = "2019-01-01 12:00:00", endTime = "2019-01-08 12:00:00",timeZone = "Europe/Berlin")


# OpenFlights data --------------------------------------------------------

flight_url <- "https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat"
flight_data <- rio::import(file = flight_url) |> rename(source_airport=V3,destination_airport=V5)

# OpenFlights guide
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

# Estimate Wuhan flights based on OpenFlights data
wuhan_connections <- flight_data |> filter(source_airport=="WUH")

mean_flight_frequency_per_day <- 1/10 # User defined
mean_passengers_per_flight <- 170 # User defined

daily_outbound <- nrow(wuhan_flights)*mean_flight_frequency_per_day*mean_passengers_per_flight


# Define Imai et al (2020) values for comparison
daily_wuhan_iata <- 3301 # Value based on IATA data
catchment_population <- 19e6

# Natural history of epidemic
incubation_period <- 5
onset_to_detection <- 5


# Case estimation model ---------------------------------------------------

# Total cases domestically
number_cases <- function(n_cases_abroad,
                         daily_outbound,
                         catchment_population,
                         incubation_period,
                         onset_to_detection){
  
  p <- (daily_outbound/catchment_population)*(incubation_period+onset_to_detection)
  
  # Expected number of domestic cases
  n_cases_est <- n_cases_abroad/p
  
  return(n_cases_est)
  # Need to calculate CI on total cases
  # successes = n_cases_abroad, probability = p_detected
  
}

# Imai et al estimate
number_cases(3,daily_wuhan_iata,catchment_population,incubation_period,onset_to_detection)

# OpenFlights estimate (aligned to roughly match Imai et al)
number_cases(3,daily_outbound,catchment_population,incubation_period,onset_to_detection)

# Other tools to explore: 
# #https://opensky-network.org/data/data-tools#d4


