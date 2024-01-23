FROM bash:latest as image_base
WORKDIR /root
SHELL ["bash", "-c" ]

# Install all important packages, redis server, asdf and it's related dependencies
RUN apk update && \
    apk add --no-cache \
    build-base  \
    patch \
    bzip2 \
    libffi-dev \
    openssl-dev \
    ncurses-dev \
    gdbm-dev \
    zlib-dev \
    readline-dev \
    yaml-dev \
    gpg-agent \
    gcompat \
    tar gpg \
    redis \
    git curl && \
    rm -rf /var/cache/apk/* && \
    \
    \
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf && \
    echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc && \
    echo ". $HOME/.asdf/asdf.sh" >> ~/.zshrcs && \
    source ~/.bashrc && \
    \
    \
    asdf plugin add ruby && \
    asdf plugin add nodejs && \
    asdf plugin add yarn &&  \
    mkdir app

# Set working directory
WORKDIR /root/app

# Copy .tool-versions file & install versions from .tool-versions file
COPY .tool-versions .
RUN source ~/.bashrc && asdf install

# Set Rails production environments
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

FROM image_base as application_base

# Install Ruby packages
COPY Gemfile Gemfile.lock ./
RUN source ~/.bashrc && bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Precompile assets
RUN source ~/.bashrc && SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM application_base as prod_app
COPY --from=application_base /usr/local/bundle /usr/local/bundle
COPY --from=application_base /root/app /root/app

# Run and own only the runtime files as a non-root user for security
RUN adduser --disabled-password \
            --gecos "" \
            --no-create-home \
            docker_user \
    && \
    chown -R docker_user log tmp

USER docker_user

## Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/prod"]
