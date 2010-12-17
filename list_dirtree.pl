#!/usr/bin/perl
use strict;
use warnings;

use Template;

my $dirpath = shift || '.';

my %VARS = ( dirpath => $dirpath, );

my $tt = Template->new( { EVAL_PERL => 1, } );
$tt->process( \*DATA, \%VARS ) or die Template->error;

__END__
[% USE dir = Directory(dirpath) -%]
[% INCLUDE dir %]
[% BLOCK dir -%]
+- [% dir.name %]/
[% FOREACH f = dir.files -%]
[% NEXT IF f.name.match('~') -%]
[% NEXT IF f.name.match('\.bak') -%]
[% NEXT IF f.name.match('\.xls') -%]
[% NEXT IF f.name.match('\.fas') -%]
[% NEXT IF f.name.match('\.png') -%]
[% NEXT IF f.name.match('\.tif') -%]
[% NEXT IF f.name.match('\.jpg') -%]
[% NEXT IF f.name.match('\.vsd') -%]
    |- [% f.name -%]
[% PERL %]
    if ( $^O ne 'Win32') {
        use Number::Format qw(:subs);
        my $fullpath = $stash->get('f.path');
        my $wc_result = `wc $fullpath`;
        my ($lines, $words, $bytes, $name) = grep { $_ } split /\s+/, $wc_result;
        print " | $lines lines  | ", format_bytes($bytes);
    }
[% END %]
[% END -%]
[% FOREACH f = dir.dirs -%]
[% f.scan -%]
[% INCLUDE dir dir=f FILTER indent(4) -%]
[% END -%]
[% END -%]
