import praw 
import random 
import time 
import re

#create reddit instance 


common_spammy_words = ['udemy','course','save','coupon','free','discount']

try: 
	reddit = praw.Reddit(client_id = 'xxxxxxxx',
					 client_secret ='xxxxx',
					 username ='xxx',
					 password ='xxxxx', 
					 user_agent ='rexxxxxxx')
except:
	print('connection error........')

DEBUG_MODE = True  #ford debug, don't post to redit just print 
debug_posted = [] #in debug mode, remember links 


def find_spam_by_name(search_query):
	authors = []
	cnt =1
	for submissions in reddit.subreddit("all").search(search_query,sort="new",limit = 11):
		print(str(cnt) +"-"+ submissions.title,submissions.author,submissions.url)
		if submissions.author not in authors:
			authors.append(submissions.author)
			cnt+=1 
	return authors


if __name__ =='__main__':
	while True:
		current_search_query = random.choice(['udemy'])
		spam_content = []
		trashy_users = {}
		smelly_authors  = find_spam_by_name(current_search_query)
		for author in smelly_authors:
			user_trahsy_urls = []
			sub_count = 0
			dirt_count = 0
			try: 
				for sub in reddit.redditor(str(author)).submissions.new():
					submit_links_to = sub.url 
					submit_id = sub.id 
					submit_subreddit = sub.subreddit 
					submit_title = sub.title 	
					dirty  = False
					for w in common_spammy_words:
						if w in submit_title.lower():
							dirty = True 
							junk  = [submit_id,submit_title]
							if junk not in user_trahsy_urls:
								user_trahsy_urls.append([submit_id,submit_title,str(author)])


				if dirty:
					dirt_count+=1
				sub_count+=1 


				try: 
					trashy_score = dirt_count/sub_count
				except: trashy_score = 0.0 
				print("User {} trashy score is : {}".format(str(author),round(trashy_score,3)))


				if trashy_score >= 0.5:
					trashy_users[str(author)] = [trashy_score,sub_count]

					for trash in user_trahsy_urls:
						spam_content.append(trash)
			

			except Exception as e:
				print(str(e))


		for spam in spam_content:
	            spam_id = spam[0]
	            spam_user = spam[2]
	            submission = reddit.submission(id=spam[0])
	            created_time = submission.created_utc
	            if time.time()-created_time <= 86400:
	                link = "https://reddit.com"+submission.permalink

	                message = """*Beep boop*

									I am a bot that sniffs out spammers, and this smells like spam.

									At least {}% out of the {} submissions from /u/{} appear to be for Udemy affiliate links. 

									Don't let spam take over Reddit! Throw it out!

									*Bee bop*""".format(round(trashy_users[spam_user][0]*100,2), trashy_users[spam_user][1], spam_user)

	                try:
	                	if DEBUG_MODE:
	                		if link in debug_posted:
                            continue
                        	print(f"Would've posted reply to post by {spam_user}: {link}")
	                        debug_posted.append(link)
	                        continue
	                    with open("posted_urls.txt","r") as f:
	                        already_posted = f.read().split('\n')
	                    if link not in already_posted:
	                        print(message)
	                        submission.reply(message)
	                        print("We've posted to {} and now we need to sleep for 12 minutes".format(link))
	                        with open("posted_urls.txt","a") as f:
	                            f.write(link+'\n')
	                        time.sleep(12*60)
	                        break
	                except Exception as e:
	                    print(str(e))
	                    time.sleep(12*60)

			
















