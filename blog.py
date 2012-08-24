#!/usr/bin/python

'''
Take text from standard input in the format

  Title: Blog post title
  Keywords: key1, key2, etc

  Body of post after the first blank line.

and publish it to my WordPress blog. Return in standard output
the same post after publishing. It will then have more header
fields (see hFields for the list) and can be edited and re-
published again and again.

The goal is to work the same way TextMate's Blogging Bundle does
but with fewer headers.
'''  

import xmlrpclib
import sys
import os
from datetime import datetime, timedelta
import pytz

# Blog parameters (url, user, pw) are stored in ~/.blogrc.
# One parameter per line, with name and value separated by colon-space.
p = {}
with open(os.environ['HOME'] + '/.blogrc') as bloginfo:
  for line in bloginfo:
    k, v = line.split(': ')
    p[k] = v.strip()

# The header fields and their metaWeblog synonyms.
hFields = [ 'Title', 'Keywords', 'Date', 'Post',
            'Slug', 'Link', 'Status', 'Comments' ]
wpFields = [ 'title', 'mt_keywords', 'date_created_gmt',  'postid', 
             'wp_slug', 'link', 'post_status', 'mt_allow_comments' ]
h2wp = dict(zip(hFields, wpFields))         

def makeContent(header):
  "Make the content dict from the header dict."
  content = {}
  for k, v in header.items():
    content.update({h2wp[k]: v})
  content.update(description=body)
  return content

# Read and parse the source.
source = sys.stdin.read()
header, body = source.split('\n\n', 1)
header = dict( [ x.split(': ', 1) for x in header.split('\n') ])

# For uploading, the date must be in UTC and a DateTime instance.
utc = pytz.utc
myTZ = pytz.timezone('Europe/Paris')
if 'Date' in header:
  # Get the date from the string in the header.
  dt = datetime.strptime(header['Date'], "%Y-%m-%d %H:%M:%S")
  dt = myTZ.localize(dt)
  header['Date'] = xmlrpclib.DateTime(dt.astimezone(utc))
else:
  # Use the current date and time.
  dt = myTZ.localize(datetime.now())
  header.update({'Date': xmlrpclib.DateTime(dt.astimezone(utc))})

# Connect and upload the post.
blog = xmlrpclib.Server(p['url'])

if 'Post' in header:
  # Editing an old post.
  postID = int(header['Post'])
  del header['Post']
  content = makeContent(header)
  blog.metaWeblog.editPost(postID, p['user'], p['pw'], content, True)
else:
  # Publishing a new post.
  content = makeContent(header)
  postID = blog.metaWeblog.newPost(0, p['user'], p['pw'], content, True)

# Return the post as text in header/body format for possible editing.
post = blog.metaWeblog.getPost(postID, p['user'], p['pw'])
header = ''
for f in hFields:
  if f == 'Date':
    # Change the date from UTC to local and from DateTime to string.
    dt = datetime.strptime(post[h2wp[f]].value, "%Y%m%dT%H:%M:%S")
    dt = utc.localize(dt).astimezone(myTZ)
    header += "%s: %s\n" % (f, dt.strftime("%Y-%m-%d %H:%M:%S"))
  else:
    header += "%s: %s\n" % (f, post[h2wp[f]])
print header.encode('utf8')
print
print post['description'].encode('utf8')
