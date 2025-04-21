FROM --platform=linux/x86_64 ubuntu:20.04

# 1) System packages
RUN apt-get update && apt-get install -y wget libgfortran4 && rm -rf /var/lib/apt/lists/*

# 2) Install Spawn
ENV SPAWN_VERSION=0.3.0-8d93151657
RUN wget https://spawn.s3.amazonaws.com/custom/Spawn-$SPAWN_VERSION-Linux.tar.gz && \
    tar -xzf Spawn-$SPAWN_VERSION-Linux.tar.gz && \
    ln -s /Spawn-$SPAWN_VERSION-Linux/bin/spawn-$SPAWN_VERSION /usr/local/bin/

# 3) Create user
RUN useradd -ms /bin/bash user
USER user
WORKDIR /home/user
ENV HOME=/home/user

# 4) Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /home/user/miniconda

# 5) Update conda & install mamba
RUN /home/user/miniconda/bin/conda update -n base -c defaults conda -y && \
    /home/user/miniconda/bin/conda install -n base -c conda-forge mamba -y

# 6) Create environment
#   - Forcing SciPy to something like 1.10.* or 1.11.* to ensure `scipy.integrate.trapz` is present
RUN /home/user/miniconda/bin/mamba create -n pyfmi3 -c conda-forge -y \
    python=3.10 \
    pyfmi=2.11 \
    pandas=1.5.* \
    flask_cors \
    matplotlib=3.7.* \
    requests \
    scipy=1.10.*

# 7) Pip extras
RUN /home/user/miniconda/bin/mamba run -n pyfmi3 pip install \
    flask-restful==0.3.9 \
    werkzeug==2.2.3

# 8) Env vars
ENV PYTHONPATH="${PYTHONPATH}:/home/user"
ENV PATH="/home/user/miniconda/envs/pyfmi3/bin:/home/user/miniconda/bin:$PATH"

EXPOSE 5000
CMD ["/home/user/miniconda/bin/mamba", "run", "-n", "pyfmi3", "python", "restapi.py"]
