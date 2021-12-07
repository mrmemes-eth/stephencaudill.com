FROM ruby:2.7.5

RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh  && \
    bash nodesource_setup.sh && \
    apt install nodejs

ENV app /usr/src/app
RUN mkdir $app
WORKDIR $app

ENV BUNDLE_PATH /box

COPY . $app

RUN bundle install --without debug

EXPOSE 4567