FROM ubuntu:16.04

RUN apt update \
  && apt-get install -y --no-install-recommends  software-properties-common \
  && apt-add-repository -y ppa:fish-shell/release-2 \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  fish git curl vim gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev locales \
  # && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 \
  && rm -rf /var/lib/apt/lists/*
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
# ENV LANGUAGE ja_JP:ja
ENV TZ JST-9

# Install pyenv
ENV PYENV_ROOT "/root/.pyenv"
ENV PATH "$PYENV_ROOT/bin:$PATH"
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
  && fish \
  && echo '. (pyenv init - | psub)' >> /root/.config/fish/config.fish \
  && pyenv install 3.6.6 \
  && pyenv global 3.6.6

# Install pipenv & jupyter
# ENV PIPENV_VENV_IN_PROJECT 1
ENV SHELL /usr/bin/fish
ENV PATH "/root/.pyenv/shims:$PATH"
RUN pip --no-cache-dir install pipenv jupyterlab \
  && jupyter notebook --generate-config \
  && echo 'c.NotebookApp.ip = "0.0.0.0"' >> /root/.jupyter/jupyter_notebook_config.py \
  && echo 'c.NotebookApp.allow_root = True' >> /root/.jupyter/jupyter_notebook_config.py \
  && echo 'c.NotebookApp.open_browser = False' >> /root/.jupyter/jupyter_notebook_config.py \
  && echo 'c.NotebookApp.token = ""' >> /root/.jupyter/jupyter_notebook_config.py
# && echo 'exec /usr/bin/fish' >> /root/.bashrc \
# && echo 'pipenv shell' >> /root/.config/fish/config.fish

# project
RUN mkdir /root/project \
  && echo '#!/bin/bash' >> /tmp/start \
  && echo 'pipenv install -d ipykernel > /dev/null' >> /tmp/start \
  && echo 'pipenv run python -m ipykernel install --user --name=pipenv --display-name=pipenv' >> /tmp/start \
  && echo '$@' >> /tmp/start \ 
  && chmod 700 /tmp/start

WORKDIR /root/project
EXPOSE 3000
ENTRYPOINT [ "/tmp/start" ]