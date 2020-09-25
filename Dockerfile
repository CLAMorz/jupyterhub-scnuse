FROM jupyterhub/jupyterhub:1.2

RUN apt-get update && apt-get install -y vim git wget build-essential

COPY pip.conf /root/.pip/pip.conf
RUN pip3 install jupyterhub-nativeauthenticator notebook jupyterlab jupyter-c-kernel && install_c_kernel --sys-prefix

RUN wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh && chmod 755 Miniconda3-latest-Linux-x86_64.sh && ./Miniconda3-latest-Linux-x86_64.sh -bp /opt/conda && /opt/conda/bin/conda init
RUN /opt/conda/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    /opt/conda/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    /opt/conda/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ && \
    /opt/conda/bin/conda config --set show_channel_urls yes && \
    /opt/conda/bin/conda install xeus-cling -c conda-forge && \
    jupyter kernelspec install /opt/conda/share/jupyter/kernels/xcpp17 --prefix /usr/local

RUN ln -s /public /etc/skel/public

RUN npm install -g npm@latest && npm install -g n && n stable

RUN pip3 install --timeout 1000 jupyterlab-git && \
    jupyter serverextension enable --system --py jupyterlab_git

RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter && \
    pip3 install --timeout 1000 black isort yapf autopep8 jupyterlab_code_formatter && \
    jupyter serverextension enable --system --py jupyterlab_code_formatter

RUN apt-get install -y python3-dev && pip3 install nbresuse && \
    jupyter labextension install jupyterlab-topbar-extension jupyterlab-system-monitor

RUN jupyter labextension install jupyterlab-drawio && \
    jupyter serverextension enable --system jupyterlab-drawio

RUN pip3 install nbdime && \
    jupyter labextension install nbdime-jupyterlab && \
    jupyter serverextension enable --system --py nbdime

RUN pip3 install jupyter-lsp && \
    jupyter labextension install @krassowski/jupyterlab-lsp && \
    jupyter serverextension enable --system jupyterlab-lsp

RUN pip3 install python-language-server[all] && \
    apt-get install -y clangd-10 && \
    npm install -g bash-language-server

RUN jupyter labextension install @jupyterlab/github && \
    pip3 install jupyterlab_github && \
    jupyter serverextension enable --system jupyterlab_github

RUN jupyter lab build

CMD ["jupyterhub", "-f", "config.py"]
