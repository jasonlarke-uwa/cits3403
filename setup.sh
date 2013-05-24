#!/bin/sh
mkdir public/i/
mkdir app/assets/javascripts/common/
bundle install
rake db:create
rake db:migrate
