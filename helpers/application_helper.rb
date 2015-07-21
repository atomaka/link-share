helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    return unless @auth.provided? and @auth.basic?

    username, password = @auth.credentials

    user_exists?(username) && settings.users[username] == password
  end

  def user_exists?(username)
     settings.users.keys.include?(username)
  end
end
