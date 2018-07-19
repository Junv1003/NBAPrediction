

#实现递归特征消除（RFE）

# 
# install.packages('caret')
# library(caret)

#remove.packages(c('caret'),lib=file.path('C:\\Users\\QingZe\\AppData\\Local\\Temp\\RtmpyM85k1\\downloaded_packages'))







#多元回归

#读入数据
input <- read.csv('F:/RStudio/Boruta/17four.csv', header=T)
# input2 <-read.csv('F:/RStudio/Boruta/16four.csv', header=T)
# input3 <- read.csv('F:/RStudio/Boruta/15four.csv', header=T)
# input4 <- read.csv('F:/RStudio/Boruta/14four.csv', header=T)
# input5 <- read.csv('F:/RStudio/Boruta/13four.csv', header=T)


# input <- merge(input,input2,all = T)
# input <- merge(input,input3,all = T)
# input <- merge(input,input4,all = T)
# input <- merge(input,input5,all = T)

input <- input[,c(
  'TEAM',		'WINp','EFGp','FTA.RATE',	'TOVp','OREBp',	'OPP.EFGp','OPP.FTA.RATE','OPP.TOVp','OPP.OREBp'
)]

# Create the relationship model.
#eight factors
model8 <- lm(WINp~EFGp+FTA.RATE +TOVp+OREBp+OPP.EFGp+OPP.FTA.RATE +OPP.TOVp+OPP.OREBp, data = input)
print(model8)

#four factors
model4 <- lm(WINp~EFGp+FTA.RATE +TOVp+OREBp, data = input)
print(model4)


#boruta 
inputB <- data.frame(x1= input[,"EFGp"]*0.8,x2 = input[,"TOVp"]*0.6,x3 = input[,"OPP.EFGp"],x4 =input[,"OPP.TOVp"]*0.5 ,x5 = input[,"WINp"])
colnames(inputB) <- c("EFGp","TOVp","OPP.EFGp","OPP.TOVp","WINp")

modelB <- lm(WINp~EFGp +OPP.EFGp +TOVp+OPP.TOVp, data = inputB)
print(modelB)


#测试集
test <- read.csv('F:/RStudio/Boruta/18four.csv',header = T)

#测试结果
result8 <- predict(model8, newdata = test)
sort(result8,decreasing = T)


result4 <- predict(model4, newdata = test)
sort(result4,decreasing = T)

#boruta
 testB <- data.frame(x1= test[,"EFGp"]*0.8,x2 = test[,"TOVp"]*0.6,x3 = test[,"OPP.EFGp"],x4 =test[,"OPP.TOVp"]*0.5 ,x5 = test[,"WINp"])
 colnames(testB) <- c("EFGp","TOVp","OPP.EFGp","OPP.TOVp","WINp")
resultB <- predict(modelB, newdata = testB)
sort(resultB,decreasing = T)


#正确结果
print(test["WINp"])

#粗略估计

#保存eight factors 的结果
write.csv(result8,file = "F:/RStudio/Boruta/8result.csv" )


#季后赛模型
inoff <- read.csv('F:/RStudio/Boruta/17off.csv',header = T)
modeloff <- lm(WINp~EFGp+FTA.RATE +TOVp+OREBp+OPP.EFGp+OPP.FTA.RATE +OPP.TOVp+OPP.OREBp, data = inoff)
print(modeloff)

#测试，利用18年的常规赛数据
testoff <- read.csv('F:/RStudio/Boruta/18off.csv',header = T)
#测试结果
resultoff <- predict(modeloff, newdata = testoff)
sort(resultoff,decreasing = T)
#真实结果
trueRe <- read.csv('F:/RStudio/Boruta/18off.csv',header = T)
print(trueRe["TEAM"])







#测试1230场比赛的正确率
game <- read.csv('F:/RStudio/Boruta/2018RegularNUm.csv', header=T)
head(game)

#转换类型
game <- apply(game,2,as.numeric)




myfunc <- function(x,c1,c2,c3)
{
  
  # if (result[x[c1]]*0.6 >= result[x[c2]]*0.4 && x[c3] == 1) {
  #   #print("hi")
  #   return(1)
  # }
   if(abs(resultB[x[c1]]*0.6 - resultB[x[c2]]*0.4) < 0.1)
  {
    return(1)
   }
  else if(resultB[x[c1]]*0.6 >= resultB[x[c2]]*0.4 && x[c3] == 1)
    return(1)
  else
    return(0)
  #return(y)
  #test
  # print(sum(x[c1],x[c2]))
} 


ss<-apply(game,1,myfunc,c1="H",c2="V",c3="WIN")

as.data.frame(table(ss))

















