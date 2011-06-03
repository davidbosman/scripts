#!/usr/bin/python
# Re: http://www.boingboing.net/2008/08/12/anyone-got-a-good-te.html
# Dear Cory,

#      Here is an attempt to implement exactly what you asked for.
# Here's how it works: 
# 1. Save this file as cd.py.
# 2. Change the variable note_file to point to your notes:

note_file = "/Users/david/Dropbox/perso/Archives/2010-notes.mdtxt"

# yep, right there.  
# 3. run the program: python cd.py.
  
# 4. Point a browser to http://localhost:14020, and you'll have a tag 
# cloud and a full-text search.  

# When you change the notes, the program should automatically detect this
# and update its database.  

# Don't worry about saving the database at all -- as long as you have a
# copy of the notes, you can recreate it. 

# --
# -David Turner

# P.S.  This program is free software.  You can distribute it under
# the terms of the GNU General Public License version 3 or, at your
# option, any later version.

# P.P.S. A technical note: this uses only core python,
# intentionally. It would have been easier and better to do things
# using a RDBMS -- even sqlite -- but I wasn't sure that sqlite was
# going to be available.  It would ahve been cleaner to use some
# framework for web programming other than SimpleHTTPServer, which is
# pretty grim.  But my goal was ease of installation, so I chose this
# path.

max_tag_size = 220

import BaseHTTPServer
from SimpleHTTPServer import SimpleHTTPRequestHandler

import anydbm
import os
import re
import sys
import urllib
import urlparse
from sha import sha

non_letters_re = re.compile("\W")
def letters_only(word):
    return non_letters_re.sub('', word)


class CDRequestHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        regenerate()
        if self.path.startswith("/search"):
            self.send_response(200)
            self.end_headers()
            path = self.path
            params = urlparse.urlparse(path)[4]
            params = dict(arg.split("=") for arg in params.split("&"))
            search_str = urllib.unquote_plus(params['search'])
            search_results = self.search(search_str)
            self.wfile.write(search_results)
        else:
            return SimpleHTTPRequestHandler.do_GET(self)


    def search(self, search_str):
        inwords = search_str.split(" ")
        words = []
        for word in inwords:
            words += word.split("-")
        words = (letters_only(word).lower() for word in words)

        print "search for", words
        db = anydbm.open('index', 'r')
        stopwords = set(db['.stopwords'].split(","))
        nodes_found = None
        for word in words:
            if word in stopwords:
                continue
            if not word in db:
                nodes_found = []
                break
            else:
                results = set(db[word].split(","))
                if nodes_found is None:
                    nodes_found = results
                else:
                    nodes_found = nodes_found.intersection(results)
        
        if not nodes_found:
            return "nothing"

        result = ""
        for node in nodes_found:
            f = open("note-%s.html" % node, "r")
            result += f.read()
            f.close()
        return result



def run(server_class=BaseHTTPServer.HTTPServer,
        handler_class=CDRequestHandler):
    server_address = ('localhost', 14020)
    httpd = server_class(server_address, handler_class)

    print "Now visit http://localhost:14020"
    httpd.serve_forever()


max_id = 1
tag_re = re.compile("(?<!\S)@(\S+)")
class Note:
    def __init__(self, note):
        parts = set()
        tags = set()
        for word in note.split():
            if word.startswith("@"):
                tags.add(word[1:].lower())
                parts.add(word[1:].lower())
                continue
            for part in word.split("-"):
                if not part:
                    continue
                part = letters_only(part).lower()
                parts.add(part)
        self.words = parts
        self.tags = tags
        self.text = note
        global max_id
        self.id = str(max_id)
        max_id += 1

    def to_html(self):
        def tag_link(tag):
            tag = tag.group(1)
            return '<a href="tag-%s.html">@%s</a>' % (tag, tag)
        text = tag_re.sub(tag_link, self.text)
        return "<p>%s</p>" % text

    def write_note_file(self):
        f = open("note-%s.html" % self.id, "w")
        f.write(self.to_html())
        f.close()


def parse_notes(note_file):
    f = open(note_file, "r")
    notes = []
    cur_note = []
    for line in f:
        #the delimter for a note is a blank line
        if line and not line.isspace():
            cur_note.append(line)
        else:
            if cur_note:
                notes.append(Note("".join(cur_note)))
                cur_note = []
        
    if cur_note:
        notes.append(Note("".join(cur_note)))
        
    return notes
        



def collect_tags(notes, field='tags'):
    tags = {}
    for note in notes:
        note_tags = getattr(note, field)
        for tag in note_tags:
            if not tag in tags:
                tags[tag] = []
            tags[tag].append(note)
    return tags

def mtime(fname):
    return os.stat(fname)[7]

def regenerate():
    global note_file
    if os.path.exists('index.html') and mtime('index.html') >= mtime(note_file):
        return

    notes = parse_notes(note_file)
    for note in notes:
        note.write_note_file()

    max_notes_per_tag = 0
    tags = collect_tags(notes)
    for tag, tagged_notes in tags.items():
        f = open("tag-%s.html" % tag, "w")
        f.write("<html><head><title>Notes</title><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head><h3>%s</h3>" % tag)
        for note in tagged_notes:
            f.write(note.to_html())
            
        max_notes_per_tag = max(max_notes_per_tag, len(tagged_notes))
        f.close()

    html_tags = []
    for tag, tagged_notes in tags.items():
        size = ((max_tag_size * len(tagged_notes)) / max_notes_per_tag) + 15
        html_tag = '<a href="tag-%s.html" style="font-size:%d%%">%s</span> ' % (tag, size, tag)
        html_tags.append(html_tag)
    cloud = "".join(html_tags)

    #now, a tag cloud
    f = open("index.html", "w")
    f.write("""
<html><head>
<title>Notes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<form action="/search">Search: <input name="search" type="text"> 
<input type="submit" name="submit" value="Go">
</form>
<br/>
%s
</body>
</html>
""" % cloud)

    stopword_threshold = len(notes) / 3
    words = collect_tags(notes, 'words')
    db = anydbm.open('index', 'n')
    db['.stopwords'] = ''
    for word, word_notes in sorted(words.items()):

        if len(word_notes) > stopword_threshold:
            db['.stopwords'] += "," + word
            continue

        db[word] = ",".join([note.id for note in word_notes])
    db.close()


note_file = os.path.abspath(note_file)

base = os.path.dirname(__file__)
if base:
    base += "/data"
else:
    base = "data"

try:
    os.mkdir(base)
except OSError:
    pass #exists, probably
os.chdir(base)

run()
