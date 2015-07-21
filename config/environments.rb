set :database, 'sqlite3:db/linkshare.db'

configure :production do
  config_file 'config/app.yml'
end

configure :development do
  set :show_exceptions, true
  config_file 'config/app.yml'
end

configure :test do
  set :database, 'sqlite3:db/test.db'
  config_file 'spec/fixtures/app.yml'
end
