library(dplyr)
library(mapview)
library(sf)
#install.packages('mapview')
library(mapview)

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
mapview(stops_sf)
View(stop_times)
# 

# dołączenie numeru linii do kształtu
shapes_sf = dplyr::left_join(shapes_sf, trips %>% dplyr::select(route_id, shape_id), by = "shape_id")