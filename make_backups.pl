#!/usr/bin/perl
use strict;
use warnings;
use autodie;

use Getopt::Long qw(HelpMessage);
use YAML qw(Dump Load DumpFile LoadFile);

use Path::Tiny;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

#----------------------------------------------------------#
# GetOpt section
#----------------------------------------------------------#

=head1 NAME

make_backups.pl - Backup directories and files in your machine

=head1 SYNOPSIS

    perl make_backups.pl [options] [file ...]
      Options:
        --help          -?          brief help message
        --backup_dir    -d  STR     where to store backup files, default values are
                                    [d:/software/Backup/PC] on PC and
                                    [~/software/Backup/Mac] on Mac

=cut

GetOptions(
    'help|?'  => sub { HelpMessage(0) },
    'dir|d=s' => \my $backup_dir,
) or HelpMessage(1);

#----------------------------------------------------------#
# directories and files
#----------------------------------------------------------#
my %backup_of;

if ( $^O eq 'MSWin32' ) {
    if ( !$backup_dir ) {
        $backup_dir = path( 'd:\\', 'software', 'Backup', 'PC' )->stringify;
    }

    printf "====> Backup %s, dir is [%s] <====\n\n", "PC", $backup_dir;

    %backup_of = (
        strawberry => {
            dir    => [ path('C:\strawberry'), ],
            action => sub {
                print "Clean useless files in Perl directory...\n";
            },
            delete => [
                path('C:\strawberry\cpan\build'), path('C:\strawberry\cpan\sources\authors\id'),
                path('C:\strawberry\perl\html'),  path('C:\strawberry\perl\man'),
            ],
        },

        Firefox => { dir => [ path( $ENV{APPDATA}, 'Mozilla' ) ], },

        ActiveState => {
            dir  => [ path( $ENV{LOCALAPPDATA}, 'ActiveState' ) ],
            file => [ path( $ENV{APPDATA},      'ActiveState', 'ActiveState.lic' ) ],
        },

        dots => {
            dir  => [ path( $ENV{USERPROFILE}, '.crossftp' ), path( $ENV{USERPROFILE}, '.vim' ) ],
            file => [
                path( $ENV{USERPROFILE}, '.gitconfig' ),
                path( $ENV{USERPROFILE}, '_vimrc' ),
                path( $ENV{USERPROFILE}, '_vimperatorrc' ),
            ],
        },

        Scripts => { dir => [ path( 'd:\\', 'Scripts' ), ], },

        zotero => { dir => [ path( 'd:\\', 'zotero' ), ], },

        ultraedit => {
            dir => [
                path( 'c:\\',        'Program Files (x86)', 'IDM Computer Solutions' ),
                path( $ENV{APPDATA}, 'IDMComp' ),
            ],
        },

        beyondcompare => {
            dir => [
                path( 'c:\\',        'Program Files (x86)', 'Beyond Compare 3' ),
                path( $ENV{APPDATA}, 'Scooter Software' ),
            ],
        },

        Launchy => { dir => [ path( $ENV{APPDATA}, 'Launchy' ) ], },
        XShell  => { dir => [ path( $ENV{APPDATA}, 'NetSarang' ) ], },

        StartMenu => {
            dir => [
                path( $ENV{ProgramData}, 'Microsoft', 'Windows', 'Start Menu' ),
                path( $ENV{APPDATA},     'Microsoft', 'Windows', 'Start Menu' ),
            ],
        },

        bioinfo => {
            dir => [
                path('c:\Tools\clustalw1.83.XP'), path('c:\Tools\HYPHY'),
                path('c:\Tools\muscle'),          path('c:\Tools\paml'),
                path('c:\Tools\PAUP'),            path('c:\Tools\phylip'),
                path('c:\Tools\Primer3'),         path('c:\Tools\ProSeq'),
            ],
        },

        #SlickEdit => {
        #    dir => [
        #        path( $ENV{USERPROFILE}, 'Documents',    'My SlickEdit Config' ),
        #        path( $ENV{USERPROFILE}, 'My Documents', 'My SlickEdit Config' ),
        #    ],
        #},

        #NetProxy => {
        #    dir => [
        #        path('c:\Tools\CCProxy'),  path('c:\Tools\FreeCap'),
        #        path('c:\Tools\mproxy12'), path('c:\Tools\QQWry'),
        #    ],
        #    file => [ path('c:\proxy.pac') ],
        #    reg  => {
        #        freecap      => q{"HKEY_CURRENT_USER\Software\Bert's Software"},
        #        fc_uninstall => q{"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows}
        #            . q{\CurrentVersion\Uninstall\FreeCap_is1"},
        #    },
        #},

    );
}
elsif ( $^O eq 'darwin' ) {
    if ( !$backup_dir ) {
        $backup_dir = path( $ENV{HOME}, 'software', 'Backup', 'Mac' )->stringify;
    }

    printf "====> Backup %s, dir is [%s] <====\n\n", "Mac", $backup_dir;

    %backup_of = (

        package_list => {
            action => sub {
                print " " x 4, "Generate package list files\n";
                system "brew tap > $ENV{HOME}/brew_tap.txt";
                system "brew list > $ENV{HOME}/brew_list.txt";
                system "brew cask list > $ENV{HOME}/brew_cask_list.txt";
                system "pip list > $ENV{HOME}/pip_list.txt";
                system qq{ls \$(Rscript -e 'cat(.Library)') > $ENV{HOME}/r_list.txt};
                system qq{ls \$(Rscript -e 'cat(.Library.site)') >> $ENV{HOME}/r_list.txt};
                system qq{sort -u -o $ENV{HOME}/r_list.txt $ENV{HOME}/r_list.txt};
                system "tlmgr list --only-installed > $ENV{HOME}/tlmgr_list.txt";
                system "apm list --installed > $ENV{HOME}/atom_list.txt";
            },
            file => [
                path( $ENV{HOME}, 'brew_tap.txt' ),
                path( $ENV{HOME}, 'brew_list.txt' ),
                path( $ENV{HOME}, 'brew_cask_list.txt' ),
                path( $ENV{HOME}, 'pip_list.txt' ),
                path( $ENV{HOME}, 'r_list.txt' ),
                path( $ENV{HOME}, 'tlmgr_list.txt' ),
                path( $ENV{HOME}, 'atom_list.txt' ),
            ],
            post_action => sub {
                print " " x 4, "Clean package list files\n";
                system
                    q{find ~ -name "*.txt"  -mmin -5 -type f -maxdepth 1 | parallel --no-run-if-empty rm};
            },
        },

        Firefox => { dir => [ path( $ENV{HOME}, 'Library', 'Application Support', 'Firefox' ), ], },

        ActiveState => {
            dir => [
                path( $ENV{HOME}, 'Library', 'Application Support', 'KomodoIDE' ),
                path( $ENV{HOME}, 'Library', 'Application Support', 'Komodo IDE' ),
                path( $ENV{HOME}, 'Library', 'Application Support', 'ActiveState' ),
            ],
            file => [
                path(
                    $ENV{HOME}, 'Library', 'Application Support', 'ActiveState',
                    'ActiveState.lic'
                ),
            ],
        },

        dots => {
            dir => [
                path( $ENV{HOME}, '.crossftp' ),
                path( $ENV{HOME}, '.parallel' ),
                path( $ENV{HOME}, '.vim' ),
                path( $ENV{HOME}, '.vimperator' ),
            ],
            file => [
                path( $ENV{HOME}, '.bash_profile' ),
                path( $ENV{HOME}, '.bashrc' ),
                path( $ENV{HOME}, '.gitconfig' ),
                path( $ENV{HOME}, '.ncbirc' ),
                path( $ENV{HOME}, '.wgetrc' ),
                path( $ENV{HOME}, '.screenrc' ),
                path( $ENV{HOME}, '.vimrc' ),
                path( $ENV{HOME}, '.vimperatorrc' ),
            ],
        },

        settings => {
            file => [
                path( $ENV{HOME}, 'Library', 'Spelling',    'LocalDictionary' ),
                path( $ENV{HOME}, 'Library', 'Preferences', 'com.apple.Terminal.plist' ),
            ],
        },

        Scripts => { dir => [ path( $ENV{HOME}, 'Scripts' ), ], },

        zotero => { dir => [ path( $ENV{HOME}, 'zotero' ), ], },

        ultraedit => {
            dir => [
                path( '/Applications', 'UltraEdit.app' ),
                path( $ENV{HOME}, 'Library', 'Application Support', 'UltraEdit' ),
            ],
        },

        beyondcompare => {
            dir => [
                path( '/Applications', 'Beyond Compare.app' ),
                path( $ENV{HOME}, 'Library', 'Application Support', 'Beyond Compare' ),
            ],
        },
    );
}
else {
    warn "PC and Mac only\n";
    exit 1;
}

