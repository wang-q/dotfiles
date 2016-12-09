#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

use Getopt::Long::Descriptive;
use Path::Tiny;

#----------------------------------------------------------#
# GetOpt section
#----------------------------------------------------------#
my $description = <<'EOF';
egypt_dot.pl - Draw C functions calling graph with egypt and dot.

http://www.gson.org/egypt/

    cpanm http://www.gson.org/egypt/download/egypt-1.10.tar.gz

    make clean
    make CFLAGS=-fdump-rtl-expand CC=gcc-6
    egypt_dot.pl -d .
    rm *.dot *.expand

Usage: perl %c [options]
EOF

(
    #@type Getopt::Long::Descriptive::Opts
    my $opt,

    #@type Getopt::Long::Descriptive::Usage
    my $usage,
    )
    = Getopt::Long::Descriptive::describe_options(
    $description,
    [ 'help|h', 'display this message' ],
    [],
    [ 'dir|d=s',    'where to find the .expand files', { default => "." }, ],
    [ 'suffix|s=s', 'alternative suffix',              { default => ".expand" }, ],
    [ 'type|t=s',   'output file format',              { default => "png" } ],
    { show_defaults => 1, }
    );

$usage->die if $opt->{help};

if ( !path( $opt->{dir} )->is_dir ) {
    $usage->die( { pre_text => "The input dir [$opt->{dir}] doesn't exist." } );
}

#----------------------------------------------------------#
# run
#----------------------------------------------------------#

my $iter = path( $opt->{dir} )->iterator( { follow_symlinks => 0, } );
while (
    #@type Path::Tiny
    my $path = $iter->()
    )
{
    next unless $path->is_file;

    my $basename = $path->basename;
    my $suffix_index = index $basename, $opt->{suffix};
    next unless $suffix_index >= 0;
    $basename = substr $basename, 0, $suffix_index;

    print "Process $path\n";
    my $dot_file   = path( $opt->{dir}, $basename . '.dot' );
    my $graph_file = path( $opt->{dir}, $basename . ".$opt->{type}" );
    system "egypt $path > $dot_file";
    system "dot $dot_file -T$opt->{type} > $graph_file";
}

__END__
