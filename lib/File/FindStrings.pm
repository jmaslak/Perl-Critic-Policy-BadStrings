#!/usr/bin/perl

#
# Copyright (C) 2017 Joelle Maslak
# All Rights Reserved - See License
#

package File::FindStrings v0.01.00;

use File::FindStrings::Boilerplate 'script';

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(find_words_in_file find_words_in_string);

# ABSTRACT: Finds strings within a file

=head1 SYNOPSIS

  use File::FindStrings qw(find_words_in_file);
  my (@matches) = find_words_in_file($file, 'foo', 'bar');

  foreach my $match (@matches) {
    my $line = $match->{line};
    my $word = $match->{word};
    print "Match on line $match for $word\n";
  }

=head1 DESCRIPTION

This module will locate lines that match one or more of a given set
of words (which are defined as strings that appear between word seperators).

=func find_words_in_file($file, @words)

Read file C<$file> on a line by line basis, checking each line for matches
on C<@words>.

If the file cannot be read, an exception is thrown.

A word will match if it appears in it's entirety on a single file line,
prefixed and suffixed by a word boundary (including the start or end of
line). The match is case-insenstive.

This returns a list of matches.  Each match is a hashref containing the
keys C<line> (line number) and C<word> (the matched word).

=cut

sub find_words_in_file ( $file, @words ) {
    my @return;

    open my $fh, '<', $file or die("Could not open file $file ($!)");

    my $lineno = 0;
    while ( my $line = <$fh> ) {
        $lineno++;

        foreach my $word (@words) {
            if ( $line =~ m/\b$word\b/gis ) {
                push @return, { word => $word, line => $lineno };
            }
        }
    }
    close $fh;

    return @return;
}

=func find_words_in_string($string, @words)

Searches C<$string> on a line by line basis, checking each line for matches
on C<@words>.

A word will match if it appears in it's entirety on a single line,
prefixed and suffixed by a word boundary (including the start or end of
line). The match is case-insenstive.

This returns a list of matches.  Each match is a hashref containing the
keys C<line> (line number) and C<word> (the matched word).

=cut

sub find_words_in_string ( $string, @words ) {
    my @return;

    my (@lines) = split /\n/, $string;

    my $lineno = 0;
    foreach my $line (@lines) {
        $lineno++;

        foreach my $word (@words) {
            if ( $line =~ m/\b$word\b/gis ) {
                push @return, { word => $word, line => $lineno };
            }
        }
    }

    return @return;
}

1;

