#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

use Path::Tiny;
use File::Find::Rule;
use Mojo::DOM;
use YAML qw(Dump Load DumpFile LoadFile);

# stratopan contains dynamic contents, Mojo::Useragent doesn't work
my $file = shift || '~/Scripts/tool/wangq_alignDB_master.html';
die "Provide a valid html file!\n" unless $file;

my $minicpan = shift || '~/minicpan';

my $batch = 30;

# find ~/minicpan -type f | perl -nl -e '/CHECKSUMS/ and next; s/^.*\.//; print' | sort | uniq
my @all_files = File::Find::Rule->file->name( "*.bz2", "*.gz", "*.tgz", "*.zip" )->in($minicpan);

my $html = path($file)->slurp;
my $dom  = Mojo::DOM->new($html);

# When installing modules in @found, cpanm will upgrade them automatically.
my (@found);
my ( @not_found, @dist, @manual );

for my $li ( $dom->find('li.dist')->each ) {

    # Bio-Phylo-0.55
    my ($name) = grep {defined} split /\n/, $li->find('span.dist-name')->map('text')->join("\n");

    # (RVOSA)
    my ($author) = map { s/^\(//; s/\)$//; $_ }
        grep {defined}
        split( /\n/, $li->find('span.dist-author')->map('text')->join("\n") );

    # Bio::Phylo~0.55
    my $pkgnames = $li->find('span.pkg-name')->map('text')->join("\n");
    $pkgnames =~ s/\~/-/g;
    $pkgnames =~ s/\:\:/-/g;
    $pkgnames =~ s/\n+/\n/g;

    # When dist name is the main pkgname, use pkgname.
    # libwww-perl is not fit this condition.
    my $module;
    if ( index( $pkgnames, $name ) != -1 ) {
        $module = $name;
        $module =~ s/\-.[v\d\._]+$//;
        $module =~ s/-/::/g;
    }

    my $fullname = "$author/$name";
    print $fullname, "\n";

    my @gzs = grep { index( $_, $fullname ) != -1 } @all_files;

    # bioperl related
    # and Win32
    if ( $fullname =~ /Bio|AlignDB|Win32/ ) {
        if ($module) {
            push @manual, $module;
        }
        else {
            push @manual, $fullname;
        }
    }

    # dists have representive module
    elsif ($module) {
        if ( @gzs == 0 ) {
            push @not_found, $module;
        }
        else {
            push @found, $module;
        }
    }

    #
    else {
        if ( @gzs == 0 ) {
            push @manual, $fullname;
        }
        else {
            my $str_idx = index $gzs[0], $fullname;
            my $dist_name = substr $gzs[0], $str_idx;
            push @dist, $dist_name;
        }
    }
}

# LWP does not recognize d:/minicpan
if ( $minicpan =~ /\:/ ) {
    $minicpan = 'file:///' . $minicpan;
}

open my $fh, '>', 'stpan.txt';

print {$fh} "# modules from minicpan\n";
while ( scalar @found ) {
    my @batching = splice @found, 0, $batch;
    print {$fh} "cpanm --verbose --mirror-only --mirror $minicpan @batching\n";
}
print {$fh} "\n";

print {$fh} "# modules from stratopan\n";
while ( scalar @not_found ) {
    my @batching = splice @not_found, 0, $batch;
    print {$fh}
        "cpanm --verbose --mirror-only --mirror https://stratopan.com/wangq/alignDB/master @batching\n";
}
print {$fh} "\n";

print {$fh} "# dists may be installed repeatedly.\n";
while ( scalar @dist ) {
    my @batching = splice @dist, 0, $batch;
    print {$fh} "cpanm --verbose --mirror-only --mirror $minicpan @batching\n";
}
print {$fh} "\n";

print {$fh} "# modules you should install manually\n";
for my $el (@manual) {
    print {$fh}
        "# cpanm --verbose --mirror-only --mirror https://stratopan.com/wangq/alignDB/master $el\n";
}
print {$fh} "\n";

close $fh;

__END__

# Windows
> cd /d d:\Scripts\tool
> perl stpan.pl wangq_alignDB_master.htm d:/minicpan
