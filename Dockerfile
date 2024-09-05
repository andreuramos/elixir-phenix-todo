# Use the official Elixir image from Docker Hub
FROM elixir:1.14

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Install Node.js (necessary for Phoenix static assets)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs inotify-tools
RUN mix archive.install hex phx_new --force

# Set environment variables
ENV MIX_ENV=dev

# Set working directory
RUN mkdir /app
COPY . /app
WORKDIR /app

# Expose Phoenix server port
EXPOSE 4000

# Start a shell to keep the container running
CMD ["iex"]