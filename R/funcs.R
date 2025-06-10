cystmap_fun <- function(dat){

  data(tbseg, package = 'tbeptools')

  # otb bbox
  otbseg <- tbseg |>
    dplyr::filter(bay_segment == 'OTB') |>
    sf::st_bbox()

  # Create breakpoints for cyst counts
  breaks <- c(0, 100, 500, 1000, 5000, 10000, Inf)
  break_labels <- c("0-100", "101-500", "501-1000", "1001-5000", "5001-10000", ">10000")

  # Create categories
  dat$cyst_category <- cut(dat$avgcystpergsed,
                            breaks = breaks,
                            labels = break_labels,
                            include.lowest = TRUE,
                            right = TRUE)

  # Define colors - grey for smallest, red ramp for others
  colors <- c("grey", "#FEB24C", "#FD8D3C", "#FC4E2A", "#E31A1C", "#B10026")
  names(colors) <- break_labels

  # Define sizes for each category
  sizes <- seq(4, 20, length.out = 6)
  names(sizes) <- break_labels

  # Add color and size columns to data
  dat$color <- colors[dat$cyst_category]
  dat$size <- sizes[dat$cyst_category]

  # Create popup text
  dat$popup_text <- paste0(
    "<b>Sample ID:</b> ", dat$station, "<br>",
    "<b>Date:</b> ", dat$date, "<br>",
    "<b>Location:</b> ", round(dat$lat, 4), ", ", round(dat$lon, 4), "<br>",
    "<b>Avg Cysts/G:</b> ", format(dat$avgcystpergsed, big.mark = ","), "<br>"
  )

  esri <- rev(grep("^Esri", leaflet::providers, value = TRUE))

  m <- leaflet::leaflet(dat) |>
    leaflet::fitBounds(lng1 = otbseg[['xmin']], lat1 = otbseg[['ymin']],
              lng2 = otbseg[['xmax']], lat2 = otbseg[['ymax']])

  for (provider in esri) {
    m <- m |> leaflet::addProviderTiles(provider, group = provider)
  }

  # Create the leaflet map
  m <- m |>
    # Add circle markers
    addCircleMarkers(
      lng = ~lon,
      lat = ~lat,
      radius = ~size,
      color = "black",        # Black outline
      weight = 2,             # Outline thickness
      fillColor = ~color,     # Fill color based on category
      fillOpacity = 0.8,      # Fill transparency
      popup = ~popup_text,    # Popup information
      label = ~paste("Cysts/G:", format(avgcystpergsed, big.mark = ","))
    ) |>

    # Add legend
    addLegend(
      position = "bottomright",
      colors = colors,
      labels = break_labels,
      title = "Avg Cysts/G Sediment",
      opacity = 0.8
    ) |>
    leaflet::addLayersControl(baseGroups = names(esri),
                              options = leaflet::layersControlOptions(collapsed = T),
                              position = 'topleft')

  # Display the map
  return(m)

}
