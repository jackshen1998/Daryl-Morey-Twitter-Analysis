#change the date to timestamps
library(dplyr)
DF<-dmorey_tweets
DF$created_at<-as.POSIXct(DF$created_at)

#creat a heat map base on daily twitter activities
library("xts")
twitter=xts(rep(1,times=nrow(DF)),DF$created_at)
twitter.sum=apply.daily(twitter,sum)
DF1<-data.frame(date=index(twitter.sum),coredata(twitter.sum))
colnames(DF1)<-c("date", "sum")
calendarHeat(DF1$date,DF1$sum,varname = "@dmorey Twitter Activity")

#World Cloud most frequenly used keywords
library("tm")
mytext<-Corpus(VectorSource(DF$text))
mytext<-tm_map(mytext,content_transformer(tolower))
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
mytext<-tm_map(mytext,content_transformer(removeURL))
removert<-function(x) gsub("b'rt","",x)
mytext<-tm_map(mytext,content_transformer(removert))
Stopwords <- c(setdiff(stopwords('english'), c("r", "big")),
                 "use", "see", "used", "via", "amp")
mytext<-tm_map(mytext,removeWords,Stopwords)
mytext<-tm_map(mytext,stripWhitespace)
txt<-TermDocumentMatrix(mytext,control=list(wordlength=c(1,Inf)))
freq.term<-findFreqTerms(txt, lowfreq = 20)
t<-as.matrix(txt)
word.freq<-sort(rowSums(t), decreasing = T)
library(RColorBrewer)
pal<- brewer.pal(9,"BuGn")[-(1:4)]
library(wordcloud)
wordcloud(words = names(word.freq),freq = word.freq,min.freq = 5, random.order = F, colors = pal)

##