#!/usr/bin/perl
use strict;
use warnings;
use autodie;

use Getopt::Long;
use Pod::Usage;
use YAML qw(Dump Load DumpFile LoadFile);

use CPAN;
use ExtUtils::Installed;
use Module::CoreList;
use Set::Scalar;

use List::MoreUtils qw(uniq);
use CPANDB ();
use String::Compare;
use Graph;

#----------------------------------------------------------#
# GetOpt section
#----------------------------------------------------------#
my $reload;
my $output;

my $man  = 0;
my $help = 0;

GetOptions(
    'help|?'     => \$help,
    'man'        => \$man,
    'o|output=s' => \$output,
    'r|reload'   => \$reload,

) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -exitstatus => 0, -verbose => 2 ) if $man;

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

{

    # find core modules
    my @cores = Module::CoreList->find_modules( qr/./, $] );
    my $core_module = scalar @cores;
    @cores = merge_modules(@cores);
    my $core_dist  = scalar @cores;
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

    gen_cmd( $dual_dists, "dual life" );
}

#----------------------------------------------------------#
# Minimal sets
#----------------------------------------------------------#
{
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
{
    my $dists = Set::Scalar->new(
        qw{
            Algorithm-C3 Algorithm-Diff aliased Alien-Tidyp Alt-Crypt-RSA-BigInt
            App-cpanminus App-local-lib-Win32Helper App-module-version
            App-pmuninstall AppConfig Archive-Extract Archive-Zip Authen-SASL
            B-Hooks-EndOfScope B-Hooks-OP-Check B-Lint B-Utils BerkeleyDB
            Bytes-Random-Secure Capture-Tiny Carp-Always Carp-Clan CGI
            Class-Accessor Class-Accessor-Chained Class-Accessor-Grouped
            Class-Accessor-Lite Class-C3 Class-C3-Componentised
            Class-Data-Inheritable Class-ErrorHandler Class-Inspector Class-Load
            Class-Load-XS Class-Loader Class-Method-Modifiers Class-Singleton
            Class-Tiny Class-XSAccessor Clone Clone-PP common-sense
            Compress-Raw-Lzma Compress-unLZMA Config-Any Context-Preserve
            Convert-ASCII-Armour Convert-ASN1 Convert-PEM CPAN-DistnameInfo
            CPAN-Meta-Check CPAN-Meta-Requirements CPAN-Meta-YAML CPAN-Mini
            cpan-outdated CPAN-SQLite CPANPLUS CPANPLUS-Dist-Build
            Crypt-Blowfish Crypt-CAST5_PP Crypt-CBC Crypt-DES Crypt-DES_EDE3
            Crypt-DSA Crypt-DSA-GMP Crypt-IDEA Crypt-OpenSSL-AES
            Crypt-OpenSSL-Bignum Crypt-OpenSSL-DSA Crypt-OpenSSL-Random
            Crypt-OpenSSL-RSA Crypt-OpenSSL-X509 Crypt-Random Crypt-Random-Seed
            Crypt-Random-TESHA2 Crypt-RC4 Crypt-RC6 Crypt-Rijndael
            Crypt-RIPEMD160 Crypt-Serpent Crypt-SSLeay Crypt-Twofish Data-Buffer
            Data-Dump Data-Dump-Streamer Data-Dumper-Concise Data-OptList
            Data-Page Data-Printer Data-Random DateTime
            DateTime-Format-DateParse DateTime-Locale DateTime-TimeZone
            DateTime-TimeZone-Local-Win32 DB_File DBD-ADO DBD-CSV DBD-mysql
            DBD-ODBC DBD-Oracle DBD-Pg DBD-SQLite DBI DBIx-Class DBIx-Simple
            DBM-Deep Devel-CheckLib Devel-Declare Devel-GlobalDestruction
            Devel-OverloadInfo Devel-PartialDump Devel-StackTrace Digest-CMAC
            Digest-HMAC Digest-MD2 Digest-Perl-MD5 Digest-SHA1 Digest-Whirlpool
            Dist-CheckConflicts Email-Abstract Email-Address Email-Date-Format
            Email-MessageID Email-MIME Email-MIME-ContentType
            Email-MIME-Encodings Email-MIME-Kit Email-Sender Email-Simple
            Email-Stuffer Email-Valid Encode Encode-compat Encode-Locale enum
            Eval-Closure Excel-Writer-XLSX Exception-Class Exporter-Tiny
            ExtUtils-Config ExtUtils-Depends ExtUtils-F77 ExtUtils-Helpers
            ExtUtils-InstallPaths ExtUtils-PkgConfig FCGI FFI-Raw File-CheckTree
            File-Copy-Recursive File-Find-Rule File-Find-Rule-Perl File-HomeDir
            File-Listing File-Map File-Remove File-ShareDir
            File-ShareDir-Install File-Slurp File-Slurp-Tiny File-Which GD
            Graphics-ColorUtils Hash-Merge Hook-LexWrap HTML-Form HTML-Parser
            HTML-Tagset HTML-Tree HTTP-Cookies HTTP-Daemon HTTP-Date
            HTTP-Message HTTP-Negotiate HTTP-Server-Simple HTTP-Tiny Imager
            IO-All IO-CaptureOutput IO-Compress-Lzma IO-HTML IO-Interactive
            IO-SessionData IO-Socket-INET6 IO-Socket-Socks IO-Socket-SSL
            IO-String IO-stringy IPC-Run IPC-Run3 IPC-System-Simple JSON JSON-XS
            libnet libwww-perl List-AllUtils List-MoreUtils local-lib
            Log-Message Log-Message-Simple Log-Report Log-Report-Optional
            LWP-MediaTypes LWP-Online LWP-Protocol-https MailTools
            Math-Base-Convert Math-BigInt-GMP Math-GMP Math-Int64 Math-MPC
            Math-MPFR Math-Pari Math-Prime-Util Math-Prime-Util-GMP
            Math-Random-ISAAC Math-Round MIME-Charset MIME-Types Modern-Perl
            Module-Build Module-Build-Tiny Module-Find Module-Implementation
            Module-Metadata Module-Pluggable Module-Runtime
            Module-Runtime-Conflicts Mojolicious Moo Moose MooseX-ClassAttribute
            MooseX-Declare MooseX-LazyRequire
            MooseX-Meta-TypeConstraint-ForceCoercion MooseX-Method-Signatures
            MooseX-NonMoose MooseX-Role-Parameterized
            MooseX-Role-WithOverloading MooseX-Traits MooseX-Types
            MooseX-Types-DateTime MooseX-Types-Structured MooX::Types::MooseLike
            Mozilla-CA MRO-Compat namespace-autoclean namespace-clean Net-DNS
            Net-HTTP Net-IMAP-Client Net-SMTPS Net-SSH2 Net-SSLeay Net-Telnet
            Number-Compare Object-Accessor Object-Tiny OLE-Storage_Lite OpenGL
            Package-Constants Package-DeprecationManager Package-Stash
            Package-Stash-XS PAR PAR-Dist PAR-Dist-FromPPD PAR-Dist-InstallPPD
            PAR-Repository-Client PAR-Repository-Query Params-Util
            Params-Validate parent Parse-Method-Signatures Parse-RecDescent
            Path-Class Path-Tiny Perl-Tidy PerlIO-Layers PkgConfig pler
            Pod-Checker Pod-LaTeX Pod-Simple Pod-Usage Portable PPI PPM
            Probe-Perl Role-Tiny Scalar-List-Utils Scope-Guard SOAP-Lite Socket
            Socket6 Sort-Naturally Sort-Versions Spiffy Spreadsheet-ParseExcel
            Spreadsheet-ParseXLSX Spreadsheet-WriteExcel SQL-Abstract
            SQL-Statement String-Print String-RewritePrefix Sub-Exporter
            Sub-Exporter-Progressive Sub-Identify Sub-Install Sub-Name
            Sub-Uplevel syntax Syntax-Keyword-Junction Sys-Syslog Task-Weaken
            Template-Tiny Template-Toolkit Term-Cap Term-ReadLine-Perl Term-UI
            TermReadKey Test-Base Test-CleanNamespaces Test-Deep
            Test-Differences Test-Exception Test-Fatal Test-LeakTrace Test-Most
            Test-NoWarnings Test-Object Test-Pod Test-Requires Test-Script
            Test-SubCalls Test-Warn Test-Warnings Test-YAML Text-CSV Text-CSV_XS
            Text-Diff Text-Glob Text-Patch Text-Soundex Throwable Tie-Array-CSV
            Tie-EncryptedHash Time-Piece TimeDate Tree-DAG_Node Try-Tiny
            Types-Serialiser Unicode-LineBreak Unicode-UTF8 URI V Variable-Magic
            version Win32-API Win32-Console Win32-Console-ANSI Win32-Daemon
            Win32-EventLog Win32-File Win32-File-Object Win32-GuiTest
            Win32-IPHelper Win32-Job Win32-OLE Win32-Pipe Win32-Process
            Win32-Service Win32-ServiceManager Win32-ShellQuote
            Win32-TieRegistry Win32-UTCFileTime Win32-WinError Win32API-Registry
            WWW-Mechanize WWW-RobotRules XML-LibXML XML-LibXSLT
            XML-NamespaceSupport XML-Parser XML-Parser-Lite XML-SAX XML-SAX-Base
            XML-SAX-Expat XML-Simple XML-Twig YAML YAML-LibYAML YAML-Tiny
            }
    );
    my @deps = grep { $all_dists->has($_) } $dists->elements;
    $dists     = Set::Scalar->new(@deps);
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

warn "* All modules processed\n";

#----------------------------------------------------------#
# Subroutines
#----------------------------------------------------------#
sub gen_cmd {
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

=head1 NAME

list_modules.pl - list installed CPAN modules

=head1 SYNOPSIS

    perl list_modules.pl [options]
      Options:
        --help              brief help message
        --man               full documentation
        --output, -o        write to a file
        --reload, -r        reload CPAN index

    perl list_modules.pl > mo.txt
    perl list_modules.pl -o mo.txt

=cut
