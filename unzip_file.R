### Do 'unzipowania' plików pobranych



### POJEDYNCZY PLIK

zipF<-file.choose("dane/20181214_20181216") # lets you choose a file and save its file path in R (at least for windows)
outDir<-"unzip_files/20181214_20181216" # Define the folder where the zip file should be unzipped to 
unzip(zipF,exdir=outDir)  # unzip your file 

### WSZYSTKIE PLIKI (trochę to może się robić)
library(purrr)
library(stringr)
library(tidyverse)
# Rozpakowywanie danych
zipF = list.files(path = "dane", pattern = "*.zip")
walk(zipF, ~ unzip(zipfile = str_c("dane/", .x),
     exdir = str_c("rozpakowane/", .x)))
# Usunięcie ".zip" z nazwy folderu
original_names <- list.files(path = "rozpakowane", pattern="*.zip", full.names = T)
new_names <- paste0(str_sub(original_names, 1, nchar(original_names)-4))
file.rename(original_names, str_replace_all(original_names, ".zip", ""))

