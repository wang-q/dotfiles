# Install miniconda

```shell script
# macOS
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
bash Miniconda3-latest-MacOSX-x86_64.sh

# Linux
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

```

```shell script
conda create --name python37 -c bioconda -c conda-forge \
    python=3.7 \
    quast=5.0.2 \
    busco=4.1.4 \
    --yes

conda init bash
conda activate python37

```
