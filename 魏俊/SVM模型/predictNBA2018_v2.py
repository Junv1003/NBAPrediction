from sklearn import svm
from sklearn.model_selection import cross_val_score
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import random
import sys
import os

#采用球队得分，球队PER,主客场胜率，教练胜率作为特征值 

matches = pd.read_csv("../data/2018RegularSchedule.csv")

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
    #print(trainset[0])
    #print(testset[0])
    
    trainset_y = [item[-1] for item in trainset]
    trainset_x = []
    for item in trainset:
        item= np.delete(item, [4], axis=0)
        trainset_x.append(item)
    #print(trainset_x)

    testset_y = [item[-1] for item in testset]
    testset_x = []
    for item in testset:
        item= np.delete(item, [4], axis=0)
        testset_x.append(item)

    #print(testset_x[0].reshape(1, -1))

    clf = svm.SVC()
    clf.fit(trainset_x, trainset_y)
    
    print("训练集准确率: {}".format(clf.score(trainset_x, trainset_y)))
    #print("测试集准确率：{}".format(clf.score(testset_x, testset_y)))

    
    predictResult = pd.DataFrame(columns=['H', 'V', 'RET', 'PRE'])

    
    count = 0
    for i in range(len(testset_x)):
        sys.stdout.write("{}\r".format(i))
        vector = []
        vector.append(matches.loc[i]['H'])
        vector.append(matches.loc[i]['V'])
        vector.append(testset_y[i])
        pre = clf.predict(testset_x[i].reshape(1, -1))
        if pre == testset_y[i]:
            count += 1
        vector.append(pre[0])
        predictResult.loc[i] = vector
    print("预测准确率：{}".format(count/len(testset_x)))
    predictResult.to_csv("../data/2018regular_predict.csv", encoding='gbk', index=False)
    print("结果写入文件")
    


def pre_v2(trainset, testset):
    trainset = np.array(trainset)
    testset = np.array(testset)
    
    trainset_y = [item[-1] for item in trainset]
    trainset_x = []
    for item in trainset:
        item= np.delete(item, [6], axis=0)
        trainset_x.append(item)
    #print(trainset_x)

    testset_y = [item[-1] for item in testset]
    testset_x = []
    for item in testset:
        item= np.delete(item, [6], axis=0)
        testset_x.append(item)

    clf = svm.SVC()
    clf.fit(trainset_x, trainset_y)
    
    print("训练集准确率: {}".format(clf.score(trainset_x, trainset_y)))
    print("测试集准确率：{}".format(clf.score(testset_x, testset_y)))


def main():
    trainset = pd.read_csv("../data/2017dataset_v2.csv", usecols=[2,4,7,9,10])#HP,HC,VP,VC,RET
    testset = pd.read_csv("../data/2018dataset_v2.csv", usecols=[2,4,7,9,10])
    pre_v2(trainset, testset)
    pre_v1(trainset, testset)

main()