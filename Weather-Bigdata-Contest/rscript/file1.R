#하이브 내 전체 테이블 리스트 확인
list <- dbGetQuery(conn, "show tables")
list

# plant1_train data load
plant1_train <- dbGetQuery(conn, "SELECT * FROM plant1_train")

head(plant1_train)
tail(plant1_train)
summary(plant1_train)

colnames(plant1_train)=gsub("plant1_train.", "", colnames(plant1_train), ignore.case = T)

write.csv(plant1_train, "plant1_train.csv", fileEncoding = "utf-8")

# plant2_train data load
plant2_train <- dbGetQuery(conn, "SELECT * FROM plant2_train")

summary(plant2_train)
colnames(plant2_train)=gsub("plant2_train.", "", colnames(plant2_train), ignore.case = T)

# plant_test data load
plant_test <- dbGetQuery(conn, "SELECT * FROM plant_test")
head(plant_test, 1)

colnames(plant_test)=gsub("plant_test.", "", colnames(plant_test), ignore.case = T)
summary(plant_test)

write.csv(plant2_train, "plant2_train.csv", fileEncoding = "utf-8")
write.csv(plant_test, "plant_test.csv", fileEncoding = "utf-8")

# number 129 data extract FROM ASOS: Temp, Humidity, Cloud tables
# 129,126.49391,36.77661,28.9,서산,11C20101,4421010600
View(list)
ta <- dbGetQuery(conn, "SELECT * FROM db_sfc_ta_dd
                 WHERE db_sfc_ta_dd.stn_id==129 
                 and db_sfc_ta_dd.tma LIKE '2020-01%'")
rhm <- dbGetQuery(conn, "SELECT * FROM db_sfc_rhm_dd
                 WHERE db_sfc_rhm_dd.stn_id==129 
                  and db_sfc_rhm_dd.tma LIKE '2020-01%'")
cloud <- dbGetQuery(conn, "SELECT * FROM db_sfc_cloud_dd
                 WHERE db_sfc_cloud_dd.stn_id==129 
                    and db_sfc_cloud_dd.tma LIKE '2020-01%'")


head(ta,1)
head(rhm, 1)
head(cloud,1)

# simplify colnames

colnames(ta)=gsub("db_sfc_ta_dd.", "", colnames(ta), ignore.case = T)
colnames(rhm)=gsub("db_sfc_rhm_dd.", "", colnames(rhm), ignore.case = T)
colnames(cloud)=gsub("db_sfc_cloud_dd.", "", colnames(cloud), ignore.case = T)

colnames(ta)
colnames(rhm)
colnames(cloud)

# table JOIN
library(sqldf)
library(tcltk)
table <- sqldf('SELECT a.tma, a.stn_id, a.avg_ta, a.max_ta, a.min_ta,
                       b.avg_rhm, b.min_rhm,
                       c.avg_tca, c.avg_lmac, c.max_ca
                FROM ta a
                JOIN rhm b ON a.tma = b.tma
                JOIN cloud c ON a.tma = c.tma')

str(table)

write.csv(table, "table_ta_rhm_cloud.csv", fileEncoding = 'utf-8')


# data find
View(list)
ta <- dbGetQuery(conn, "SELECT * FROM db_sfc_ta_dd
                 WHERE db_sfc_ta_dd.stn_id==129 
                 and db_sfc_ta_dd.tma LIKE '2019-04%'")
rhm <- dbGetQuery(conn, "SELECT * FROM db_sfc_rhm_dd
                 WHERE db_sfc_rhm_dd.stn_id==129 
                  and db_sfc_rhm_dd.tma LIKE '2019-04%'")
cloud <- dbGetQuery(conn, "SELECT * FROM db_sfc_cloud_dd
                 WHERE db_sfc_cloud_dd.stn_id==129 
                    and db_sfc_cloud_dd.tma LIKE '2019-04%'")

colnames(ta)=gsub("db_sfc_ta_dd.", "", colnames(ta), ignore.case = T)
colnames(rhm)=gsub("db_sfc_rhm_dd.", "", colnames(rhm), ignore.case = T)
colnames(cloud)=gsub("db_sfc_cloud_dd.", "", colnames(cloud), ignore.case = T)

head(ta, 5)
colnames(ta)

summary(ta)

#  Get data : AWS

## 운평 AWS : 37.084530,126.773890 - stn_id==515
## 아산 AWS : 36.845780,126.865360 - stn_id==634
## 신평 AWS : 36.893750,126.805583 - stn_id==637
## 당진 AWS : 36.889361,126.617389 - stn_id==616

aws_cloud <- dbGetQuery(conn, "SELECT * FROM db_aws_cloud_tim
                        WHERE db_aws_cloud_tim.stn_id IN (515, 634, 637, 616)
                        AND db_aws_cloud_tim.tma > '2016-03-31 23:00:00.0'
                        AND db_aws_cloud_tim.tma < '2020-04-01 00:00:00.0'")
head(aws_cloud)
colnames(aws_cloud)=gsub("db_aws_cloud_tim.", "", colnames(aws_cloud), ignore.case = T)
colnames(aws_cloud)
write.csv(aws_cloud, "aws_cloud.csv", fileEncoding = "utf-8")



aws_icsr_ss <- dbGetQuery(conn, "SELECT * FROM db_aws_icsr_ss_tim
                        WHERE db_aws_icsr_ss_tim.stn_id IN (515, 634, 637, 616)
                        AND db_aws_icsr_ss_tim.tma > '2016-03-31 23:00:00.0'
                        AND db_aws_icsr_ss_tim.tma < '2020-04-01 00:00:00.0'")

colnames(aws_icsr_ss)=gsub("db_aws_icsr_ss_tim.", "", colnames(aws_icsr_ss), ignore.case = T)
head(aws_icsr_ss)

write.csv(aws_icsr_ss, "aws_icsr_ss.csv", fileEncoding = "utf-8")



aws_lwt_tg <- dbGetQuery(conn, "SELECT * FROM db_aws_lwt_tg_tim
                        WHERE db_aws_lwt_tg_tim.stn_id IN (515, 634, 637, 616)
                        AND db_aws_lwt_tg_tim.tma > '2016-03-31 23:00:00.0'
                        AND db_aws_lwt_tg_tim.tma < '2020-04-01 00:00:00.0'")

colnames(aws_lwt_tg)=gsub("db_aws_lwt_tg_tim.", "", colnames(aws_lwt_tg), ignore.case = T)
head(aws_lwt_tg)

write.csv(aws_lwt_tg, "aws_lwt_tg.csv", fileEncoding = "utf-8")



aws_prsr <- dbGetQuery(conn, "SELECT * FROM db_aws_prsr_tim
                        WHERE db_aws_prsr_tim.stn_id IN (515, 634, 637, 616)
                        AND db_aws_prsr_tim.tma > '2016-03-31 23:00:00.0'
                        AND db_aws_prsr_tim.tma < '2020-04-01 00:00:00.0'")

colnames(aws_prsr)=gsub("db_aws_prsr_tim.", "", colnames(aws_prsr), ignore.case = T)
head(aws_prsr)

write.csv(aws_prsr, "aws_prsr.csv", fileEncoding = "utf-8")



aws_rhm <- dbGetQuery(conn, "SELECT * FROM db_aws_rhm_tim
                        WHERE db_aws_rhm_tim.stn_id IN (515, 634, 637, 616)
                        AND db_aws_rhm_tim.tma > '2016-03-31 23:00:00.0'
                        AND db_aws_rhm_tim.tma < '2020-04-01 00:00:00.0'")

colnames(aws_rhm)=gsub("db_aws_rhm_tim.", "", colnames(aws_rhm), ignore.case = T)
head(aws_rhm)

write.csv(aws_rhm, "aws_rhm.csv", fileEncoding = "utf-8")




aws_rn <- dbGetQuery(conn, "SELECT * FROM db_aws_rn_tim
                        WHERE db_aws_rn_tim.stn_id IN (515, 634, 637, 616)
                        AND db_aws_rn_tim.tma > '2016-03-31 23:00:00.0'
                        AND db_aws_rn_tim.tma < '2020-04-01 00:00:00.0'")

colnames(aws_rn)=gsub("db_aws_rn_tim.", "", colnames(aws_rn), ignore.case = T)
head(aws_rn)

write.csv(aws_rn, "aws_rn.csv", fileEncoding = "utf-8")




aws_ta <- dbGetQuery(conn, "SELECT * FROM db_aws_ta_tim
                        WHERE db_aws_ta_tim.stn_id IN (515, 634, 637, 616)
                        AND db_aws_ta_tim.tma > '2016-03-31 23:00:00.0'
                        AND db_aws_ta_tim.tma < '2020-04-01 00:00:00.0'")

colnames(aws_ta)=gsub("db_aws_ta_tim.", "", colnames(aws_ta), ignore.case = T)
head(aws_ta)

write.csv(aws_ta, "aws_ta.csv", fileEncoding = "utf-8")



#aws_te<- dbGetQuery(conn, "SELECT * FROM db_aws_te_tim
#                        WHERE db_aws_te_tim.stn_id IN (515, 634, 637, 616)
#                        AND db_aws_te_tim.tma > '2016-03-31 23:00:00.0'
#                        AND db_aws_te_tim.tma < '2020-04-01 00:00:00.0'")
#
#colnames(aws_te)=gsub("db_aws_te_tim.", "", colnames(aws_te), ignore.case = T)
#head(aws_te)

#write.csv(aws_te, "aws_te.csv", fileEncoding = "utf-8")



#aws_ts<- dbGetQuery(conn, "SELECT * FROM db_aws_ts_tim
#                        WHERE db_aws_ts_tim.stn_id IN (515, 634, 637, 616)
#                        AND db_aws_ts_tim.tma > '2016-03-31 23:00:00.0'
#                        AND db_aws_ts_tim.tma < '2020-04-01 00:00:00.0'")
#
#colnames(aws_ts)=gsub("db_aws_ts_tim.", "", colnames(aws_ts), ignore.case = T)
#head(aws_ts)

#write.csv(aws_ts, "aws_ts.csv", fileEncoding = "utf-8")



aws_wind <- dbGetQuery(conn, "SELECT * FROM db_aws_wind_tim
                        WHERE db_aws_wind_tim.stn_id IN (515, 634, 637, 616)
                        AND db_aws_wind_tim.tma > '2016-03-31 23:00:00.0'
                        AND db_aws_wind_tim.tma < '2020-04-01 00:00:00.0'")

colnames(aws_wind)=gsub("db_aws_ta_tim.", "", colnames(aws_wind), ignore.case = T)
head(aws_wind)

write.csv(aws_wind, "aws_wind.csv", fileEncoding = "utf-8")


