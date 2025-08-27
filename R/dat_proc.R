library(tidyverse)
library(here)

# import raw data -----------------------------------------------------------------------------

# 2015 - 2023
prior <- read.csv(here('data-raw/OldTampaBayCyst_Abundance_2015-2023_SurfaceGrabsandCores_1-12-2024.csv')) |>
  select(date = Sample.Date, station = Station, lat = Latitude, lon = Longitude, avgcystpergsed = P..bahamense.cyst.abundance..cysts.g.wet.sediment.) |>
  mutate(
    date = lubridate::mdy(date),
    year = lubridate::year(date),
    month = lubridate::month(date)
  )

# 2024
aug2024 <- read.csv(here('data-raw/CystCountsEPCHCFWC2024.csv')) |>
  select(date = Sample.Date, station = Station, lat = Latitude, lon = Longitude, avgcystpergsed = P..bah.Cysts..per.g.wet.sediment.) |>
  mutate(
    date = lubridate::mdy(date),
    year = 2024,
    month = 8
  )

# 2025
mar2025 <- read.csv(here('data-raw/EPCHC_FWC_Pyrodiniumcystcounts2025.csv')) |>
  select(date = Sample.Date, station = Sample.ID, lat = Latitude, lon = Longitude, avgcystpergsed = Avg.Cyst.G) |>
  mutate(
    date = lubridate::mdy(date),
    year = 2025,
    month = 3
  )

cystdat <- bind_rows(prior, aug2024, mar2025)

save(cystdat, file = here('data/cystdat.RData'))

# germination data -------------------------------------------------------

germdat <- read.csv(here('data-raw/PyrodiniumGerminationData_Temperature.csv')) |> 
  select(
    temp = Incubation.Temperature..degC., 
    rep = Replicate,
    day = Days.after.Isolation, 
    percgerm = Percent.germinated..of.viable.cysts.
  )

save(germdat, file = here('data/germdat.RData'))
