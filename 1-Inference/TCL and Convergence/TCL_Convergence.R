k=100 #number of replication
n= 40 #vector size
lambda = 0.2 #lambda

list_of_exponential = array(1:k) #vector that will receive each mean

#loop to generate the means
for(i in 1:k){
  list_of_exponential[i] = mean(rexp(n, lambda))
}

#calculate x_bar mean and st
mean_of_average = mean(list_of_exponential)
sd_mean = sd(list_of_exponential)

#theorical st
std<-((1/lambda)/sqrt(k))

#plot histogram
hist(list_of_exponential, ylim = c(0, 0.8),freq= FALSE, col = "blue", main = "Histogram of simulated mean", xlab = "mean of exponential")
curve(dnorm(x, mean=5, sd=sd_mean), 
      col="red",  add=TRUE)