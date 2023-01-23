FROM pytorch/pytorch:latest
# Install dependencies

ENV NODE_VERSION=16.13.0
RUN apt-get update && apt install -y curl git
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# Create virtualenv and 'activate' it by adjusting PATH.
# See https://pythonspeed.com/articles/activate-virtualenv-dockerfile/.
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV --system-site-packages
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install pip requirements
RUN pip install --no-cache-dir --upgrade pip setuptools
COPY requirements.txt /copied/requirements.txt
RUN pip install --no-cache-dir -r /copied/requirements.txt
