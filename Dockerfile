FROM debian:latest as image_base
WORKDIR /app

# Install all dependencies and packages
RUN apt-get update -qq && \
    apt-get install --reinstall -y ca-certificates && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libffi-dev libedit-dev libreadline6-dev libyaml-dev libvips pkg-config zlib1g-dev tar gpg gpg-agent curl redis

# Install asdf with plugins
RUN git clone https://github.com/asdf-vm/asdf.git /usr/local/asdf

ENV ASDF_DATA_DIR="/usr/local/asdf" \
    PATH="$PATH:/usr/local/asdf/bin:/usr/local/asdf/shims"

RUN asdf plugin add ruby && \
    asdf plugin add nodejs && \
    asdf plugin add yarn

# Copy .tool-versions file & install versions from .tool-versions file
COPY .tool-versions .
RUN asdf install

# Set environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    PATH="$PATH:/usr/local/bundle/bin"

FROM image_base as application_base

# Install Ruby packages
COPY Gemfile Gemfile.lock ./
RUN bundle install && rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Precompile assets
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

FROM application_base as prod_app

# Copy all installed gems and application code
COPY --from=application_base /usr/local/bundle /usr/local/bundle
COPY --from=application_base /app /app

# Run and access log and tmp as non-root user
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails log tmp public
USER rails:rails

# Expose port 3000 and start application
EXPOSE 3000
ENTRYPOINT ["bash", "-c"]
CMD ["bundle exec foreman start -f Procfile.prod"]
