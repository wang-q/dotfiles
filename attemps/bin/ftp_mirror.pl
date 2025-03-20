#!/usr/bin/perl
use strict;
use warnings;

package FtpMirror;
use Moose;
with 'MooseX::Getopt';

use Net::FTP;
use File::Path;
use Cwd;

use FindBin;
use YAML qw(Dump Load DumpFile LoadFile);

use AlignDB::Run;

has 'server' => (
    is          => 'rw',
    isa         => 'Str',
    default     => 'ftp.ensembl.org',
    traits      => ['Getopt'],
    cmd_aliases => [qw{ s }],
);
has 'user' => (
    is          => 'rw',
    isa         => 'Str',
    default     => 'anonymous',
    traits      => ['Getopt'],
    cmd_aliases => [qw{ u }],
);
has 'pass' => (
    is          => 'rw',
    isa         => 'Str',
    default     => 'password',
    traits      => ['Getopt'],
    cmd_aliases => [qw{ p }],
);
has 'verbose' => (
    is          => 'rw',
    isa         => 'Bool',
    default     => 0,
    traits      => ['Getopt'],
    cmd_aliases => [qw{ v }],
);
has 'rdir' => (
    is            => 'rw',
    isa           => 'Str',
    default       => '/pub/release-60/fasta/saccharomyces_cerevisiae/',
    traits        => ['Getopt'],
    cmd_aliases   => [qw{ r }],
    documentation => "Remote dir",
);
has 'ldir' => (
    is            => 'rw',
    isa           => 'Str',
    default       => '.',
    traits        => ['Getopt'],
    cmd_aliases   => [qw{ l }],
    documentation => "Local dir",
);

has 'parallel' => (
    is            => 'rw',
    isa           => 'Int',
    default       => 5,
    traits        => ['Getopt'],
    cmd_aliases   => [qw{ p }],
    documentation => "Parallel downloading",
);
has 'dump' => (
    is            => 'rw',
    isa           => 'Str',
    default       => '',
    traits        => ['Getopt'],
    cmd_aliases   => [qw{ i }],
    documentation => "Use the dumpfile",
);
has 'outdump' => (
    is            => 'rw',
    isa           => 'Str',
    default       => '',
    traits        => ['Getopt'],
    cmd_aliases   => [qw{ o }],
    documentation => "Output filelist dumpfile",
);

has 'ftp' => (
    traits => ['NoGetopt'],
    is     => 'ro',
    isa    => 'Object',
);
has 'get' => (
    traits  => [ 'Array', 'NoGetopt' ],
    is      => 'rw',
    isa     => 'ArrayRef[Ref]',
    default => sub        { [] },
    handles => { add_get => 'push', },
);
has 'skip' => (
    traits  => [ 'Array', 'NoGetopt' ],
    is      => 'rw',
    isa     => 'ArrayRef[Ref]',
    default => sub        { [] },
    handles => { add_skip => 'push', },
);

#my $cmd = {
#    resume => '',
#};

sub BUILD {
    my $self = shift;

    chdir $self->ldir;

    return;
}

sub list {
    my $self = shift;

    my $ftp = Net::FTP->new(
        $self->server,
        Debug   => $self->verbose,
        Passive => 1,
    ) or die "Can't connect to server: $@";
    $ftp->login( $self->user, $self->pass )
        or die "Can't login: ", $ftp->message;

    $ftp->binary;
    $ftp->hash(1);

    $self->{ftp} = $ftp;

    $self->do_mirror;

    chdir $FindBin::Bin;
    DumpFile( $self->outdump, { get => $self->get, skip => $self->skip } );
    print "Filelist dumped as " . $self->outdump . "\n";

    return;
}

sub download {
    my $self = shift;

    my $list = LoadFile( $self->dump );
    $self->get( $list->{get} );
    $self->skip( $list->{skip} );

    my $worker = sub {
        my $job = shift;

        my $remote = $job->{remote} . "/" . $job->{file};
        my $local  = $job->{local} . "/" . $job->{file};
        my $cmd = "curl "    # use curl to download
                             #. " -v"           # verbose
            . " -s"          # silent
            . " -o $local"   # output filename with fullpath
            . " $remote"     # remote fullpath
            ;

        print $cmd, "\n";
        system $cmd;

        utime $job->{rtime}, $job->{rtime},
            $local;          # set local file's timestamp

        return;
    };

    my $run = AlignDB::Run->new(
        parallel => $self->parallel,
        jobs     => $self->get,
        code     => $worker,
    );
    $run->run;
}

