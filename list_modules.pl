#!/usr/bin/perl
use strict;
use warnings;

use CPAN;
use ExtUtils::Installed;
use Module::CoreList;
use Set::Scalar;

use List::MoreUtils qw(uniq);
use CPANDB ();
use String::Compare;
use Graph;

use YAML qw(Dump Load DumpFile LoadFile);

#----------------------------------------------------------#
# Loading CPAN and CPANDB
#----------------------------------------------------------#
$|++;

# force reload index
CPAN::HandleConfig->load;
CPAN::Shell::setup_output;
CPAN::Index->force_reload;

# Load the database and fine the distribution
CPANDB->import( { show_progress => 1, } );

#----------------------------------------------------------#
# Loading core and installed modules
#----------------------------------------------------------#
my $cpan_count = CPANDB::Distribution->count;

my ( $dual_dists, $all_dists );

{    # find core modules
    my @cores = Module::CoreList->find_modules(qr/./);
    @cores = merge_modules(@cores);
    my @dual_dists = grep { defined $_ } map { module2dist($_) } @cores;

    $dual_dists = Set::Scalar->new(@dual_dists);
    print "Find ", $dual_dists->size, " core modules\n";
}

{    # find installed modules
    print "Reading local .packlists\n";
    my $inst    = ExtUtils::Installed->new;
    my @modules = $inst->modules;
    @modules = merge_modules(@modules);
    my @dists = grep { defined $_ } map { module2dist($_) } @modules;

    $all_dists = Set::Scalar->new(@dists);
    $all_dists = $all_dists->difference($dual_dists);
    my $all_count = $all_dists->size;
    print "Find ", $all_count, " installed modules\n";
    printf "  that is %.2f%% of cpan (%d in total)\n",
        100 * $all_count / $cpan_count, $cpan_count;
}

# one of CGI.pm dependencies, FCGI, isn't in core
$dual_dists->delete("CGI.pm");
$all_dists->insert("CGI.pm");

gen_cmd( $dual_dists, "dual life" );

#----------------------------------------------------------#
# Every categories
#----------------------------------------------------------#
{
    my $dists = Set::Scalar->new(
        qw{ Test-Assert Test-Assertions Test-Base
            Test-Block Test-Class Test-ClassAPI Test-Compile Test-Deep
            Test-Differences Test-Exception Test-LongString Test-Memory-Cycle
            Test-Manifest Test-MockObject Test-Most Test-NoWarnings
            Test-Output Test-Perl-Critic Test-Pod Test-Pod-Coverage
            Test-Script Test-TempDir Test-Tester Test-Unit-Lite Test-Warn
            Test-use-ok }
    );
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "test" );
}

{
    my $dists = Set::Scalar->new;
    for my $i ( $all_dists->members ) {
        if ( $i =~ /^(Math|Stat|Crypt|Digest|PDL)/i ) {
            $dists->insert($i);
        }
    }
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "math" );
}

{
    my $dists = Set::Scalar->new(qw{ Any-Moose Class-MOP Moose Mouse });
    for my $i ( $all_dists->members ) {
        if ( $i =~ /Mo[ou]seX/i ) {
            $dists->insert($i);
        }
    }
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "moose" );
}

{
    my $dists = Set::Scalar->new;
    for my $i ( $all_dists->members ) {
        if ( $i =~ /DateTime/i ) {
            $dists->insert($i);
        }
    }
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "DateTime" );
}

{
    my $dists = Set::Scalar->new;
    for my $i ( $all_dists->members ) {
        if ( $i =~ /CPAN/i ) {
            $dists->insert($i);
        }
    }
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "CPAN" );
}

{
    my $dists = Set::Scalar->new(
        qw{ Task-Catalyst Task-Catalyst-Tutorial Task-Dancer });
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists = Set::Scalar->new(@deps);

    for my $i ( $all_dists->members ) {
        if ( $i =~ /(?:catalyst|dancer)/i ) {
            $dists->insert($i);
        }
    }
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "catalyst-dancer" );
}

{
    my $dists = Set::Scalar->new;
    for my $i ( $all_dists->members ) {
        if ( $i =~ /Win32/i ) {
            $dists->insert($i);
        }
    }
    $dists->insert( find_all_down_deps($dists) );
    $dists     = $dists->intersection($all_dists);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "win32" );
}

{
    my $dists = Set::Scalar->new(qw{ Dist-Zilla Pod-Weaver});
    $dists->insert( find_all_down_deps($dists) );
    $dists->insert( find_all_deps($dists) );
    for my $i ( $all_dists->members ) {
        if ( $i =~ /(?:Dist::Zilla|Pod::Weaver)/i ) {
            $dists->insert($i);
        }
    }
    $dists     = $dists->intersection($all_dists);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "dist-zilla" );
}

{

    # dzil and plugins
    my $dists = Set::Scalar->new;
    $dists->insert(
        qw{ App-Ack
            Chart-Math-Axis Config-Tiny Data-Stag Data-UUID Excel-Writer-XLSX
            File-Find-Rule GD GD-SVG Graph JSON JSON-XS List-MoreUtils
            Number-Format Parse-CSV Pod-POM-Web POE Readonly Set-Light
            Set-Scalar Spreadsheet-WriteExcel Text-CSV_XS Time-Duration YAML }
    );
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "aligndb" );
}

