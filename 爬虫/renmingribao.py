#!/usr/bin/python
# filename : tenxunnew.py
import Queue
initial_page = "http://news.qq.com/"
url_queue = Queue.Queue()
#Create a queue object with a given maximum size.If maxsize is <= 0, the queue size is infinite.
seen = set()
# new empty set object
seen.insert(initial_page)
seen.queue.put(initial_page)
while True:
	if url_queue.size()>0:
		current_url = url_queue.get()
# get one seq url
		store(current_url)
# all url
		for next_url in extract_urls(current_url):
			if next_url not in seen:
				seen.put(next_url)
				url_queue.put(next_url)
	else:
		break