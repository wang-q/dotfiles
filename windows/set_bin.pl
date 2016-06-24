#!/usr/bin/perl
use strict;
use warnings;

use List::MoreUtils qw(uniq);
use Win32;
use Win32::Env;

# check admin rights
# On Windows vista and 7, you should run this script as Administrator
print Win32::GetOSDisplayName(), "\n\n";
if ( Win32::IsAdminUser() ) {
    print "Got admin rights, continue.\n\n";
}
else {
    print "Your should get admin rights first to run this script.\n\n";
    exit 1;
}

# Other bin paths in c:\tools
my $add = {
    PATH => [
        qw{
            c:\tools\bin
            c:\tools\blast\bin
            c:\tools\muscle
            c:\tools\mafft
            c:\tools\paml\bin
            c:\tools\Primer3
            c:\tools\graphviz\bin
            c:\tools\gnuplot\bin
            c:\tools\gs\bin
            c:\tools\miktex\miktex\bin
            c:\tools\mysql\bin
            c:\tools\mongodb\bin
            c:\tools\Git\cmd
            c:\tools\CMake\bin
            c:\tools\ImageMagick
            c:\tools\vim
            c:\tools\packer
            c:\tools\putty
            c:\tools\R\bin
            c:\tools\Vagrant\bin
            }
    ],
};

# Actually do things
add($add) and print "Set bin paths\n";

# Pass a hashref to this sub.
# The key-value pairs are env keys and values.
# When the value is an arrayref, the content will be appended to existing
# values. When the value is a string, the content will be write directly to
# the env variable, overwriting existing one.
sub add {
    my $dispatch = shift;

    for my $key ( sort keys %$dispatch ) {
        my $value = $dispatch->{$key};
        if ( ref $value eq 'ARRAY' ) {
            my @exists;
            eval { @exists = split /;/, GetEnv( ENV_SYSTEM, $key ); };
            print $@, "\n" if $@;
            for my $add (@$value) {
                @exists = grep { lc $add ne lc $_ } @exists;
                push @exists, $add;
            }
            @exists = uniq(@exists);
            SetEnv( ENV_SYSTEM, $key, join( ';', @exists ) );
        }
        else {
            SetEnv( ENV_SYSTEM, $key, $value );
        }
    }

    return 1;
}
