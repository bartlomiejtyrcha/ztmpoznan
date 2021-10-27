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
}
