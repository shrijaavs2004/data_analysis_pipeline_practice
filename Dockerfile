# build on top of template of minimal notebook
FROM continuumio/miniconda3:25.3.1-1

# copy all conda environment dependencies
COPY conda-lock.yml /tmp/conda-lock.yml

# Install conda-lock and create environment from lock file
RUN conda install -n base -c conda-forge conda-lock -y \
    && conda-lock install --name ia4 /tmp/conda-lock.yml \
    && conda clean --all -y -f

# conda activate the environment
RUN conda init bash \
    && echo "conda activate ia4" >> ~/.bashrc

# install make file
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -y nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


