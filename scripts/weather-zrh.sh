#!/bin/bash
parse_metar() {
  while read data; do
    mdate=$(echo $data | awk '{ print $2 }' | cut -c1-2)
    mtime=$(echo $data | awk '{ print $2 }' | cut -c3-6)
    mwinddir=$(echo $data | awk '{ print $3 }' | cut -c1-3)
    mwindknots=$(echo $data | awk '{ print $3 }' | cut -c4-5)
    printf "$mwinddir $mwindknots $data"
    printf '\n'
  done
}

curl -s 'https://aviationweather.gov/adds/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&stationString=LSZH&hoursBeforeNow=2&format=csv' |
cut -d',' -f1 |
grep LSZH |
parse_metar
