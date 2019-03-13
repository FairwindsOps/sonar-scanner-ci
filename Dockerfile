FROM openjdk:8-slim

# Install tools
RUN apt-get update \
        && apt-get upgrade -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' \
        && apt-get dist-upgrade -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' \
        && apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install \
        curl \
        git \
        gcc \
        software-properties-common \
        apt-transport-https \
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