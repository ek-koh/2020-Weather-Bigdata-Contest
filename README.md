
# Weather-Bigdata-Contest
=======
# 2020-Weather-Bigdata-Contest
대용량 파일 문제로 2020-06-22부터 해당 repository 사용

## AWS 데이터 설명
### stn_id
- 운평 AWS : 37.084530,126.773890 - stn_id==515
- 아산 AWS : 36.845780,126.865360 - stn_id==634
- 신평 AWS : 36.893750,126.805583 - stn_id==637
- 당진 AWS : 36.889361,126.617389 - stn_id==616

## 기상 데이터 활용 csv, 컬럼명
- aws_prsr(기압)
  - avg_pa(평균 현지기압), avg_ps(평균 해면기압)
- aws_rn(강수)
  - hr1_rn(1시간 강수량)
- aws_ta(기온)
  - avg_ta(평균 기온)
- aws_wind(바람)
  - avg_ws(평균 풍속), max_ws(최대 풍속), max_ws_wd(최대 풍속 풍향), max_ins_ws(최대 순간 풍속), max_ins_ws_wd(최대 순간 풍속 풍향)
- sea_buoy(해상BUOY)
  - wd_n1(풍향 1), ws_n1(풍속 1), gust_ws_n1(돌풍 풍속 1), pa(현지 기압), hm(습도), ta(기온), max_wh(최대파고), avg_wh(평균파고)
  - hive_manual 156p 바탕으로 추정
- sea_lb(해상 등표)
  - wd(풍향), ws(풍속), max_ins_wd(최대 순간 풍향), max_iws(최대 순간 풍속), ta(기온), ps(해면기압), hm(습도)
  - hive_manual 바탕으로 추정


## LightGBM 성능 향상 idea
- 불균형한 데이터라서 재현율이 중요함.
- ** LightGBM 학습/예측/평가.**
  - boost_from_average가 True일 경우 레이블 값이 극도로 불균형 분포를 이루는 경우 재현률 및 ROC-AUC 성능이 매우 저하됨. LightGBM 2.1.0 이상 버전에서 이와 같은 현상 발생. 디폴트가 True.
  - Ex. `LGBMClassifier(n_estimators=1000, num_leaves=64, n_jobs=-1, boost_from_average=False)`
