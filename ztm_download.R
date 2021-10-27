# argument 'rekordy' określa ile plików chcemy pobrać zaczynając od najbardziej aktualnego (domyślnie tylko najnowszy)
# argument 'path' określa folder roboczy, domyślnie jest to aktualnie używany folder projektu
ztm_download = function(rekordy = 1, path = getwd()){
  # pobranie tabeli z dostępnymi plikami
  strona = xml2::read_html("https://www.ztm.poznan.pl/pl/dla-deweloperow/gtfsFiles")
  linki = rvest::html_table(strona)[[2]]
  # stworzenie linków pobierających pliki
  linki$file_www = str_c("https://www.ztm.poznan.pl/pl/dla-deweloperow/getGTFSFile/?file=", linki$`Nazwa pliku`)
  
  # sprawdzenie czy folder 'dane' istnieje żeby nei było ewentualnych kolizji
  if (dir.exists("dane") == FALSE){
    dir.create("dane")
  }
  
  # pętla pobierająca
  for(i in 1:rekordy){
    # pobranie pliku do folderu 'dane'
    download.file(linki$file_www[i], destfile = stringr::str_c(path, "/dane/", linki$`Nazwa pliku`[i]))
    # rozpakowanie go do folderu o tej samej nazwie
    unzip(stringr::str_c(path, "/dane/", linki$`Nazwa pliku`[i]), 
          exdir = stringr::str_c(path, "/dane/",
                                 stringr::str_sub(linki$`Nazwa pliku`[i], 1, -4)))
    # usunięcie starego zipa
    file.remove(stringr::str_c(path, "/dane/", linki$`Nazwa pliku`[i]))
  }
}
