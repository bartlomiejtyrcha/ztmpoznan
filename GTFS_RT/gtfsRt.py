from google.transit import gtfs_realtime_pb2
import urllib.request
import sys

# sys.argv[1]: trip_updates, vehicle_positions, feeds
# sys.args[2]: index

def main():
  feed = gtfs_realtime_pb2.FeedMessage()
  url = ('https://www.ztm.poznan.pl/pl/dla-deweloperow/getGtfsRtFile/?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0ZXN0Mi56dG0ucG96bmFuLnBsIiwiY29kZSI6MSwibG9naW4iOiJtaFRvcm8iLCJ0aW1lc3RhbXAiOjE1MTM5NDQ4MTJ9.ND6_VN06FZxRfgVylJghAoKp4zZv6_yZVBu_1-yahlo&file='
          + sys.argv[1] + ".pb")
  index = int(sys.argv[2])
  get_object(feed, url, index)

def get_object(feed, url, index):
  response = urllib.request.urlopen(url)
  feed.ParseFromString(response.read())
  print(feed.entity[index])

if __name__ == "__main__":
  main()
