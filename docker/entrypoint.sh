#!/bin/bash

if [[ `bundle -v` =~ "Bundler version 2" ]]; then
  bundle config set --local path '/bundle/cache'
  bundle config set --local without 'development'
else
  bundle config --local path '/bundle/cache'
  bundle config --local without 'development'
fi

bundle

ruby index.rb

rm Gemfile.lock
