FROM ruby:2.4.2-alpine

RUN export LANG=en_US.UTF-8 && \
    export LANGUAGE=en_US.UTF-8 && \
    export LC_ALL=en_US.UTF-8

RUN apk update \
    && apk add build-base sqlite-dev \
    && rm -rf /var/cache/apk*

WORKDIR /app
COPY Gemfile* ./
RUN bundle install --path=vendor/bundle --jobs=4 --without=development test
COPY . /app

EXPOSE 9292
CMD bundle exec rackup -o 0.0.0.0
