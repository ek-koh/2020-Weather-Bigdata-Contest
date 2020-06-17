from sklearn.preprocessing import StandardScaler
import pandas as pd

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