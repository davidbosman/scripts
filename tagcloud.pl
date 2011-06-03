#!/usr/bin/perl -w
use strict;

use HTML::TagCloud;
use HTML::Entities;
use utf8;

# Dirt-simple web server - displays the tag cloud, and the set of all
# notes that match a given tag, if provided.  Also accepts requests to
# search the notes, showing highlighted results.
{
  package MyWebServer;

  use HTTP::Server::Simple::CGI;
  use base qw(HTTP::Server::Simple::CGI);
 
  sub handle_request {
	my $self = shift;
	my $cgi  = shift;
	return if !ref $cgi;

	# Print out the headers, html, the tag cloud, and the search form.
	#print "HTTP/1.0 200 OK\r\nContent-Encoding : UTF-8\r\n", $cgi->header, $cgi->start_html("Tag Cloud");
        print "HTTP/1.0 200 OK\r\n", $cgi->header, $cgi->start_html("Tag Cloud");
        # $cgi->encoding("UTF-8"), Content-Encoding : UTF-8\r\n
	print $main::cloud->html_and_css();

	print $cgi->start_form(),
	  "<p align=\"right\"> Chercher dans toutes les notes : ",
	$cgi->textfield('search_string'),
	  $cgi->submit(-value => 'Chercher'), $cgi->end_form(),
		"<br><i>(La recherche n'est pas sensible é&agrave; la casse)</i><p>";

	print "<hr>";

	# Now do something interesting with your params, if any.

	my $tag = $cgi->param('tag');
	my $search_string = $cgi->param('search_string');

	if ($search_string) {	# Display search results
	  my $output;

	  # Perform same HTML encoding on the search string that we did on
	  # the notes, so that searching for things like "<" will work.
	  $search_string = HTML::Entities::encode($search_string);

	  print $cgi->h1("Notes correspondantes &agrave; \"$search_string\"");

	  # A little ugly: We're going to grep thru @all_notes looking for
	  # a match - but we need to strip the HTML markup (which we've
	  # added to turn tags into links) out of the notes before checking
	  # for a match, so that you don't match inside the HTML markup
	  # while searching.  Also, you need to use a temp var, because
	  # otherwise grep will modify $_.	Finally, use \Q (quotemeta) -
	  # we don't want full patterns here, too much risk
	  foreach (grep {my $t; ($t=$_) =~ s/<.*?>//g;
					 $t =~ /\Q$search_string/i}
			   @main::all_notes) {

		# We want to highlight the match in yellow, but not change the
		# saved copy of the note - so we work on a copy, $output.
		#
		# Regex to (roughly) match an HTML tag:	 <.*?>
		#
		# This s/// matches either an entire tag, or our search
		# string.  The replacement bit is executed (/e): if $2 (our
		# search string) has matched, wrap it in yellow.
		# Otherwise, $1 (a tag) is what matched, and it gets
		# replaced with itself.
		#
		# The /e is used instead of just saying "$1$2" (with $2 wrapped
		# in yellow) because that produces endless warnings about use
		# of undefined values - because only one of the two alternates
		# is ever defined in the replacement bit.

		($output = $_) =~ s{(<.*?>)|($search_string)}
{$2 ? "<b><FONT style=\"BACKGROUND-COLOR: yellow\">$2</FONT></b>" : $1}eig;
		print $output, "<p>";
	  }

	} elsif ($tag) {		# Display notes that match "$tag"
	  print $cgi->h1("Notes tagged with \"$tag\"");
	  foreach my $ref (@{$main::lines{$tag}}) {
		print $$ref, "<p>";
	  }
	}
	print $cgi->end_html;
  }
} # End of web server class
 
############
# Begin Here
############

# Parse the notes file, locating tags at the end of entries and
# building up two data structures.
#
# Both of these structures collect "notes," references in %lines and
# the actual scalar in @all_notes, which contains a note ready for
# display in our HTML output.  First, these notes have had HTML
# elements encoded to simplify processing and make it harder to do
# nasty things to the user's browser.  Then the tags at the end of the
# lines have been turned into links, same as are used in the tag
# cloud, to enhance navigation.
#
# %lines
#  foo => [
#		   "note ref (tagged with foo)",
#		   "another note ref (tagged with foo)",
#			...
#		  ]
#
# @all_notes - arrary of the set of all notes refered to in %lines -
# in other words, every note found.	 Used in searching.

our %lines;
our @all_notes;

# URL used in constructing tag-links
my $url = '?tag=';

# Parse notes file
{
  local $/ = "\n\n"; # Double-newline separates input records
  while (<>) {
	# Need a copy of the "note" to work on and refer to, and we need
	# it with HTML chars like <, >, etc, escaped to "&lt;", "&gt;",
	# etc.
	my $this_line = HTML::Entities::encode($_);

	# Pop words off the end of the note, processing them as tags as
	# long as they start with "@".	Keep a list of these tags so that
	# we can wrap them in href's when we're done picking them out.
	my @words = split;
	my @tags = (); # tags found at the end of this note
	while (my $tag = pop @words) {
	  last if $tag !~ /^\@/; # Not a tag, bail
	  $tag =~ s/^@//; # Trim the "@"
	  push @tags, $tag;
	  push (@{$lines{$tag}}, \$this_line);
	}

	foreach my $tag (@tags) {
	  # Greedy match in $1 insures that $2 will be the last instance
	  # of $tag in the note - in other words, the one on the end with
	  # the "@" prefix.	 And we know that each $tag was parsed off the
	  # end of this note, insuring this works.
	  $this_line =~ s|(.*)\b($tag)\b|$1<a href="$url$2">$2</a>|;
	}

	push @all_notes, $this_line;
  }
}

# Build tag cloud 
our $cloud = HTML::TagCloud->new(levels => 24);
foreach my $tag (keys %lines) {
  $cloud->add($tag, $url.$tag, scalar @{$lines{$tag}});
}

# Start an instance of MyWebServer on port 8080, only bind to localhost
my $pid = MyWebServer->new(8080);
$pid->host('localhost');
$pid->run();

#            Copyright (c) 2008, Dan McDonald. All Rights Reserved.
#        This program is free software. It may be used, redistributed
#        and/or modified under the terms of the Perl Artistic License
#             (see http://www.perl.com/perl/misc/Artistic.html)
