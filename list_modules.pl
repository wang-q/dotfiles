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
        qw{
            Algorithm-Diff aliased Alien-Tidyp Alt-Crypt-RSA-BigInt
            App-cpanminus App-local-lib-Win32Helper App-module-version AppConfig
            Archive-Extract Archive-Tar Archive-Zip autodie AutoLoader B-Debug
            B-Hooks-EndOfScope B-Hooks-OP-Check bareword-filehandles BerkeleyDB
            Bytes-Random-Secure Capture-Tiny Carp Carp-Clan CGI.pm
            Class-Accessor Class-ErrorHandler Class-Inspector Class-Load
            Class-Load-XS Class-Loader Class-Method-Modifiers Class-Singleton
            Class-Tiny Clone Clone-PP common-sense Compress-Bzip2
            Compress-Raw-Bzip2 Compress-Raw-Lzma Compress-Raw-Zlib
            Compress-unLZMA Config-Perl-V Context-Preserve Convert-ASCII-Armour
            Convert-ASN1 Convert-PEM CPAN-Checksums CPAN-DistnameInfo
            CPAN-Inject CPAN-Meta CPAN-Meta-Check CPAN-Meta-Requirements
            CPAN-Meta-YAML CPAN-Mini CPAN-SQLite CPANPLUS CPANPLUS-Dist-Build
            Crypt-Blowfish Crypt-CAST5_PP Crypt-CBC Crypt-DES Crypt-DES_EDE3
            Crypt-DH Crypt-DSA Crypt-IDEA Crypt-OpenSSL-AES Crypt-OpenSSL-Bignum
            Crypt-OpenSSL-DSA Crypt-OpenSSL-Random Crypt-OpenSSL-RSA
            Crypt-Random-Seed Crypt-Random-TESHA2 Crypt-Rijndael Crypt-RIPEMD160
            Crypt-SSLeay Crypt-Twofish Data-Buffer Data-Compare Data-Dump
            Data-OptList Data-Printer Data-Random DateTime DateTime-Locale
            DateTime-TimeZone DB_File DBD-ADO DBD-mysql DBD-ODBC DBD-Pg
            DBD-SQLite DBI DBIx-Simple DBM-Deep Devel-Declare
            Devel-GlobalDestruction Devel-PartialDump Devel-PPPort
            Digest-BubbleBabble Digest-HMAC Digest-MD2 Digest-MD5 Digest-SHA
            Digest-SHA1 Dist-CheckConflicts Encode Encode-Locale Eval-Closure
            ExtUtils-CBuilder ExtUtils-Command ExtUtils-Config ExtUtils-Depends
            ExtUtils-F77 ExtUtils-Helpers ExtUtils-InstallPaths
            ExtUtils-MakeMaker ExtUtils-ParseXS FCGI File-chmod File-Fetch
            File-Find-Rule File-HomeDir File-Listing File-pushd File-Remove
            File-ShareDir File-Slurp File-Temp File-Which Filter GD Getopt-Long
            Hook-LexWrap HTML-Form HTML-Parser HTML-Tagset HTML-Tree
            HTTP-Cookies HTTP-Daemon HTTP-Date HTTP-Message HTTP-Negotiate
            HTTP-Server-Simple HTTP-Tiny Imager Import-Into indirect IO-Compress
            IO-Compress-Lzma IO-HTML IO-Interactive IO-SessionData
            IO-Socket-INET6 IO-Socket-IP IO-Socket-SSL IO-String IO-stringy
            IPC-Cmd IPC-Run IPC-Run3 IPC-System-Simple JSON JSON-XS
            Lexical-SealRequireHints libnet libwww-perl List-MoreUtils local-lib
            Locale-Codes Log-Message LWP-MediaTypes LWP-Online
            LWP-Protocol-https Math-BigInt-GMP Math-GMP Math-Int64 Math-MPC
            Math-MPFR Math-Pari Math-Prime-Util Math-Prime-Util-GMP
            Math-Random-ISAAC Math-Round MIME-Base64 Module-Build Module-Build
            Module-Build-Tiny Module-Implementation Module-Load-Conditional
            Module-Metadata Module-Pluggable Module-Runtime Moo Moose
            MooseX-ClassAttribute MooseX-Declare MooseX-LazyRequire
            MooseX-Meta-TypeConstraint-ForceCoercion MooseX-Method-Signatures
            MooseX-NonMoose MooseX-Role-Parameterized MooseX-Traits MooseX-Types
            MooseX-Types-DateTime MooseX-Types-Structured Mozilla-CA MRO-Compat
            multidimensional namespace-autoclean namespace-clean Net-HTTP
            Net-SMTP-TLS Net-SSH2 Net-SSLeay Net-Telnet Number-Compare
            Object-Accessor Package-Constants Package-DeprecationManager
            Package-Stash Package-Stash-XS PAR PAR-Dist PAR-Dist-FromPPD
            PAR-Dist-InstallPPD PAR-Repository-Client PAR-Repository-Query
            Params-Check Params-Util Params-Validate parent Parse-Binary
            Parse-CPAN-Meta Parse-Method-Signatures Perl-OSType perlfaq pip pler
            Pod-Checker Pod-Parser Pod-Perldoc Pod-Usage podlators Portable PPI
            PPM Probe-Perl Role-Tiny Scalar-List-Utils SOAP-Lite Socket Socket6
            Sort-Naturally Sort-Versions Storable strictures String-CRC32
            Sub-Exporter Sub-Exporter-Progressive Sub-Install Sub-Name
            Sub-Uplevel Task-Weaken Template-Tiny Template-Toolkit Term-Cap
            Term-ReadLine Term-ReadLine-Perl Term-UI TermReadKey Test-CheckDeps
            Test-Deep Test-Differences Test-Exception Test-Fatal Test-Harness
            Test-Manifest Test-NoWarnings Test-Object Test-Output Test-Requires
            Test-Script Test-Simple Test-SubCalls Test-Tester Test-use-ok
            Test-Warn Text-Diff Text-Glob Text-ParseWords Text-Patch
            Text-Tabs+Wrap threads threads-shared Tie-EncryptedHash Time-HiRes
            Time-Piece TimeDate Tree-DAG_Node Try-Tiny Types-Serialiser
            Unicode-Collate Unicode-Normalize URI Variable-Magic version Win32
            Win32-API Win32-Console-ANSI Win32-EventLog Win32-Exe Win32-File
            Win32-File-Object Win32-OLE Win32-Pipe Win32-Process
            Win32-TieRegistry Win32-UTCFileTime Win32-WinError Win32API-Registry
            WWW-Mechanize WWW-RobotRules XML-LibXML XML-LibXSLT
            XML-NamespaceSupport XML-Parser XML-SAX XML-SAX-Base XML-SAX-Expat
            XML-Simple YAML YAML-LibYAML YAML-Tiny
        }
    );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "strawberry" );
}

