FROM node:8.15-alpine as node
FROM ruby:2.6-alpine3.9

ENV PATH=/sample/bin:$PATH \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_ENV=production \
    NODE_ENV=production

EXPOSE 3000 4000
WORKDIR /sample

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin/npm /usr/local/bin/npm
COPY --from=node /opt/yarn-* /opt/yarn

RUN apk add --no-cache -t build-dependencies \
    build-base \
    openssl \
    libxml2-dev \
    libxslt-dev \
    sqlite-dev \
 && apk add --no-cache \
    ca-certificates \
    libxml2 \
    libxslt \
    tzdata \
 && update-ca-certificates \
 && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
 && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg


COPY Gemfile Gemfile.lock package.json yarn.lock .yarnclean /sample/

RUN gem install bundler
RUN bundle config build.nokogiri --use-system-libraries \
 && bundle install -j$(getconf _NPROCESSORS_ONLN) --deployment --without test development \
 && yarn install --pure-lockfile --ignore-engines \
 && yarn cache clean

COPY . /sample

RUN OTP_SECRET=precompile_placeholder SECRET_KEY_BASE=precompile_placeholder bundle exec rails assets:precompile
