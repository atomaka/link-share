helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    return unless @auth.provided? && @auth.basic?

    authenticate?(@auth.credentials)
  end

  def authenticate?(credentials)
    username, password = credentials
    users.keys.include?(username) && users[username] == password
  end

  def users
    settings.users
  end
end
