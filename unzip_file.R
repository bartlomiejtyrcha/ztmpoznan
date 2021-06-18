### Do 'unzipowania' plików pobranych

### POJEDYNCZY PLIK

zipF<-file.choose("dane/20181214_20181216") # lets you choose a file and save its file path in R (at least for windows)
outDir<-"unzip_files/20181214_20181216" # Define the folder where the zip file should be unzipped to 
unzip(zipF,exdir=outDir)  # unzip your file 



### PĘTLA

