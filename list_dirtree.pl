#!/usr/bin/perl
use strict;
use warnings;

use Template;
use File::Spec;

my $dirpath = shift || '.';
$dirpath = File::Spec->rel2abs($dirpath);
my $level = scalar File::Spec->splitdir($dirpath);

my $tt = Template->new( { EVAL_PERL => 1, } );
$tt->process(
    \*DATA,
    {   dirpath => $dirpath,
        level   => $level,
    }
) or die Template->error;

__END__
[% USE dir = Directory(dirpath) -%]
[% INCLUDE dir %]
[% BLOCK dir -%]
+-[% '[' _ dir.name _ ']' %]
[% FOREACH f = dir.files -%]
[% NEXT IF f.name.match('~') -%]
[% NEXT IF f.name.match('\.bak') -%]
[% PERL %]
    use Number::Format qw(:subs);
    my $fullpath = $stash->get('f.path');
    my $wc_result = `wc $fullpath`;
    my ($lines, $words, $bytes, $name) = grep { $_ } split /\s+/, $wc_result;
    if (-B $fullpath) {
        $stash->set('f.lines' => "Binary");
    }
    else {
        $stash->set('f.lines' => "$lines lines");
    }
    $stash->set('f.bytes' => format_bytes($bytes));
    
    # calc tailing spaces
    my (undef, $dirs, $file) = File::Spec->splitpath($fullpath);
    my $cur_level = scalar(File::Spec->splitdir($dirs)) - $stash->get('level');
    my $tailing = (50 - length($file) - 4 * $cur_level - 2);
    $tailing = ' ' x $tailing;
    $stash->set('f.tailing' => $tailing);
[% END -%]
[% f.name FILTER format('    |-%s') -%]
[% f.tailing -%]
[% f.lines FILTER format('|%12s') -%]
[% f.bytes FILTER format(' |%10s') %]
[% END -%]
[% FOREACH f = dir.dirs -%]
[% f.scan -%]
[% INCLUDE dir dir=f FILTER indent(4) -%]
[% END -%]
[% END -%]
