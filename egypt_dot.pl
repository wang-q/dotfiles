#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;

use Path::Class;

#----------------------------------------------------------#
# GetOpt section
#----------------------------------------------------------#
my $dir    = '.';
my $suffix = '.expand';
my $type   = 'png';

my $man  = 0;
my $help = 0;

GetOptions(
    'help|?'     => \$help,
    'man'        => \$man,
    'd|dir=s'    => \$dir,
    's|suffix=s' => \$suffix,
    't|type=s'   => \$type,
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -exitstatus => 0, -verbose => 2 ) if $man;

#----------------------------------------------------------#
# run
#----------------------------------------------------------#
$dir = dir($dir)->absolute;
while ( my $file = $dir->next ) {
    next unless -f $file;

    my $basename = $file->basename;
    my $suffix_index = index $basename, $suffix;
    next unless $suffix_index >= 0;
    $basename = substr $basename, 0, $suffix_index;

    print "Process $file\n";
    my $dot_file   = file( $dir, $basename . '.dot' );
    my $graph_file = file( $dir, $basename . ".$type" );
    system "egypt $file > $dot_file";
    system "dot $dot_file -T$type > $graph_file";
}

__END__

=head1 NAME

egypt_dot.pl - Draw C functions calling graph with egypt and dot

=head1 SYNOPSIS

    perl egypt_dot.pl [options] [file ...]
      Options:
        --help              brief help message
        --man               full documentation
        -d, --dir           where to find the .c.01.rtl files
        -s, --suffix        alternative suffix (GCC 4)
        -t, --type          output file format (.png)

    make clean
    make CFLAGS=-fdump-rtl-expand
    perl ~/Scripts/tool/egypt_dot.pl -d .
    
=cut

=head1 egypt

http://www.gson.org/egypt/

cpanm http://www.gson.org/egypt/download/egypt-1.10.tar.gz

=cut
