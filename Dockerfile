FROM ruby:2.6.3-alpine

RUN apk add curl sudo

RUN adduser --disabled-password --gecos '' docker sudo

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker 

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apk add --update && apk add \
  libxml2-dev \
  libxslt-dev \
  bash \
  build-base \
  yarn \
  nodejs \
  postgresql-dev \
  unzip \
  libexif \
  udev \
  chromium \
  chromium-chromedriver \
  xvfb \
  xorg-server \
  dbus \
  ttf-freefont \
  mesa-dri-swrast \
  && rm -rf /var/cache/apk/*


RUN mkdir /app
WORKDIR /app

# Do not generate documentation when installing gems and fix shebang
# lines
RUN echo "gem: --no-rdoc --no-ri --env-shebang" >> "$HOME/.gemrc"


COPY Gemfile Gemfile.lock ./
RUN gem install rails bundler:2.1.4
RUN bundle install

ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/

COPY . .

CMD ["/bin/sh"]

