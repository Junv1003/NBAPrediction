from sklearn import svm
from sklearn.model_selection import cross_val_score
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import random
import os

#采用球队得分，球队PER,主客场胜率，教练胜率作为特征值 


def normalize(X):
    """Min-Max normalization     sklearn.preprocess 的MaxMinScalar
    Args:
        X: 样本集
    Returns:
        归一化后的样本集
    """
    m, n = X.shape

    # 归一化每一个特征
    for j in range(n):
        features = X[:,j]
        minVal = features.min(axis=0)
        maxVal = features.max(axis=0)
        diff = maxVal - minVal
        if diff != 0:
           X[:,j] = (features-minVal)/diff
        else:
           X[:,j] = 0
    return X

def pre_v1(trainset, testset):
    print("归一化")
    trainset = normalize(np.array(trainset))
    testset = normalize(np.array(testset))
    
    trainset_y = [item[-1] for item in trainset]
    trainset_x = []
    for item in trainset:
        item= np.delete(item, [8], axis=0)
        #item= np.delete(item, [16], axis=0)
        trainset_x.append(item)
    #print(trainset_x)

    testset_y = [item[-1] for item in testset]
    testset_x = []
    for item in testset:
        item= np.delete(item, [8], axis=0)
        #item= np.delete(item, [16], axis=0)
        testset_x.append(item)

    clf = svm.SVC()
    clf.fit(trainset_x, trainset_y)
    
    print("训练集准确率: {}".format(clf.score(trainset_x, trainset_y)))
    print("测试集准确率：{}".format(clf.score(testset_x, testset_y)))

def pre_v2(trainset, testset):
    trainset = np.array(trainset)
    testset = np.array(testset)
    
    trainset_y = [item[-1] for item in trainset]
    trainset_x = []
    for item in trainset:
        item= np.delete(item, [8], axis=0)
        #item= np.delete(item, [16], axis=0)
        trainset_x.append(item)
    #print(trainset_x)

    testset_y = [item[-1] for item in testset]
    testset_x = []
    for item in testset:
        item= np.delete(item, [8], axis=0)
        #item= np.delete(item, [16], axis=0)
        testset_x.append(item)

    clf = svm.SVC()
    clf.fit(trainset_x, trainset_y)
    
    print("训练集准确率: {}".format(clf.score(trainset_x, trainset_y)))
    print("测试集准确率：{}".format(clf.score(testset_x, testset_y)))


def main():
    trainset = pd.read_csv("data/2017dataset_v2.csv", usecols=[1,2,3,4,6,7,8,9,10])#HPTS,HP,HW,HC,VPTS,VP,VW,VC,RET
    testset = pd.read_csv("data/2018dataset_v2.csv", usecols=[1,2,3,4,6,7,8,9,10])

    # HFG,HFGA,H3P,H3Pp,HTRB,HP,HW,HC
    # VFG,VFGA,V3P,V3Pp,VTRB,VP,VW,VC
    # RET
    #trainset = pd.read_csv("data/2017dataset_v3.csv", usecols=[1,2,3,4,5,7,8,9,11,12,13,14,15,17,18,19,20])
    #testset = pd.read_csv("data/2018dataset_v3.csv", usecols=[1,2,3,4,5,7,8,9,11,12,13,14,15,17,18,19,20])
    
    pre_v2(trainset, testset)
    pre_v1(trainset, testset)

main()