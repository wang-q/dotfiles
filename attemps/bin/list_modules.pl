#!/usr/bin/perl
use strict;
use warnings;
use autodie;

use Getopt::Long;

use CPAN;
use Module::CoreList;
use ExtUtils::Installed;
use CPANDB ();

use Path::Tiny;
use Set::Scalar;
use List::MoreUtils qw(uniq);
use String::Compare;
use Graph;

#----------------------------------------------------------#
# GetOpt section
#----------------------------------------------------------#

=head1 NAME

list_modules.pl - list installed CPAN modules

=head1 SYNOPSIS

    perl list_modules.pl [options]
      Options:
        --help              brief help message
        --man               full documentation
        --input   -i        read modules from a file
        --output  -o        write to a file
        --minimal -m        only minimal set of modules
        --reload  -r        reload CPAN index

    perl list_modules.pl > mo.txt
    perl list_modules.pl -o mo.txt
    perl list_modules.pl -i stpan.txt -m

=cut

GetOptions(
    'help|?'     => sub { Getopt::Long::HelpMessage(0) },
    'input|i=s'  => \( my $input ),
    'output|o=s' => \( my $output ),
    'minimal|m'  => \( my $minimal ),
    'reload|r'   => \( my $reload ),
) or Getopt::Long::HelpMessage(1);

#----------------------------------------------------------#
# Loading CPAN and CPANDB
#----------------------------------------------------------#
$|++;

# force load index
if ($reload) {
    warn "* Update CPAN index\n";
    CPAN::HandleConfig->load;
    CPAN::Shell::setup_output;
    CPAN::Index->force_reload;
}

# Load the CPANDB database
warn "* Update CPANDB\n";

CPANDB->import(
    {   show_progress => 1,
        maxage        => 30 * 24 * 60 * 60,    # one month
    }
);

#----------------------------------------------------------#
# Loading core and installed modules
#----------------------------------------------------------#
my $all_dists;

if ($input) {
    my $content = path($input)->slurp;
    my @modules = grep { !( /\/|\\|\[/ or /^\-\-/ or /^#/ ) } split /\s+/, $content;

    @modules = merge_modules(@modules);
    my @dists = grep { defined $_ } map { module2dist($_) } @modules;
    $all_dists = Set::Scalar->new(@dists);
    warn "* Find ", $all_dists->size, " modules from input file\n";
}
else {

    # find core modules
    my @cores = Module::CoreList->find_modules( qr/./, $] );
    @cores = merge_modules(@cores);
    my @dual_dists = grep { defined $_ } map { module2dist($_) } @cores;
    my $dual_dists = Set::Scalar->new(@dual_dists);
    warn "* Find ", $dual_dists->size, " core modules\n";

    # find installed modules
    warn "* Reading local .packlists\n";
    my $inst    = ExtUtils::Installed->new;
    my @modules = $inst->modules;
    @modules = merge_modules(@modules);
    my @dists = grep { defined $_ } map { module2dist($_) } @modules;

    $all_dists = Set::Scalar->new(@dists);
    $all_dists = $all_dists->difference($dual_dists);

    # one of CGI.pm dependencies, FCGI, isn't in core
    $dual_dists->delete("CGI.pm");
    $all_dists->insert("CGI.pm");

    warn "* Find ", $all_dists->size, " installed modules\n";

    gen_cmd( $dual_dists, "dual life" ) unless $minimal;
}

#----------------------------------------------------------#
# Minimal sets
#----------------------------------------------------------#
{
    #@type Set::Scalar
    my $dist_set = $all_dists->copy;

    my @dists = $dist_set->elements;

    my $dep_dist = Set::Scalar->new;

    for my $dist (@dists) {
        my @deps = find_deps($dist);
        for my $dep (@deps) {
            next unless defined $dep;
            next if $dep eq "perl";
            next unless $dist_set->has($dep);
            next if $dist eq $dep;
            $dep_dist->insert($dep);
        }
    }

    $dist_set = $dist_set->difference($dep_dist);
    gen_cmd( $dist_set, "minimal", "alpha_sort" );
}

#----------------------------------------------------------#
# Every categories
#----------------------------------------------------------#
unless ($minimal) {
    my $dists = Set::Scalar->new(
        qw{ Test-Assert Test-Assertions Test-Block Test-Class
            Test-ClassAPI Test-Compile Test-Deep Test-Differences Test-Exception
            Test-LongString Test-Memory-Cycle Test-Manifest Test-MockObject
            Test-Most Test-NoWarnings Test-Output Test-Perl-Critic Test-Pod
            Test-Pod-Coverage Test-Script Test-TempDir Test-Tester
            Test-Unit-Lite Test-Warn Test-use-ok
            }
    );
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "test" );
}

unless ($minimal) {
    my $dists = Set::Scalar->new;
    for my $i ( $all_dists->members ) {
        if ( $i =~ /^(Math|Stat|Crypt|Digest|PDL|PGPLOT)/i ) {
            $dists->insert($i);
        }
    }
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "math" );
}

