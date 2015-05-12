#reading data
setwd("~/GitHub/Advanced_Methods/assigment 3")
data<-read.csv("winequality-red.csv", sep=";")


#Treating data names to look preety in our charts/analysis

data_names<-names(data)

simpleCap <- function(x) {
  
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

data_names<-as.vector(sapply(data_names, gsub, pattern="[.]", replacement = " "))
data_names<-as.vector(sapply(data_names, simpleCap))
#####################





#create multiples histograms
num_variables = length(data)-1

for(i in 1:num_variables){
  hist(data[,i], main =paste(data_names[i], "Histogram", sep = " "), xlab = paste(data_names[i], "Level", sep = " "))
  
}

#function that calculate the boxplot by rate for an specific variable using column name as arg
byrate_hist<-function(x, label){
  boxplot_string = ""
  x_label<-array()
  
  for(grade in 1:10){
    first_graph<-paste("data[data$quality==",grade, ",]$",x)
    boxplot_string = paste(boxplot_string, first_graph, ",")
    x_label[grade]<-paste("rate", grade)
  }
  first_string <-paste(boxplot_string, "main = '", label, "by Wine Rates'")
  
  lim_sup<-eval(parse(text = paste("max(data$", x,")*1.05")))
  lim_inf<-eval(parse(text = paste("min(data$", x,")*0.95")))
  
  second_string = paste("boxplot(", first_string, ", ylim=c(", lim_inf, ",", lim_sup,"), xlim=c(2.5,8.5))")
  
  test<-eval(parse(text =second_string))
  axis(1, 1:10,x_label)
  
}

#creating function that summarizes table

create_summary_table<-function (x) {
  median_alc<-aggregate(data[,x], list(data$quality), median)
  mean_alc<-aggregate(data[,x], list(data$quality), mean)
  min_alc<-aggregate(data[,x], list(data$quality), min)
  max_alc<-aggregate(data[,x], list(data$quality), max)
  sd_alc<-aggregate(data[,x], list(data$quality), sd)
  summary_table<-data.frame(median_alc, mean_alc[,2], min_alc[,2], max_alc[,2], sd_alc[,2])
  return(summary_table)
}

summary_table<-create_summary_table(7)
names(summary_table)<-c("Rates", "Mean", "Median", "Min", "Max", "Standard Deviation")
knitr::kable(summary_table, caption = "Total Sulfur Dioxide Summary")
byrate_hist("total.sulfur.dioxide", "Total level of So2")


#Doing the same for alcohol
summary_table_alc<-create_summary_table(11)
names(summary_table_alc)<-c("Rates", "Mean", "Median", "Min", "Max", "Standard Deviation")
byrate_hist("alcohol", "Total level of Alcohol")


table_cor<-cor(data)
table_cor<-data.frame(table_cor)
names_cor<-c("Acid", "Vol.Acid", "Citr.Acid", "Sugar", "Chlor", "FreeSO2", "TotalSo2", "Den", "pH", "Sulph", "Alchool", "Qlity")
names(table_cor)<-names_cor
rownames(table_cor)<-names_cor

######################################
##          PCA             ##########
######################################

pca <- prcomp(data[,1:11])
plot(pca, type ="l", main = "Principal Component Analysis")

summary_pca<-summary(pca)

percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}
t1<-percent(summary_pca$importance[2,])
t2<-percent(summary_pca$importance[3,])
variance_pca<-cbind(t1,t2)
colnames(variance_pca)<-c("PVE", "Accumulated PVE")
rnames<-array()
for(i in 1:11){
  rnames[i]<-paste("PC",i, sep = "")
}

rownames(variance_pca)<-rnames
variance_pca<-data.frame(variance_pca)



eigenvalues<-round(pca$sdev,2)
names<-data_names[1:11]
eigenvalues<-cbind(names, eigenvalues)
eigenvalues<-data.frame(eigenvalues)
names(eigenvalues)<-c("a", "b")
eigenvalues<-eigenvalues[with(eigenvalues, order(b)),]
names(eigenvalues)<-c("Variables", "EigenValues")
knitr::kable(eigenvalues, caption = "Eigenvalues", digits=2)