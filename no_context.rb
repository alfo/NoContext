class NoContext < Sinatra::Base

  set :public_folder => "public", :static => true

  get "/" do
    erb :welcome
  end

  get "/edition" do
  	client = Snooby::Client.new
  	@hilarity = client.r('nocontext').posts.first.title

  	today = Time.now

  	# if today.saturday? or today.sunday?
  	# 	return 204, 'No publication today'
  	# 	etag Digest::MD5.hexdigest('empty' + today.strftime('%d%m%Y'))
  	# end

  	etag Digest::MD5.hexdigest(@hilarity+today.strftime('%d%m%Y'))

  	erb :edition
  end

end