#----------------------------------------------------------#
# Start
#----------------------------------------------------------#
BACKUP: for my $key ( keys %backup_of ) {
    my $zipped_file = path( $backup_dir, "$key.zip" );
    if ( $zipped_file->is_file ) {
        print "==> $zipped_file already exists, skip it\n\n";
        next BACKUP;
    }

    print "==> Start backuping [$key] as $zipped_file\n";

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
            next unless $del->exists;
            if ( !$del->is_dir ) {
                warn "$del is not a directory!\n";
                warn "Stop backuping [$key]\n";
                next BACKUP;
            }
            print "Delete directory tree $del\n";
            $del->remove_tree;
        }
    }

    # backup directories
    if ( exists $backup_of{$key}->{dir} ) {
        for my $dir ( @{ $backup_of{$key}->{dir} } ) {
            if ( !$dir->is_dir ) {
                warn "$dir is not a directory!\n";
                warn "Stop backuping [$dir]\n";
                next;
            }
            print "Add directory tree $dir to archive\n";
            $zip->addTree( "$dir", $dir->basename );    # stringify
        }
    }

    # backup files
    if ( exists $backup_of{$key}->{file} ) {
        for my $file ( @{ $backup_of{$key}->{file} } ) {
            if ( !$file->is_file ) {
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

    # execute actions post backup
    if ( exists $backup_of{$key}->{post_action} ) {
        print "Execute post actions of [$key]\n";
        $backup_of{$key}->{post_action}->();
    }

    print "==> Finish backuping [$key]\n\n";
}

exit;

__END__
