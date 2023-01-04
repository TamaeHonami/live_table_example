FROM elixir:1.14.2-slim

WORKDIR /app

ENV PHX_VERSION 1.6.15
RUN \
  apt-get update && apt-get install -y \
  inotify-tools git npm && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  mix do \
    local.hex --force, \
    local.rebar --force, \
    archive.install --force hex phx_new ${PHX_VERSION}
