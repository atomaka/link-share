require './config/init'

get '/manage' do
  protected!

  @links = get_links(params[:status])

  slim :manage
end

get '/new' do
  protected!

  @link = Link.new

  slim :new
end

post '/' do
  protected!

  @link = Link.new(params[:link])

  if @link.save
    flash[:success] = 'Link has been created'
    redirect '/manage'
  else
    flash.now[:danger] = 'Did not pass validations'
    slim :new
  end
end

get '/send' do
  protected!

  @link = Link.find(params[:id])

  @link.mark_sent
  SmsNotifier.notify(@link)

  flash[:success] = 'Link has been marked as sent'
  redirect '/manage'
end

get '/destroy' do
  protected!

  @link = Link.find(params[:id])

  if @link.sent?
    flash[:warning] = 'Cannot delete sent link'
  else
    @link.destroy
    flash[:success] = 'Link has been deleted'
  end

  redirect '/manage'
end

get '/' do
  slim :calendar
end

get '/events' do
  start = params[:start]
  finish = params[:end]

  json serialize(Link.calendar(start, finish))
end

private
  def get_links(status)
    if status == 'sent'
      Link.sent
    elsif status == 'all'
      Link.all
    else
      Link.unsent
    end
  end

  def serialize(events)
    events.map do |event|
      {
        title: event.title,
        url: event.url,
        start: event.sent_at.in_time_zone('Eastern Time (US & Canada)')
      }
    end
  end