sub DEMOLISH {
    my $self = shift;
    $self->ftp->quit;
    return;
}

# top-level entry point for mirroring.
sub do_mirror {
    my $self = shift;

    my $ftp  = $self->ftp;
    my $rdir = $self->rdir;

    return unless my $type = $self->find_type($rdir);

    my ( $prefix, $leaf ) = $rdir =~ m{^(.*?)([^/]+)/?$};
    $ftp->cwd($prefix) if $prefix;

    $self->outdump("$leaf.yml");

    return $self->get_file($leaf) if $type eq '-';    # ordinary file
    return $self->get_dir($leaf)  if $type eq 'd';    # directory

    warn "Don't know what to do with a file of type $type. Skipping.";
}

# subroutine to determine whether a path is a directory or a file
sub find_type {
    my $self = shift;
    my $path = shift;

    my $ftp  = $self->ftp;
    my $pwd  = $ftp->pwd;
    my $type = '-';                                   # assume plain file
    if ( $ftp->cwd($path) ) {
        $ftp->cwd($pwd);
        $type = 'd';
    }
    return $type;
}

# mirror a file
sub get_file {
    my $self = shift;
    my $path = shift;

    my $ftp = $self->ftp;
    my $remote
        = "ftp://"
        . $self->user . ":"
        . $self->pass . "@"
        . $self->server
        . $ftp->pwd;
    my $local = getcwd;

    my $rtime = $ftp->mdtm($path);
    my $rsize = $ftp->size($path);

    my ( $lsize, $ltime ) = stat($path) ? ( stat(_) )[ 7, 9 ] : ( 0, 0 );
    my $info = {
        remote => $remote,
        local  => $local,
        file   => $path,
        rtime  => $rtime
    };

    if (    defined($rtime)
        and defined($rsize)
        and ( $ltime >= $rtime )
        and ( $lsize == $rsize ) )
    {
        warn "Getting file $path: not newer than local copy.\n"
            if $self->verbose;
        $self->add_skip($info);
        return;
    }

    warn "Getting file $path\n" if $self->verbose;
    $self->add_get($info);
}

# mirror a directory, recursively
sub get_dir {
    my $self = shift;
    my $path = shift;

    my $ftp = $self->ftp;

    my $localpath = $path;
    -d $localpath or mkpath $localpath or die "mkpath failed: $!";
    chdir $localpath or die "can't chdir to $localpath: $!";

    my $cwd = $ftp->pwd or die "can't pwd: ", $ftp->message;
    $ftp->cwd($path) or die "can't cwd: ", $ftp->message;

    warn "Getting directory $path/\n" if $self->verbose;

    for ( $ftp->dir ) {
        next unless my ( $type, $name ) = $self->parse_listing($_);
        next if $name =~ /^(\.|\.\.)$/;    # skip . and ..
        $self->get_dir($name)  if $type eq 'd';
        $self->get_file($name) if $type eq '-';
    }

    $ftp->cwd($cwd) or die "can't cwd: ", $ftp->message;
    chdir '..';
}

# parse directory listings
# -rw-r--r--   1 root     root          312 Aug  1  1994 welcome.msg
sub parse_listing {
    my $self    = shift;
    my $listing = shift;
    return
        unless my ( $type, $name )
            = $listing =~ m{
                            ^([a-z-])[a-z-]{9}    # -rw-r--r--
                            \s+\d*                # 1
                            (?:\s+\w+){2}         # root root
                            \s+\d+                # 312
                            \s+\w+\s+\d+\s+[\d:]+ # Aug 1 1994
                            \s+(.+)               # welcome.msg
                            $
                            }x;
    return ( $type, $name );
}

1;

package main;

my $mirror = FtpMirror->new_with_options;

if ( $mirror->dump ) {
    die "Dumping file doesn't exist\n" unless -e $mirror->dump;
    $mirror->download;
}
else {
    $mirror->list;
}

__END__

Step 1: Get list of files and dump it to "saccharomyces_cerevisiae.yml"
perl ftp_mirror.pl -s ftp.ensembl.org -r /pub/release-60/fasta/saccharomyces_cerevisiae/ -l e:\data\ensembl60\ -v

Step 2: Use the default dumpfile and download files in parallel with curl
perl ftp_mirror.pl -i saccharomyces_cerevisiae.yml -p 8
