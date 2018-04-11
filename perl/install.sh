#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

hash perl 2>/dev/null || {
    brew install perl
}

cd ${BASE_DIR}

hash cpanm 2>/dev/null || {
    curl -L https://cpanmin.us | perl - App::cpanminus
}

CPAN_MIRROR=http://mirrors.ustc.edu.cn/CPAN/
NO_TEST=--notest

# basic modules
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST Archive::Extract Config::Tiny DB_File File::Find::Rule Getopt::Long::Descriptive JSON JSON::XS Text::CSV_XS YAML::Syck
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST App::Ack App::Cmd DBI MCE Moo Moose Perl::Tidy Template WWW::Mechanize XML::Parser

# RepeatMasker need this
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST Text::Soundex

# GD
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST GD SVG GD::SVG

# bioperl
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST Data::Stag Test::Most URI::Escape Algorithm::Munkres Array::Compare Clone Error File::Sort Graph List::MoreUtils Set::Scalar Sort::Naturally
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST HTML::Entities HTML::HeadParser HTML::TableExtract HTTP::Request::Common LWP::UserAgent PostScript::TextBlock
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST XML::DOM XML::DOM::XPath XML::LibXML XML::SAX::Writer XML::Simple XML::Twig XML::Writer GraphViz SVG::Graph
cpanm --mirror-only --mirror $CPAN_MIRROR --notest Convert::Binary::C IO::Scalar

cpanm --mirror-only --mirror $CPAN_MIRROR --notest CJFIELDS/BioPerl-1.007002.tar.gz
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST Bio::ASN1::EntrezGene Bio::DB::EUtilities Bio::Graphics
cpanm --mirror-only --mirror $CPAN_MIRROR --notest CJFIELDS/BioPerl-Run-1.007002.tar.gz # BioPerl-Run

# circos
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST Config::General Data::Dumper Digest::MD5 Font::TTF::Font Math::Bezier Math::BigFloat Math::Round Math::VecStat
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST Params::Validate Readonly Regexp::Common Set::IntSpan Statistics::Basic Text::Balanced Text::Format Time::HiRes

# Bio::Phylo
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST XML::XML2JSON PDF::API2 Math::CDF Math::Random
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST Bio::Phylo

# Database and WWW
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST MongoDB Mojolicious

# text, rtf and xlsx
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST Roman Text::Table RTF::Writer Chart::Math::Axis
cpanm --mirror-only --mirror $CPAN_MIRROR --notest Excel::Writer::XLSX Spreadsheet::XLSX Spreadsheet::ParseExcel Spreadsheet::WriteExcel

# AlignDB::*
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST AlignDB::IntSpan AlignDB::Stopwatch
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST AlignDB::Codon AlignDB::DeltaG AlignDB::GC AlignDB::SQL AlignDB::Window AlignDB::ToXLSX
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST App::RL App::Fasops App::Rangeops

# Test::*
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST Test::Class Test::Roo Test::Taint Test::Without::Module

# Moose and Moo
cpanm --mirror-only --mirror $CPAN_MIRROR --notest MooX::Options MooseX::Storage

# Develop
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST App::pmuninstall App::cpanoutdated Minilla
cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST Pod::POM::Web Search::Indexer PPI::XS

# Gtk3 stuffs
# cpanm --mirror-only --mirror $CPAN_MIRROR $NO_TEST Glib Cairo Cairo::GObject Glib::Object::Introspection Gtk3

# Math
# cpanm --mirror-only --mirror $CPAN_MIRROR --notest Math::Random::MT::Auto PDL Math::GSL

# Statistics::R would be installed in `7-brew.sh`
# DBD::mysql would be installed in `extra/7-mysql.sh`
