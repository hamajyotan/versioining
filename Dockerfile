ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

ARG NODE_MAJOR
ARG YARN_VERSION
ARG BUNDLER_VERSION
ARG PG_MAJOR

ENV LANG C.UTF-8

RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN apt-key update && apt-get update -qq \
  && apt-get install --no-install-recommends -y \
      build-essential \
      postgresql-client-$PG_MAJOR \
      nodejs \
      yarn=$YARN_VERSION-1 \
      vim \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# install dockerize.
ENV DOCKERIZE_VERSION v0.6.1
RUN curl -OL https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mkdir /src
WORKDIR /src

ENV EDITOR vim

ENV GEM_HOME=/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=5
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
    BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH $BUNDLE_BIN:$PATH

RUN gem update --system && gem install bundler:$BUNDLER_VERSION
