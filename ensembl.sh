#!/usr/bin/env bash

export ENSEMBL_VERSION='94'

cd /tmp

if [ ! -e ensembl-${ENSEMBL_VERSION}.tar.gz ]; then
    echo "==> Get ensembl tarballs"
    wget https://github.com/Ensembl/ensembl/archive/release/${ENSEMBL_VERSION}.tar.gz           -O ensembl-${ENSEMBL_VERSION}.tar.gz
    wget https://github.com/Ensembl/ensembl-compara/archive/release/${ENSEMBL_VERSION}.tar.gz   -O ensembl-compara-${ENSEMBL_VERSION}.tar.gz
    wget https://github.com/Ensembl/ensembl-variation/archive/release/${ENSEMBL_VERSION}.tar.gz -O ensembl-variation-${ENSEMBL_VERSION}.tar.gz
fi

SITE_PERL=$(perl -e '($first) = grep {/site_perl/} grep {!/darwin/i and !/x86_64/} @INC; print $first')

echo "==> ensembl"
tar xfz /tmp/ensembl-${ENSEMBL_VERSION}.tar.gz \
    ensembl-release-${ENSEMBL_VERSION}/modules/Bio/EnsEMBL
cp -R ensembl-release-${ENSEMBL_VERSION}/modules/Bio ${SITE_PERL}

echo "==> ensembl-compara"
tar xfz /tmp/ensembl-compara-${ENSEMBL_VERSION}.tar.gz \
    ensembl-compara-release-${ENSEMBL_VERSION}/modules/Bio/EnsEMBL
cp -R ensembl-compara-release-${ENSEMBL_VERSION}/modules/Bio ${SITE_PERL}

echo "==> ensembl-variation"
tar xfz /tmp/ensembl-variation-${ENSEMBL_VERSION}.tar.gz \
    ensembl-variation-release-${ENSEMBL_VERSION}/modules/Bio/EnsEMBL
cp -R ensembl-variation-release-${ENSEMBL_VERSION}/modules/Bio ${SITE_PERL}

rm -fr ensembl-release-${ENSEMBL_VERSION}
rm -fr ensembl-compara-release-${ENSEMBL_VERSION}
rm -fr ensembl-variation-release-${ENSEMBL_VERSION}

perl -MBio::EnsEMBL::ApiVersion -e 'print qq{If you see this, means ensembl installation successful.\n}'

unset ENSEMBL_VERSION
