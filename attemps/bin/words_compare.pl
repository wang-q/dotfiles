#!/usr/bin/perl
use strict;
use warnings;
use autodie;

use List::MoreUtils qw(uniq);
use Set::Scalar;
use File::Basename;

my $op = shift || "diff";

my $file1 = shift or die "Provide first file\n";
my $file2 = shift or die "Provide second file\n";

my $set1 = to_word_set( read_file($file1) );
my $set2 = to_word_set( read_file($file2) );

my $set_new;
if ( $op =~ /^dif/i ) {
    $set_new = $set1->difference($set2);
}
elsif ( $op =~ /^uni/i ) {
    $set_new = $set1->union($set2);
}
elsif ( $op =~ /^int/i ) {
    $set_new = $set1->intersection($set2);
}

my $out_file = sprintf "[%s].%s.[%s].txt", basename($file1), $op,
    basename($file2);
open my $out_fh, '>', $out_file;
for my $word ( sort $set_new->members ) {
    print {$out_fh} $word, "\n";
}
close $out_fh;

sub read_file {
    my $filename = shift;
    open my $in_fh, '<', $filename;
    my $content = do { local $/; <$in_fh> };
    close $in_fh;
    return $content;
}

sub to_word_set {
    my $string = shift;

    my @words = uniq( split /\s+/, $string );
    my $set = Set::Scalar->new(@words);

    return $set;
}

__END__

perl words_compare.pl diff mo.txt mo.20120319.txt