{
    my $dists = Set::Scalar->new(
        qw{ Test-Assert Test-Assertions Test-Block Test-Class
            Test-ClassAPI Test-Compile Test-Deep Test-Differences Test-Exception
            Test-LongString Test-Memory-Cycle Test-Manifest Test-MockObject
            Test-Most Test-NoWarnings Test-Output Test-Perl-Critic Test-Pod
            Test-Pod-Coverage Test-Script Test-TempDir Test-Tester
            Test-Unit-Lite Test-Warn Test-use-ok }
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
        qw{ Algorithm-Munkres Array-Compare Bio-ASN1-EntrezGene Convert-Binary-C
            Data-Stag Error File-Sort GraphViz HTML-TableExtract Math-Random
            PostScript-TextBlock SVG SVG-Graph Spreadsheet-ParseExcel
            XML-DOM-XPath XML-Parser-PerlSAX XML-SAX-Writer XML-Twig XML-Writer
            Clone Config-General Font-TTF-Font GD GD-Image GD-SVG List-MoreUtils
            List-Util Math-Bezier Math-Round Math-VecStat Memoize
            Params-Validate Readonly Regexp-Common Text-Balanced Text-Format }
    );
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "bioperl-circos" );
}

{
    my $dists = Set::Scalar->new;
    $dists->insert(
        qw{ Bio-Graphics Bio-Phylo Chart-Math-Axis Config-Tiny Data-Stag Data-UUID
            Excel-Writer-XLSX File-Find-Rule GD Graph Growl-GNTP JSON JSON-XS
            MCE Number-Format Parse-CSV POE Proc-Background Readonly
            Spreadsheet-WriteExcel Text-CSV_XS Time-Duration YAML }
    );
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "aligndb" );
}

{
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

{
    my $dists = Set::Scalar->new(
        qw{ Pod-POM-Web Graph EV
            }
    );
    for my $i ( $all_dists->members ) {
        if ( $i
            =~ /^(AnyEvent|App|Class|Config|DBD|Devel|ExtUtils|File|Module|PAR|Pod|POE|Object|Set|SQL)/i
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
    my $dists = Set::Scalar->new(
        qw{ Task-Catalyst Task-Catalyst-Tutorial Task-Dancer Mojolicious });
    $dists->insert( find_all_deps($dists) );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists = Set::Scalar->new(@deps);

    for my $i ( $all_dists->members ) {
        if ( $i =~ /(?:catalyst|dancer|mojo)/i ) {
            $dists->insert($i);
        }
    }
    $all_dists = $all_dists->difference($dists);

    for my $i ( $all_dists->members ) {
        if ( $i =~ /^(HTML|WWW|LWP|HTTP)/i ) {
            $dists->insert($i);
        }
    }
    $dists->insert( find_all_deps($dists) );

    $dists     = $dists->intersection($all_dists);
    $all_dists = $all_dists->difference($dists);
    gen_cmd( $dists, "catalyst-dancer-mojo-html" );
}

{
    my $dists = Set::Scalar->new(qw{ Dist-Zilla Pod-Weaver});
    $dists->insert( find_all_down_deps($dists) );
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