unless ($minimal) {
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

unless ($minimal) {
    my $dists = Set::Scalar->new;
    for my $i ( $all_dists->members ) {
        if ( $i =~ /(?:Wx|Tk|Gtk|Glib|Gnome|Cairo|Pango|Canvas|gui|Padre|SDL|OpenGL|Games)/i ) {
            $dists->insert($i);
        }
    }
    $dists->insert( find_all_down_deps($dists) );
    $dists     = $dists->intersection($all_dists);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "gui" );
}

unless ($minimal) {
    my $dists = Set::Scalar->new(
        qw{ Algorithm-Munkres Array-Compare Bio-ASN1-EntrezGene Convert-Binary-C
            Data-Stag Error File-Sort GraphViz HTML-TableExtract Math-Random
            PostScript-TextBlock SVG SVG-Graph Spreadsheet-ParseExcel
            XML-DOM-XPath XML-Parser-PerlSAX XML-SAX-Writer XML-Twig XML-Writer
            Clone Config-General Font-TTF-Font GD GD-Image GD-SVG List-MoreUtils
            List-Util Math-Bezier Math-Round Math-VecStat Memoize
            Params-Validate Readonly Regexp-Common Text-Balanced Text-Format
            }
    );
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "bioperl-circos" );
}

unless ($minimal) {
    my $dists = Set::Scalar->new;
    $dists->insert(
        qw{ Bio-Graphics Bio-Phylo Chart-Math-Axis Config-Tiny Data-Stag
            Data-UUID Excel-Writer-XLSX File-Find-Rule GD Graph JSON JSON-XS MCE
            Number-Format Parse-CSV POE Proc-Background Readonly
            Spreadsheet-WriteExcel Text-CSV_XS Time-Duration YAML
            }
    );
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "aligndb" );
}

unless ($minimal) {
    my $dists = Set::Scalar->new(qw{ Any-Moose Class-MOP Moose Mouse Moo });
    for my $i ( $all_dists->members ) {
        if ( $i =~ /Mo[ou]/i ) {
            $dists->insert($i);
        }
    }
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "moose" );
}

unless ($minimal) {
    my $dists = Set::Scalar->new(
        qw{ Pod-POM-Web Graph EV
            }
    );
    for my $i ( $all_dists->members ) {
        if ( $i
            =~ /^(AnyEvent|App|Class|Config|DBD|Devel|ExtUtils|File|Module|PAR|Pod|POE|Object|Set|SQL|CPAN|DateTime|TimeDate)/i
            )
        {
            $dists->insert($i);
        }
    }
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "devel-tools" );
}

unless ($minimal) {
    my $dists = Set::Scalar->new(qw{ Dist-Zilla Pod-Weaver});
    $dists->insert( find_all_deps($dists) );
    for my $i ( $all_dists->members ) {
        if ( $i =~ /(?:Zilla|Weaver)/i ) {
            $dists->insert($i);
        }
    }
    $dists     = $dists->intersection($all_dists);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "dist-zilla" );
}

unless ($minimal) {
    gen_cmd( $all_dists, "all left" );
}

warn "* All modules processed\n";

#----------------------------------------------------------#
# Subroutines
#----------------------------------------------------------#
sub gen_cmd {

    #@type Set::Scalar
    my $dist_set   = shift;
    my $name       = shift;
    my $alpha_sort = shift;

    $name = "JohnDoe" unless $name;

    my @sort_dists;
    if ($alpha_sort) {
        @sort_dists = sort $dist_set->elements;
    }
    else {
        @sort_dists = dep_sort($dist_set);
    }

    my @modules;
    for (@sort_dists) {
        push @modules, dist2module($_);
    }

    if ($output) {
        open STDOUT, '>>', $output;
    }
    printf STDOUT "# [%s], %d modules\n", $name, scalar @modules;
    print STDOUT "cpanm @modules\n\n";
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

    #@type Set::Scalar
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
        warn "*     Find a cyclic dependency: @vertices\n";
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

    #@type Set::Scalar
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

    my @down_deps = CPANDB::Dependency->select( 'where dependency = ?', $dist, );
    @down_deps = map { $_->distribution } @down_deps;

    return sort uniq @down_deps;
}

sub find_all_down_deps {

    #@type Set::Scalar
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

sub dist2release {
    my $dist = shift;

    my ($distribution) = CPANDB::Distribution->select( 'where distribution = ?', $dist, );

    if ( defined $distribution ) {
        return $distribution->release;
    }
    else {
        return;
    }
}

__END__
