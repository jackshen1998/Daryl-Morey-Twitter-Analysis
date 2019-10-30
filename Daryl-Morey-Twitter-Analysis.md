

```python
pip install tweepy
```

    Requirement already satisfied: tweepy in ./anaconda3/lib/python3.7/site-packages/tweepy-3.8.0-py3.7.egg (3.8.0)
    Requirement already satisfied: PySocks>=1.5.7 in ./anaconda3/lib/python3.7/site-packages (from tweepy) (1.7.0)
    Requirement already satisfied: requests-oauthlib>=0.7.0 in ./anaconda3/lib/python3.7/site-packages/requests_oauthlib-1.2.0-py3.7.egg (from tweepy) (1.2.0)
    Requirement already satisfied: requests>=2.11.1 in ./anaconda3/lib/python3.7/site-packages (from tweepy) (2.22.0)
    Requirement already satisfied: six>=1.10.0 in ./anaconda3/lib/python3.7/site-packages (from tweepy) (1.12.0)
    Requirement already satisfied: oauthlib>=3.0.0 in ./anaconda3/lib/python3.7/site-packages/oauthlib-3.1.0-py3.7.egg (from requests-oauthlib>=0.7.0->tweepy) (3.1.0)
    Requirement already satisfied: chardet<3.1.0,>=3.0.2 in ./anaconda3/lib/python3.7/site-packages (from requests>=2.11.1->tweepy) (3.0.4)
    Requirement already satisfied: certifi>=2017.4.17 in ./anaconda3/lib/python3.7/site-packages (from requests>=2.11.1->tweepy) (2019.6.16)
    Requirement already satisfied: idna<2.9,>=2.5 in ./anaconda3/lib/python3.7/site-packages (from requests>=2.11.1->tweepy) (2.8)
    Requirement already satisfied: urllib3!=1.25.0,!=1.25.1,<1.26,>=1.21.1 in ./anaconda3/lib/python3.7/site-packages (from requests>=2.11.1->tweepy) (1.24.2)
    Note: you may need to restart the kernel to use updated packages.



```python
import tweepy
import csv
```


```python
#API keys
consumer_key='i3QxNhXFRT81DSWhJvEzhEGYU'
consumer_secret='co0jS0zPHizi1SPhr9RFONob3b85YGoIToOHb5Rw6iLcpC4vVI'
access_token='2395085773-08sS5mNZpbRqVckwyRKsUNdujTIj6UjELhwSljm'
access_token_secret ='Qm0fLbieLajiCsntTcFPPxmiOovjHsZvRXIyjRrZ87y2s'
```


```python
#daryl morey twitter account
user = '@dmorey'
```


```python
#authentication
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth)
twitterData = api.get_user(user)
```


```python
#print basic info
print('Twitter user: ' + user)
print('Number of followers: ' + str(twitterData.followers_count))
print('Number of tweets: ' + str(twitterData.statuses_count))     
print('Favorites: ' + str(twitterData.favourites_count))
print('Friends: ' + str(twitterData.friends_count))
print('Appears on ' + str(twitterData.listed_count) + ' lists')
```

    Twitter user: @dmorey
    Number of followers: 239786
    Number of tweets: 9405
    Favorites: 6711
    Friends: 1720
    Appears on 3549 lists



```python
def get_all_tweets(screen_name):
	#Twitter only allows access to a users most recent 3240 tweets with this method
	
	#authorize twitter, initialize tweepy
	auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(access_token, access_token_secret)
	api = tweepy.API(auth)
	
	#initialize a list to hold all the tweepy Tweets
	alltweets = []	
	#make initial request for most recent tweets (200 is the maximum allowe
	new_tweets = api.user_timeline(screen_name = screen_name,count=200)
	oldest = new_tweets[-1].id
	while len(new_tweets) > 0:
		print("getting tweets before %s" % (oldest))
		
		#all subsiquent requests use the max_id param to prevent duplicates
		new_tweets = api.user_timeline(screen_name = screen_name,count=200,max_id=oldest)
		
		#save most recent tweets
		alltweets.extend(new_tweets)
		
		#update the id of the oldest tweet less one
		oldest = alltweets[-1].id - 1
		
		print("...%s tweets downloaded so far" % (len(alltweets)))
    
	new_tweets = api.user_timeline(screen_name = screen_name,count=200,max_id=oldest)
    
	while len(new_tweets) > 0:
		print("getting tweets before %s" % (oldest))
		
		#all subsiquent requests use the max_id param to prevent duplicates
		new_tweets = api.user_timeline(screen_name = screen_name,count=200,max_id=oldest)
		
		#save most recent tweets
		alltweets.extend(new_tweets)
		
		#update the id of the oldest tweet less one
		oldest = alltweets[-1].id - 1
		
		print("...%s tweets downloaded so far" % (len(alltweets)))
    
	#transform the tweepy tweets into a 2D array that will populate the csv	
	outtweets = [[tweet.id_str, tweet.created_at, tweet.text.encode("utf-8")] for tweet in alltweets]
	
	#write the csv	
	with open('%s_tweets.csv' % screen_name, 'w') as f:
		writer = csv.writer(f)
		writer.writerow(["id","created_at","text"])
		writer.writerows(outtweets)
	
	pass


if __name__ == '__main__':
	#pass in the username of the account you want to download
	get_all_tweets("dmorey")
```

    getting tweets before 1170922413334454274
    ...199 tweets downloaded so far
    getting tweets before 1160196759206932479
    ...399 tweets downloaded so far
    getting tweets before 1143221319946739711
    ...599 tweets downloaded so far
    getting tweets before 1120768099765182469
    ...799 tweets downloaded so far
    getting tweets before 1111766941650378751
    ...999 tweets downloaded so far
    getting tweets before 1101359218450415616
    ...1199 tweets downloaded so far
    getting tweets before 1088818602365669376
    ...1399 tweets downloaded so far
    getting tweets before 1073338952139137023
    ...1599 tweets downloaded so far
    getting tweets before 1050964370119897087
    ...1799 tweets downloaded so far
    getting tweets before 1035356183547314175
    ...1999 tweets downloaded so far
    getting tweets before 1015410103594336255
    ...2198 tweets downloaded so far
    getting tweets before 990291384753184768
    ...2398 tweets downloaded so far
    getting tweets before 979788034999836671
    ...2597 tweets downloaded so far
    getting tweets before 970449209844490239
    ...2797 tweets downloaded so far
    getting tweets before 962901137652318207
    ...2996 tweets downloaded so far
    getting tweets before 943240377611505670
    ...3000 tweets downloaded so far
    getting tweets before 943206557147418624
    ...3000 tweets downloaded so far

