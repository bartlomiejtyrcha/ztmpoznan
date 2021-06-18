
#install.packages("xml2")
#install.packages("rvest")

library(xml2)
library(rvest)
library(stringr)
### Dane do strony

strona = xml2::read_html("https://www.ztm.poznan.pl/pl/dla-deweloperow/gtfsFiles")
linki = rvest::html_table(strona)[[2]]

### Pobieranie danych - pojedynczy plik

download.file("https://www.ztm.poznan.pl/pl/dla-deweloperow/getGTFSFile/?file=20210125_20210221.zip", 
              destfile=str_c(getwd(),"/TEST"))

View(linki)
linki[1]
nrow(linki)
linki = linki[-nrow(linki),]
is.character(linki[267,1])
str(linki)
#str_detect(linki[,1], pattern = "\\.")
View(linki[,1])

linki2 = linki
#linki2[1,1] = str_c("https://www.ztm.poznan.pl/pl/dla-deweloperow/getGTFSFile/?file=", linki2[1,1]) - DZIAŁA

### AUTOMATYZACJA POBIERANIA 

linki$file_www = str_c("https://www.ztm.poznan.pl/pl/dla-deweloperow/getGTFSFile/?file=", linki$`Nazwa pliku`)
linki = linki[-nrow(linki),]
dir.create("dane")
getwd() 

######### TO POBIERA WSZYSTKIE PLIKI UWAGA XD
for(i in 1:length((linki$`Nazwa pliku`))){
  download.file(linki[i,5], destfile=str_c("./dane2/", linki$`Nazwa pliku`[i]))
} #pętla pobierania

c(4,5,6,7)[2]

