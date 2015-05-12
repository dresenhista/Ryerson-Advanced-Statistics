tdata<-read.csv("pendigits.tra.csv", h=F)
testing_data<-read.csv("pendigits.tes.csv", h=F)
vector_names<-c("x1")
for(i in 2:16){
  vector_names<-rbind(vector_names, paste("x",i, sep=""))

}
vector_names<-rbind(vector_names, "class")
vector_names<-as.vector(vector_names)
names(tdata)<-vector_names
names(testing_data)<-vector_names
testing_data$class<-as.factor(testing_data$class)
tdata$class<-as.factor(tdata$class)
classifier <- IBk(class ~., data = tdata,
                  control = Weka_control(K = 5))
evaluate_Weka_classifier(classifier, testing_data)

classifier <- IBk(class ~., data = tdata,
                  control = Weka_control(K = 1))
evaluate_Weka_classifier(classifier, testing_data)
