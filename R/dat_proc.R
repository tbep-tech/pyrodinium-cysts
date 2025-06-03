library(tidyverse)
library(here)

# import raw data -----------------------------------------------------------------------------

aug2024 <- read.csv(here('data-raw/CystCountsEPCHCFWC2024.csv')) |>
  select(date = Sample.Date, station = Station, lat = Latitude, lon = Longitude, avgcystpergsed = P..bah.Cysts..per.g.wet.sediment.) |>
  mutate(
    date = lubridate::mdy(date),
    year = 2024,
    month = 8
  )
mar2025 <- read.csv(here('data-raw/EPCHC_FWC_Pyrodiniumcystcounts2025.csv')) |>
  select(date = Sample.Date, station = Sample.ID, lat = Latitude, lon = Longitude, avgcystpergsed = Avg.Cyst.G) |>
  mutate(
    date = lubridate::mdy(date),
    year = 2025,
    month = 3
  )

cystdat <- bind_rows(aug2024, mar2025)

save(cystdat, file = here('data/cystdat.RData'))
