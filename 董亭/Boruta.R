
#引入包
library(Boruta)

#读入数据
predictors <- read.csv('F:/RStudio/Boruta/17four.csv', header=T)
predictors1 <- read.csv('F:/RStudio/Boruta/16four.csv', header=T)
predictors2 <- read.csv('F:/RStudio/Boruta/15four.csv', header=T)
predictors3 <- read.csv('F:/RStudio/Boruta/14four.csv', header=T)
predictors <- merge(predictors,predictors1,all = T)
predictors <- merge(predictors,predictors2,all = T)
predictors <- merge(predictors,predictors3,all = T)

#tag
#decision <- read.csv("F:/RStudio/Boruta/regular_tag.csv",header=T)
decision <- predictors[15]

#integrate  
NBAChara <- data.frame(predictors[6:14], decision = factor(decision[, 1]))

#boruta
set.seed(77)
Boruta.NBAChara <- Boruta(decision ~., data = NBAChara,doTrace = 2)

plot(Boruta.NBAChara)

#现在我们对实验性属性进行判定。
#实验性属性将通过比较属性的Z分数中位数和最佳阴影属性的Z分数中位数被归类为确认或拒绝
final.boruta <- TentativeRoughFix(Boruta.NBAChara)
print(final.boruta)

#默认情况下，由于缺乏空间，Boruta绘图功能添加属性值到横的X轴会导致所有的属性值都无法显示。
#在这里我把属性添加到直立的X轴。
plot(Boruta.NBAChara, xlab = "", xaxt = "n")
lz<-lapply(1:ncol(Boruta.NBAChara$ImpHistory),function(i)
  Boruta.NBAChara$ImpHistory[is.finite(Boruta.NBAChara$ImpHistory[,i]),i])
names(lz) <- colnames(Boruta.NBAChara$ImpHistory)  
Labels <- sort(sapply(lz,median))
axis(side = 1,las=2,labels = names(Labels),
     at = 1:ncol(Boruta.NBAChara$ImpHistory), cex.axis = 0.7)

#蓝色的盒状图对应一个阴影属性的最小、平均和最大Z分数。
#红色、黄色和绿色的盒状图分别代表拒绝、暂定和确认属性的Z分数。


#获取确认属性的列表
getSelectedAttributes(final.boruta, withTentative = F)

#创建一个来自Boruta最终结果的数据框架
boruta.df <-  attStats(final.boruta)


