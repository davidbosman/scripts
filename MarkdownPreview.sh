#!/bin/bash
# Select the text written in Markdown within any text editor
# Invoque the script and the text'll be pasted in a temporary Markdown file, then parsed to HTML
# And previewed in Web browser.
# All header/footer files are optional (their only purpoe is to make thepage ,look sgood) comment them out if you don't care.
#
# require:
# Markdown
# xclip: sudo apt-get install xclip
#
# david@davidbosman.fr
# v0.1 - 21/03/2011

cat ~/Dropbox/perso/scripts/header.html  > /tmp/tmp.html;
pbpaste > /tmp/tmp.markdown;
~/Dropbox/perso/scripts/markdown.pl --html4tag /tmp/tmp.markdown >> /tmp/tmp.html ;
cat ~/Dropbox/perso/scripts/footer.html  >> /tmp/tmp.html;
open /tmp/tmp.html

