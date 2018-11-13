FROM python:3.6

RUN apt-get update \
  && apt-get install -y --no-install-recommends software-properties-common \
  && apt-add-repository -y ppa:fish-shell/release-2 \
  && apt-get update \
  || apt-get install -y --no-install-recommends \
  fish git curl vim gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev locales \
  && add-apt-repository --remove ppa:fish-shell/release-2 \
  && rm -rf /var/lib/apt/lists/*
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV TZ JST-9

# Install pipenv & jupyter
ENV SHELL /usr/bin/fish
ENV PATH "/root/.pyenv/shims:$PATH"
RUN pip --no-cache-dir install pipenv jupyterlab \
  && jupyter notebook --generate-config \
  && echo 'c.NotebookApp.ip = "0.0.0.0"' >> /root/.jupyter/jupyter_notebook_config.py \
  && echo 'c.NotebookApp.allow_root = True' >> /root/.jupyter/jupyter_notebook_config.py \
  && echo 'c.NotebookApp.open_browser = False' >> /root/.jupyter/jupyter_notebook_config.py \
  && echo 'c.NotebookApp.token = ""' >> /root/.jupyter/jupyter_notebook_config.py

RUN pip --no-cache-dir install rise \
  && jupyter-nbextension install rise --py --sys-prefix \
  && jupyter-nbextension enable rise --py --sys-prefix

# project
RUN mkdir /root/project \
  && echo '#!/bin/bash' >> /tmp/start \
  && echo 'pipenv install -d ipykernel > /dev/null' >> /tmp/start \
  && echo 'pipenv run python -m ipykernel install --user --name=pipenv --display-name=pipenv' >> /tmp/start \
  && echo '$@' >> /tmp/start \ 
  && chmod 700 /tmp/start

WORKDIR /project
EXPOSE 5678
ENTRYPOINT [ "/tmp/start" ]