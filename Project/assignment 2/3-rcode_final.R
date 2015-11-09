#after mysql treating
sample_1<-read.csv('data/no_referrers_2.csv')
sample_1$price_rate<-as.numeric(sample_1$price_rate)
sample_1$age<-as.numeric(sample_1$age)
#sample_1$capsule_text<-as.factor(sample_1$capsule_text)
#sample_1$shop_area<-as.factor(sample_1$shop_area)
sample_1$item_count<-as.numeric(sample_1$item_count)
sample_1[,6]<-as.numeric(sample_1[,6])

features = paste(names(sample_1[2:length(names(sample_1))-1]),collapse = "+") 
#features = paste(names(sample_1[2:5]),collapse = "+") 
formula_text <- paste(names(sample_1[1]),"~", features)
rn_train <- sample(nrow(sample_1), 
                   floor(nrow(sample_1)*0.8))
formula <- as.formula(formula_text)
train <- sample_1[rn_train,]
test <- sample_1[-rn_train,]

#fit <- lm(formula, data=train) 
fit <- glm(formula,data=train,family=binomial())
test$scores <- predict(fit, type="response", 
                      newdata=test)

pred<-prediction(test$scores, test$purchase_flag)
perf<-performance(pred,"tpr","fpr")
plot(perf, lty=1)

folds <- createFolds(sample_1$purchase_flag)
for (f in folds){
  train <- sample_1[-f,] 
  test <- sample_1[f,]

  fit <- glm(formula,data=train,family=binomial())
  test$scores <- predict(fit, type="response", 
                      newdata=test)
  pred<-prediction(test$scores, test$purchase_flag)
  c <- confusionMatrix(as.integer(test$scores > 0.2), 
                     test$purchase_flag)
  c$table


  #writes chart
  perf<-performance(pred,"tpr","fpr")
  plot_name = paste("output/RoC", f, ".png")
  png(filename=plot_name)
  plot(perf, lty=1)
  dev.off()

 
  


  }