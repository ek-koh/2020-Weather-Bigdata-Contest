# Weather-Bigdata-Contest
## AWS 데이터 설명
### stn_id
- 운평 AWS : 37.084530,126.773890 - stn_id==515
- 아산 AWS : 36.845780,126.865360 - stn_id==634
- 신평 AWS : 36.893750,126.805583 - stn_id==637
- 당진 AWS : 36.889361,126.617389 - stn_id==616

```r
# working code
aws_wind <- dbGetQuery(conn, "SELECT * FROM db_aws_wind_tim
                        WHERE db_aws_wind_tim.stn_id IN (515, 634, 637, 616)
                        AND db_aws_wind_tim.tma > '2016-03-31 23:00:00.0'
                        AND db_aws_wind_tim.tma < '2020-04-01 00:00:00.0'")

colnames(aws_wind)=gsub("db_aws_ta_tim.", "", colnames(aws_wind), ignore.case = T)
head(aws_wind)

write.csv(aws_wind, "aws_wind.csv", fileEncoding = "utf-8")


#  Get data : sea_bouy

## stn_id == 22101
## 2100123100,1996070100,덕적도,37.2361,126.0188

sea_buoy <- dbGetQuery(conn, "SELECT * FROM db_sea_buoy_tim
                        WHERE db_sea_buoy_tim.stn_id==22101
                        AND db_sea_buoy_tim.tm > '2016-03-31 23:00:00.0'
                        AND db_sea_buoy_tim.tm < '2020-04-01 00:00:00.0'")

colnames(sea_buoy)=gsub("db_sea_buoy_tim.", "", colnames(sea_buoy), ignore.case = T)
head(sea_buoy)

write.csv(sea_buoy, "sea_buoy.csv", fileEncoding = "utf-8")


#  Get data : sea_lb
## stn_id == 955
## 2100123100,2001120100,서수도,37.325,126.3933333,18,12A20000,2872037000
sea_lb <- dbGetQuery(conn, "SELECT * FROM db_sea_lb_tim
                        WHERE db_sea_lb_tim.stn_id==955
                        AND db_sea_lb_tim.tm > '2016-03-31 23:00:00.0'
                        AND db_sea_lb_tim.tm < '2020-04-01 00:00:00.0'")

colnames(sea_lb)=gsub("db_sea_lb_tim.", "", colnames(sea_lb), ignore.case = T)
head(sea_lb)

write.csv(sea_lb, "sea_lb.csv", fileEncoding = "utf-8")
```
