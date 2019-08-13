# Copyright 2019 FairwindsOps Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


FROM openjdk:8-slim

LABEL license=Apache-2.0
LABEL maintainer=Fairwinds

# Install tools
RUN apt-get update \
        && apt-get upgrade -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' \
        && apt-get dist-upgrade -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' \
        && apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install \
        curl \
        git \
        gcc \
        make \
        software-properties-common \
        apt-transport-https \
        unzip \
        gnupg2

# Install the node apt sources and then install nodejs
# Node is needed for css file analysis
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install \
        nodejs

# Get and install sonar-scanner
WORKDIR /
ADD https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.3.0.1492-linux.zip /
RUN unzip sonar-scanner-cli-3.3.0.1492-linux.zip
ENV PATH="/sonar-scanner-3.3.0.1492-linux/bin:${PATH}"

# Install Golang
ADD https://dl.google.com/go/go1.12.linux-amd64.tar.gz /
RUN tar -C /usr/local -xzf /go1.12.linux-amd64.tar.gz

# Setup some go directories and env
RUN mkdir -p /go
ENV GOPATH="/go"
ENV PATH="/usr/local/go/bin/:${GOPATH}/bin:${PATH}"

# Install dep and golint
RUN go get -u golang.org/x/lint/golint
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
