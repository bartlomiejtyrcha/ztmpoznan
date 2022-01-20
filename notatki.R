library(dplyr)
library(mapview)
library(sf)
library(mapview)
library(stringr)

# dołączenie numeru linii do kształtu
shapes_sf = left_join(shapes_sf, trips %>% select(route_id, shape_id), by = "shape_id")

# przejrzenie danych przestrzennych
mapview(shapes_sf)
mapview(stops_sf, zcol = "zone_id")

# liczba kursów na danym przystanku w poszczególne dni tygodnia
lista = list("nie" = 9, "sob" = 3, "pia" = 7, "wt-sr-czw" = 1, "pon" = 5)
rm(stops2)
for (i in seq_along(lista)){
  x = inner_join(stops_sf, stop_times[str_sub(stop_times$trip_id, 1, 1) == lista[[i]],], by = "stop_id")
  if (exists("stops2") == FALSE){
    stops2 = x %>% group_by(stop_id, stop_name) %>% summarise()
  }
  stops2 = x %>% st_drop_geometry() %>% group_by(stop_id, stop_name) %>% summarise(n = n()) %>% select(n) %>% left_join(stops2, by = "stop_id")
  names(stops2)[2] = names(lista)[i]
  stops2 = relocate(stops2, stop_name, .after = stop_id)
}
stops2 = st_as_sf(stops2)
mapview(stops2, zcol = "wt-sr-czw", col.regions = RColorBrewer::brewer.pal(11, "RdYlGn"), at = c(0, 25, 50, 100, 300, 500, 800))

# dodanie liczby i listy linii obsługujących przystanek
stops21 = stops2 %>% left_join(stop_times, by = "stop_id") %>% left_join(trips, by = "trip_id")
stops21 = na.omit(stops21)
stops21 = stops21 %>% group_by(stop_id, stop_name, pon, `wt-sr-czw`, pia, sob, nie) %>%
  summarise(liczba_linii = length(unique(route_id)), linie = paste(as.character(unique(route_id)), collapse = ", "))
stops21 = st_as_sf(stops21)
mapview(stops21, zcol = "liczba_linii")

# liczba linii dziennych na danym przystanku a także ich wypisanie
trips_day = trips[str_sub(trips$route_id, 1, 1) != 2 | (str_sub(trips$route_id, 1, 1) == 2 & str_length(trips$route_id) == 1), ]
stops3 = stops_sf %>% left_join(stop_times, by = "stop_id") %>% left_join(trips_day, by = "trip_id") %>% select(stop_id, stop_name, route_id)
stops3 = na.omit(stops3)
stops3 = stops3 %>% group_by(stop_id, stop_name) %>%
  summarise(n = length(unique(route_id)), linie = paste(as.character(unique(route_id)), collapse = ", "))
mapview(stops3, zcol = "n")

# liczba linii nocnych na danym przystanku a także ich wypisanie
trips_night = trips[!(str_sub(trips$route_id, 1, 1) != 2 | (str_sub(trips$route_id, 1, 1) == 2 & str_length(trips$route_id) == 1)), ]
stops4 = stops_sf %>% left_join(stop_times, by = "stop_id") %>% left_join(trips_night, by = "trip_id") %>% select(stop_id, stop_name, route_id)
stops4 = na.omit(stops4)
stops4 = stops4 %>% group_by(stop_id, stop_name) %>%
  summarise(n = length(unique(route_id)), linie = paste(as.character(unique(route_id)), collapse = ", "))
mapview(stops4, zcol = "n")
# 
