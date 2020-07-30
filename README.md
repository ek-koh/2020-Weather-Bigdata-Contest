# 공장 내 철강 제품의 결로 발생 예측 모형 개발
- `데송이들`팀 (고은경, 박건우, 이득규)의 2020 날씨 빅데이터 콘테스트 Repository입니다.
- 본 프로젝트는 Python을 활용한 Machine Learning 프로젝트이며, 현대제철과 기상청에서 제공하는 데이터를 활용하여 데이터분석을 수행하였습니다.
- 실제 [대회](https://bd.kma.go.kr/contest/)에 제출한 분석 코드 및 데이터는 [Weather-Bigdata-Contest](https://github.com/gwooop/2020-Weather-Bigdata-Contest/tree/master/Weather-Bigdata-Contest) 디렉토리 내에 위치해 있습니다.

## 활용데이터 정의  

### 활용데이터 개요
![image](https://user-images.githubusercontent.com/58713684/88915407-2d4ee680-d29f-11ea-8590-75bbcf678630.png)  

### 기상데이터 상세
- AWS : 4개 지점 (운평, 아산, 신평, 당진) 평균  

- ASOS : 서산 지점  

- 해양데이터
  - BUOY : 덕적도 지점
  - 등표 : 서수도 지점  
  
- 하늘상태(sky) 데이터
  - 초단기실황 (2016-04-01 00:00 ~ 2018-10-15 01:00)
  - ASOS : 서산 지점 (2018-10-15 02:00 ~ 2019-12-31 23:00) 및 홍성 지점 (2020-01-01 00:00 ~ 2020-03-31 23:00)
    
    용어|운량|SKY(하늘상태)
    ---|---|---
    맑음|0/10 ~ 2/10|1
    구름조금|3/10 ~ 5/10|2
    구름많음|6/10 ~ 8/10|3
    흐림|9/10 ~ 10/10|4
  
### E-R Diagram

![image](https://user-images.githubusercontent.com/58713684/88915927-1bba0e80-d2a0-11ea-869f-01c1cd4cece6.png)


## 파생변수
- 이슬점
- 실내외 온도차 (내부대기온도 - 외부대기온도)
- 내부대기 / 코일 온도차
- 데이터 시계열 특성 : MONTH
- 각 요인별 최대 / 최소

## Normalization & UnderSampling
- Normalization
  - 범주형 변수인 PLANT(공장위치), LOC(공장내부위치), MONTH(월) SKY(하늘상태)에 대해서는 **One-Hot Encoding**을 수행하였습니다.
  - 위 4개 외 수치형 변수에 대해서는 **스케줄링**을 수행하였습니다.
- UnderSampling
  - 본 데이터는 결로 발생이 전체의 0.57%인 **비대칭 데이터**이므로, 다수 클래스 데이터인 결로 미발생 데이터에서 일부만을 사용하는 언더샘플링을 수행하였습니다.
  - 재현율(Recall)이 가장 높았던 **Random Under-Sampler**를 채택하였습니다.

## Model
- 주 활용 모델
  - XGBoost (eXtreme Gradient Boosting)
  - LightGBM
  - SVM (Support Vector Machine)
- 이 외에 Random Forest, CatBoost, Ensemble 또한 분석과정에서 적용해 보았습니다.

## 중요 변수 도출
- XGBoost, LightGBM을 24시간, 48시간 각각에 대해 적용하여 Feature Importance를 도출했습니다.
- 그 결과 네 가지 경우에서 공통적으로 상위에 랭크된 변수, 즉 결로 발생에 주된 영향을 주는 것으로 나타난 변수들은 다음과 같습니다.
  - IN_COIL_TEM_D (내부대기 / 코일 온도차)
  - HUM_IN_MAX (내부습도 최댓값)
  - HUM_IN (내부습도)
  - LB_MAX_INS_WD (등표최대순간풍향)
  - LB_WD (등표풍향)
