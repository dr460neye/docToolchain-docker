FROM groovy:jre8
ENV LANG=C.UTF-8
ENV LC_CTYPE=en_US.UTF-8
USER root
RUN echo "add needed tools" \
    &&     apt-get update \
    &&     apt-get -y install curl wget zip unzip git bash graphviz python python-pip ruby  ttf-dejavu libgmp-dev libffi-dev lua5.3 lua5.3-lpeg \
    &&     pip install Pygments \
    &&     gem install rdoc --no-document \
    &&     gem install pygments.rb

COPY --from=pandoc/core:latest /usr/bin/pandoc* /usr/bin/

RUN git clone https://github.com/docToolchain/docToolchain.git \
    &&         cd docToolchain \
    &&         git checkout ${TAG} \
    &&         git submodule update -i \
    &&         ./gradlew tasks \
    &&         ./gradlew \
    &&         PATH="/docToolchain/bin:${PATH}"
RUN mkdir /project
WORKDIR /project
ENTRYPOINT ["/bin/bash"]
