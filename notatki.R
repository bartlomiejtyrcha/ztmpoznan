library(dplyr)
library(mapview)
library(sf)
library(mapview)
library(stringr)

stops20181214_20181216 = read.delim2("unzip_files/20181214_20181216/stops.txt", sep=",")
View(stops20181214_20181216)
#(20181214_20181216)
temp = list.files(path = "unzip_files/20181214_20181216",pattern="*.txt", full.names = T)
agency = read.delim2(temp[1], sep=",")
calendar_dates = read.delim2(temp[2], sep=",")
calendar = read.delim2(temp[3], sep=",")
feed_info = read.delim2(temp[4], sep=",")
routes = read.delim2(temp[5], sep=",")
shapes = read.delim2(temp[6], sep=",")
stop_times = read.delim2(temp[7], sep=",")
stops = read.delim2(temp[8], sep=",")
trips = read.delim2(temp[9], sep=",")
View(trips)

#agency
View(agency)
#calendar dates
View(calendar_dates) # nic nie ma XD
# calendar - 0 - kurs sie nie odbywa, 1 - odbywa sie
View(calendar)
# feed_info - kto udostepnia dane
View(feed_info)
### routes - 
#agency_id - kto obsługuje linie
#route_short_name - numer linii/ krótka nazwa linii
View(routes)
### shapes - kształty linii
View(shapes) # trochę ich jest XD shape_id to kształt przebiegu linii
shapes_sf = st_as_sf(shapes, coords = c("shape_pt_lon", "shape_pt_lat"))
shapes_sf = st_set_crs(shapes_sf, 4326)
plot(shapes_sf["shape_id"])
###stop times
# no i tu grubo XD pierwsza kolumna:
# ^ - Oznaczenie danego kursu znacznikiem legendy, powiązującym go z polem route_desc w pliku routes.txt – 
# dzięki temu na tabliczce rozkładów jazdy oznaczyć można kursy,których dotyczy opis w legendzie pod trasą
#przejazdu linii. Jeśli znaczników jest kilka,należy oddzielić jeprzecinkiem. Przypadek
#oznaczenia ważnego tylko na części kursu:  przed znakiem określa się numer przystanku od
#którego oznaczenie obowiązuje, a po znaku – do którego. Przykład:
#  G:2:8 – oznaczenie G znajduje się na przystankach od 2 do 8 (włącznie) danego kursu.
#Powiązane z trips.txt. + - oznaczenie wariantu głównego 
View(stop_times)

## sf
# stops
stops_sf = st_as_sf(stops, coords = c("stop_lon", "stop_lat"))
stops_sf = st_set_crs(stops_sf, 4326)
View(stops_sf)
plot(stops_sf)
mapview(stops_sf, zcol = "zone_id")
View(stop_times)

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

# dołączenie numeru linii do kształtu
shapes_sf = dplyr::left_join(shapes_sf, trips %>% dplyr::select(route_id, shape_id), by = "shape_id")