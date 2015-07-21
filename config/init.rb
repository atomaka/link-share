require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'sinatra/config_file'
require 'sinatra/json'
Bundler.require

set :root, File.dirname('..')

require_relative 'environments'

require_relative '../models/link'
require_relative '../helpers/application_helper'

config_file 'config/app.yml'

use Rack::Session::Cookie, secret: settings.secret
