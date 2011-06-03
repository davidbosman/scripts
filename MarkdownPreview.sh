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
# davidATdavidbosman.fr
# v0.1 - 21/03/2011

cat ~/Dropbox/perso/scripts/headerTux.html  > /tmp/tmp.html;
xclip -o > /tmp/tmp.markdown;
markdown --html4tag /tmp/tmp.markdown >> /tmp/tmp.html ;
# pandoc -s /tmp/tmp.markdown -o /tmp/tmp.html ;
# multimarkdown /tmp/tmp.markdown > /tmp/tmp2.html ;
cat ~/Dropbox/perso/scripts/footer.html  >> /tmp/tmp.html;
firefox /tmp/tmp.html

