require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'sinatra/config_file'
require 'sinatra/json'
Bundler.require
Dotenv.load

set :root, File.dirname('..')

require_relative 'environments'

require_relative '../models/link'
require_relative '../helpers/application_helper'
require_relative '../lib/sms_notifier'

config_file 'config/app.yml'

use Rack::Session::Cookie, secret: settings.secret
