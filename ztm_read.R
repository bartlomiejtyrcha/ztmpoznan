ztm_read = function(path){
  files = list.files(path = path, pattern="*.txt$", full.names = T)
  agency <<- read.delim2(files[1], sep=",")
  calendar_dates <<- read.delim2(files[2], sep=",")
  calendar <<- read.delim2(files[3], sep=",")
  feed_info <<- read.delim2(files[4], sep=",")
  routes <<- read.delim2(files[5], sep=",")
  shapes <<- read.delim2(files[6], sep=",")
  stop_times <<- read.delim2(files[7], sep=",")
  stops <<- read.delim2(files[8], sep=",")
  trips <<- read.delim2(files[9], sep=",")
}
