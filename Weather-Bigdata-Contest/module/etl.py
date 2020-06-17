from sklearn.preprocessing import StandardScaler
import pandas as pd
import os
from datetime import datetime as dt

def preprosess(data, caling_list=[], dummy_list=[]):
    """ 이 함수는 표준화와 원-핫 인코딩을 위한 코드
        data= 데이터프레임값
        caling_list = 스케줄링 해줄 변수들
        dummy_list = 원- 핫 인코딩 해줄 변수
    """
    # 파생변수를 스케줄링 해줌(표준화)
    caling_category = ['TEM_IN', 'HUM_IN', "TEM_COIL", "TEM_OUT_LOC1", "HUM_OUT_LOC1"]
    caling_category.extend(caling_list)
    print("caling_category:", caling_category)
    scaling_features = data[caling_category]
    scaler = StandardScaler()
    scaled_nd = scaler.fit_transform(scaling_features)
    scaled_df = pd.DataFrame(scaled_nd, columns=scaling_features.columns)
    data.drop(caling_category, axis=1, inplace=True)
    data = pd.concat([data, scaled_df], axis=1)

    # 원-핫 인코딩

    dummy_category = ["PLANT", "LOC"]
    dummy_category.extend(dummy_list)
    print("dummy_category:", dummy_category)
    data = pd.get_dummies(data, columns=dummy_category)

    return data



def makeValiation(data,model24,model48,test_X):
    """ 검증 데이터를 만들기 위한 함수입니다. 
    data = test_data 의 초기값을 넣어주어야 합니다.
    model24 = 24시간 후 모델값을 넣어 주어야 합니다.
    model48 = 48시간 후 모델값을 넣어 주어야 합니다.
    test_X = test_X 데이터를 넣어주면 됩니다.
    """
    
    validation = data[["MEA_DDHR","PLANT", "LOC", "X24H_TMA", "X48H_TMA"]]
    # 24시간 후 예측하기, 확률로 나누기
    predict24 = model24.predict(test_X)
    predict24_proba = model24.predict_proba(test_X)
    # 48시간 후 예측하기, 확률로 나누기
    predict48 = model48.predict(test_X)
    predict48_proba  = model48.predict_proba(test_X)
    # X24H_COND_LOC, X24H_COND_LOC_PROB, X48H_COND_LOC, X48H_COND_LOC_PROB
    validation["X24H_COND_LOC"] = predict24.astype(int)
    validation["X24H_COND_LOC_PROB"] = (predict24_proba[:,1]*100).astype(int)
    validation["X48H_COND_LOC"] = (predict48).astype(int)
    validation["X48H_COND_LOC_PROB"] = (predict48_proba[:,1]*100).astype(int)
    # 검증 형식 맞춰주기
    validation = validation[["MEA_DDHR","PLANT", "LOC", "X24H_TMA","X24H_COND_LOC", "X24H_COND_LOC_PROB", "X48H_TMA", "X48H_COND_LOC", "X48H_COND_LOC_PROB"]]
    return validation




def findCondRow(validation, num=24):
    """예측후 결로를 탐색해주는 함수 입니다.
       num = 24, 48, else 
       기본값은 24로 24시간 후 결로를 탐색해 줍니다.
       48 입력시 48시간 후 결로를 탐색해 줍니다.
       나머지 숫자는 24,48 의 공통 결로를 탐색해 줍니다.
    """
    if num == 24:
        data = validation.loc[validation["X24H_COND_LOC"] == 1]
    elif num == 48:
        data = validation.loc[validation["X48H_COND_LOC"] == 1]
    else:
        data = validation.loc[(validation["X24H_COND_LOC"] == 1) & (validation["X48H_COND_LOC"] == 1)]
    
    return data
    



def save_validation_csv(data, model_name):
    """모델 별로 저장해주는 함수 data 값과 저장 모델 명을 넣으면 된다 모델명은 문자열로 넣어 주어야 합니다."""
    save_path = "data/41.validation/"+model_name+"/"+str(dt.today().strftime("%Y%m%d%H%M%S"))
    if not os.path.isdir(save_path):
        os.mkdir(save_path)
    data.to_csv(save_path+"/203545.csv",index=False)
    
