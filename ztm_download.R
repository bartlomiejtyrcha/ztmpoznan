# argument 'rekordy' określa ile plików chcemy pobrać zaczynając od najbardziej aktualnego (domyślnie tylko najnowszy)
# argument 'path' określa folder roboczy, domyślnie jest to aktualnie używany folder projektu
ztm_download = function(rekordy = 1, path = getwd()){
  # pobranie tabeli z dostępnymi plikami
  strona = xml2::read_html("https://www.ztm.poznan.pl/pl/dla-deweloperow/gtfsFiles")
  linki = rvest::html_table(strona)[[2]]
  # stworzenie linków pobierających pliki
  linki$file_www = stringr::str_c("https://www.ztm.poznan.pl/pl/dla-deweloperow/getGTFSFile/?file=", linki$`Nazwa pliku`)
  
  # sprawdzenie czy folder 'dane' istnieje żeby nei było ewentualnych kolizji
  if (dir.exists("dane") == FALSE){
    dir.create("dane")
  }
  
  # pętla pobierająca
  for(i in 1:rekordy){
    # pobranie pliku do folderu 'dane'
    download.file(linki$file_www[i], destfile = stringr::str_c(path, "/dane/", linki$`Nazwa pliku`[i]))
    # rozpakowanie go do folderu o tej samej nazwie
    dest = stringr::str_c(path, "/dane/", stringr::str_remove(linki$`Nazwa pliku`[i], ".zip"))
    message(stringr::str_c("Rozpakowywanie plików... ", i, "/", rekordy))
    unzip(stringr::str_c(path, "/dane/", linki$`Nazwa pliku`[i]), 
          exdir = dest)
    # usunięcie starego zipa
    file.remove(stringr::str_c(path, "/dane/", linki$`Nazwa pliku`[i]))
  }
  
  if (rekordy == 1){
    if_read = readline("Wybrałeś tylko jeden plik. Czy wczytać od razu dane jako obiekty? (T/N):   ")
    if (if_read == "T"){
      ztm_read(dest)
    }
  }
}

ztm_download(1)