{
    my $dists = Set::Scalar->new;
    for my $i ( $all_dists->members ) {
        if ( $i
            =~ /(?:Wx|Tk|Gtk|Glib|Gnome|Cairo|Pango|Canvas|gui|Padre|SDL|OpenGL|Games)/i
            )
        {
            $dists->insert($i);
        }
    }
    $dists->insert( find_all_down_deps($dists) );
    $dists     = $dists->intersection($all_dists);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "gui" );
}

gen_cmd( $all_dists, "all left" );

print "All modules processed\n";

#----------------------------------------------------------#
# Subroutines
#----------------------------------------------------------#
sub gen_cmd {
    my $dist_set = shift;
    my $name     = shift;

    my @toposort_dists = dep_sort($dist_set);
    my @modules;
    for (@toposort_dists) {
        push @modules, dist2module($_);
    }

    print "# $name\n" if $name;
    print "# There are ", scalar @modules, " modules\n";
    print "cpanm @modules\n\n";
}

sub merge_modules {
    my @modules = @_;
    my %distributions;
    for my $module ( sort @modules ) {
        my $mo = CPAN::Shell->expand( Module => $module );

        next unless defined $mo;
        next unless defined $mo->inst_file;
        next
            if $mo->cpan_file =~ /perl\-5/;    # skip non-dual-life core modules

        my $dist = $mo->cpan_file;
        if ( exists $distributions{$dist} ) {
            $distributions{$dist}
                = $distributions{$dist} lt $module
                ? $distributions{$dist}
                : $module;
        }
        else {
            $distributions{$dist} = $module;
        }
    }

    return values %distributions;
}

sub dep_sort {
    my $dist_set = shift;

    my @dists = $dist_set->elements;

    my $graph = Graph->new;
    $graph->add_vertices(@dists);

    for my $dist (@dists) {
        my @deps = find_deps($dist);
        for my $dep (@deps) {
            next unless defined $dep;
            next if $dep eq "perl";
            next unless $dist_set->has($dep);
            next if $dist eq $dep;
            next if $graph->has_edge( $dep, $dist );
            $graph->add_edge( $dep, $dist );
        }
    }

    while (1) {
        my @vertices = $graph->find_a_cycle;
        last if @vertices == 0;
        print "Find a cyclic dependency: @vertices\n";
        $graph->delete_cycle(@vertices);
    }

    return $graph->topological_sort;
}

sub find_deps {
    my $dist = shift;

    my @deps = CPANDB::Dependency->select( 'where distribution = ?', $dist, );
    @deps = map { $_->dependency } @deps;

    return sort uniq @deps;
}

sub find_all_deps {
    my $dist_set = shift;

DEPS: while (1) {
        my @dists    = $dist_set->elements;
        my $old_size = $dist_set->size;

        for my $dist (@dists) {
            my @down_deps = find_deps($dist);
            $dist_set->insert(@down_deps);
            my $new_size = $dist_set->size;
            next DEPS
                if $new_size > $old_size;    # redo if find new elements
        }
        last DEPS;
    }

    return $dist_set->elements;
}

sub find_down_deps {
    my $dist = shift;

    my @down_deps
        = CPANDB::Dependency->select( 'where dependency = ?', $dist, );
    @down_deps = map { $_->distribution } @down_deps;

    return sort uniq @down_deps;
}

sub find_all_down_deps {
    my $dist_set = shift;

DOWNDEPS: while (1) {
        my @dists    = $dist_set->elements;
        my $old_size = $dist_set->size;

        for my $dist (@dists) {
            my @down_deps = find_down_deps($dist);
            $dist_set->insert(@down_deps);
            my $new_size = $dist_set->size;
            next DOWNDEPS
                if $new_size > $old_size;    # redo if find new elements
        }
        last DOWNDEPS;
    }

    return $dist_set->elements;
}

sub dist2modules {
    my $dist = shift;

    my @modules = CPANDB::Module->select( 'where distribution = ?', $dist, );

    @modules = sort map { $_->module } @modules;

    return @modules;
}

sub dist2module {
    my $dist = shift;

    my @modules = CPANDB::Module->select( 'where distribution = ?', $dist, );

    # use the most similar module
    my ($module) = sort { compare( $dist, $b ) <=> compare( $dist, $a ) }
        map { $_->module } @modules;

    return $module;
}

sub module2dist {
    my $module = shift;

    my ($mo) = CPANDB::Module->select( 'where module = ?', $module, );

    if ( defined $mo ) {
        return $mo->distribution;
    }
    else {
        return;
    }
}

sub dist2release {
    my $dist = shift;

    my ($distribution)
        = CPANDB::Distribution->select( 'where distribution = ?', $dist, );

    if ( defined $distribution ) {
        return $distribution->release;
    }
    else {
        return;
    }
}

__END__

perl list_modules.pl > mo.txt
