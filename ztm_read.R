ztm_read = function(path){
  files = list.files(path = path, pattern="*.txt$", full.names = T)
  
  agency <<- read.delim2(files[1], sep=",", encoding = "UTF-8")
  calendar_dates <<- read.delim2(files[2], sep=",", encoding = "UTF-8")
  calendar <<- read.delim2(files[3], sep=",", encoding = "UTF-8")
  feed_info <<- read.delim2(files[4], sep=",", encoding = "UTF-8")
  routes <<- read.delim2(files[5], sep=",", encoding = "UTF-8")
  shapes <<- read.delim2(files[6], sep=",", encoding = "UTF-8")
  stop_times <<- read.delim2(files[7], sep=",", encoding = "UTF-8")
  stops <<- read.delim2(files[8], sep=",", encoding = "UTF-8")
  trips <<- read.delim2(files[9], sep=",", encoding = "UTF-8")
  message("Wczytano obiekty: agency, calendar_dates, calendar, feed_info, routes, shapes, stop_times, stops, trips")
  
  if_sf = readline("Czy stworzyć obiekty przestrzenne dla shapes i stops? (T/N):   ")
  if (if_sf == "T"){
    shapes_sf = sf::st_as_sf(shapes, coords = c("shape_pt_lon", "shape_pt_lat"))
    shapes_sf = sf::st_set_crs(shapes_sf, 4326)
    shapes_sf <<- sf::st_cast(dplyr::summarise(dplyr::group_by(shapes_sf, shape_id), do_union = FALSE), "LINESTRING")
    shapes_sf <<- sf::st_set_crs(shapes_sf, 4326)
    message("Stworzono obiekt shapes_sf")
    
    stops_sf = sf::st_as_sf(stops, coords = c("stop_lon", "stop_lat"))
    stops_sf <<- sf::st_set_crs(stops_sf, 4326)
    message("Stworzono obiekt stops_sf")
  }
}
