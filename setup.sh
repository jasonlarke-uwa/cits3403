#!/bin/sh
sudo mkdir public/i/
sudo mkdir app/assets/javascripts/common/
sudo bundle install
sudo rake db:create
sudo rake db:migrate
