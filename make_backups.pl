#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use Config::Tiny;
use YAML qw(Dump Load DumpFile LoadFile);

use Path::Class;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

#----------------------------------------------------------#
# GetOpt section
#----------------------------------------------------------#

my $backup_dir = 'd:\Software\AppData';

my $man  = 0;
my $help = 0;

GetOptions(
    'help|?' => \$help,
    'man'    => \$man,
    'd|dir'  => \$backup_dir,
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -exitstatus => 0, -verbose => 2 ) if $man;

#----------------------------------------------------------#
# directories to be backuped
#----------------------------------------------------------#
my %backup_of = (

    strawberry => {
        dir    => [ dir('C:\strawberry'), ],
        action => sub {
            print "Clean useless files in Perl directory...\n";
        },
        delete => [
            dir('C:\strawberry\cpan\build'),
            dir('C:\strawberry\cpan\sources\authors\id'),
            dir('C:\strawberry\perl\html'),
            dir('C:\strawberry\perl\man'),
        ],
    },

    Mozilla     => { dir => [ dir( $ENV{APPDATA}, 'Mozilla' ) ], },
    ActiveState => {
        dir => [ dir( $ENV{LOCALAPPDATA}, 'ActiveState' ) ],
        file => [ file( $ENV{APPDATA}, 'ActiveState', 'ActiveState.lic' ) ],
    },

    Launchy       => { dir => [ dir( $ENV{APPDATA}, 'Launchy' ) ], },
    BeyondCompare => { dir => [ dir( $ENV{APPDATA}, 'Scooter Software' ) ], },
    XShell        => { dir => [ dir( $ENV{APPDATA}, 'NetSarang' ) ], },

    dots => {
        dir  => [ dir( $ENV{USERPROFILE}, '.crossftp' ) ],
        file => [
            file( $ENV{USERPROFILE}, '.bash_history' ),
            file( $ENV{USERPROFILE}, '.gitconfig' ),
            file( $ENV{USERPROFILE}, '.gtkrc-2.0' ),
            file( $ENV{USERPROFILE}, '.minicpanrc' ),
            file( $ENV{USERPROFILE}, '.perldl_hist' ),
            file( $ENV{USERPROFILE}, '.recently-used.xbel' ),
            file( $ENV{USERPROFILE}, '_vimrc' ),
        ],
    },

    SlickEdit => {
        dir => [
            dir( $ENV{USERPROFILE}, 'Documents',    'My SlickEdit Config' ),
            dir( $ENV{USERPROFILE}, 'My Documents', 'My SlickEdit Config' ),
        ],
    },
    StartMenu => {
        dir => [
            dir( $ENV{ProgramData}, 'Microsoft', 'Windows', 'Start Menu' ),
            dir( $ENV{APPDATA},     'Microsoft', 'Windows', 'Start Menu' ),
        ],
    },

    Scripts => { dir => [ dir('d:\wq\Scripts') ], },
    zotero  => { dir => [ dir('d:\zotero') ], },

    bioinfo => {
        dir => [
            dir('c:\Tools\clustalw1.83.XP'), dir('c:\Tools\clustalx1.81'),
            dir('c:\Tools\HYPHY'),           dir('c:\Tools\muscle'),
            dir('c:\Tools\paml'),            dir('c:\Tools\PAUP'),
            dir('c:\Tools\phylip'),          dir('c:\Tools\Primer3'),
            dir('c:\Tools\ProSeq'),          dir('c:\Tools\readseq'),
        ],
    },
    NetProxy => {
        dir => [
            dir('c:\Tools\CCProxy'),  dir('c:\Tools\FreeCap'),
            dir('c:\Tools\mproxy12'), dir('c:\Tools\QQWry'),
        ],
        file => [ file('c:\proxy.pac') ],
        reg  => {
            freecap      => q{"HKEY_CURRENT_USER\Software\Bert's Software"},
            fc_uninstall => q{"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows}
                . q{\CurrentVersion\Uninstall\FreeCap_is1"},
        },
    },

    #vcs => { dir => [ dir('D:\Tools\Git'), dir('D:\Tools\subversion'), ], },
    #VanDyke     => { dir => [ dir( $ENV{APPDATA}, 'VanDyke' ) ], },
    #freeime  => { dir => [ dir('D:\Tools\freeime') ], },
    #Perforce => { dir => [ dir('D:\Tools\Perforce') ], },
    #EverNote => {
    #    dir =>
    #        [ dir( $ENV{USERPROFILE}, 'Documents', 'My EverNote Files' ), ],
    #},
    #FlashFXP => {
    #    dir =>
    #        [ dir( $ENV{ALLUSERSPROFILE}, 'Application Data', 'FlashFXP' ) ],
    #},
    #ultraedit => {
    #    dir => [
    #        dir( $ENV{APPDATA}, 'IDMComp' ),
    #        dir('D:\Program Files\IDM Computer Solutions\UltraEdit'),
    #    ],
    #},
);

#----------------------------------------------------------#
# Start
#----------------------------------------------------------#
BACKUP: for my $key ( keys %backup_of ) {
    my $zipped_file = file( $backup_dir, "$key.zip" );
    if ( -e $zipped_file ) {
        print "=== $zipped_file already exists, skip it\n\n";
        next BACKUP;
    }

    print "=== Start backuping [$key] as $zipped_file\n";

    my $zip = Archive::Zip->new;
    my @temp_files;

    # execute actions before backup
    if ( exists $backup_of{$key}->{action} ) {
        print "Execute actions of [$key]\n";
        $backup_of{$key}->{action}->();
    }

    # export registry entry to .reg files
    if ( exists $backup_of{$key}->{reg} ) {
        print "Export registry of [$key]\n";
        my $reg = $backup_of{$key}->{reg};
        for my $regkey ( keys %$reg ) {
            my $reg_file    = "$regkey.reg";
            my $regkey_path = $reg->{$regkey};
            my $cmd         = "regedit /e $reg_file $regkey_path";
            print $cmd, "\n";
            system $cmd;

            push @temp_files, $reg_file;
            $zip->addFile($reg_file);
        }
    }

    # delete directories
    if ( exists $backup_of{$key}->{delete} ) {
        for my $del ( @{ $backup_of{$key}->{delete} } ) {
            next if !-e $del;
            if ( !-d $del ) {
                warn "$del is not a directory!\n";
                warn "Stop backuping [$key]\n";
                next BACKUP;
            }
            print "Delete directory tree $del\n";
            $del->rmtree;
        }
    }

    # backup directories
    if ( exists $backup_of{$key}->{dir} ) {
        for my $dir ( @{ $backup_of{$key}->{dir} } ) {
            if ( !-d $dir ) {
                warn "$dir is not a directory!\n";
                warn "Stop backuping [$dir]\n";
                next;
            }
            print "Add directory tree $dir to archive\n";
            $zip->addTree( "$dir", $dir->dir_list(-1) );    # stringify
        }
    }

    # backup files
    if ( exists $backup_of{$key}->{file} ) {
        for my $file ( @{ $backup_of{$key}->{file} } ) {
            if ( !-e $file ) {
                warn "$file does not exist!\n";
                warn "Stop backuping [$file]\n";
                next;
            }
            print "Add file $file to archive\n";
            $zip->addFile( "$file", $file->basename );    # stringify
        }
    }

    # comments attached to the archive
    $backup_of{$key}->{time} = scalar localtime;
    $zip->zipfileComment( "Backup comments:\n" . Dump $backup_of{$key} );

    # write backup file to disks
    unless ( $zip->writeToFileNamed("$zipped_file") == AZ_OK ) {
        die "write error\n";
    }

    # clear temporary files
    for (@temp_files) {
        unlink $_;
    }

    print "=== Finish backuping [$key]\n\n";
}

exit;

__END__

=head1 NAME

make_backups.pl - Backup directories and files in your machine

=head1 SYNOPSIS

perl make_backups.pl [options] [file ...]
  Options:
    --help              brief help message
    --man               full documentation
    -d, --backup_dir    where to store backup files

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> will read the given input file(s) and do someting
useful with the contents thereof.

=cut
