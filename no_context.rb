require 'yaml'

class NoContext < Sinatra::Base

  set :public_folder => "public", :static => true

  get "/" do
    redirect 'http://remote.bergcloud.com/publications/380'
  end

  get "/edition" do

  	# Initialize Reddit Client
  	client = Snooby::Client.new

  	# Random number
  	rand = (1..6).to_a.sample

  	# Grab the hilarity
  	@hilarity = client.r('nocontext').posts[rand].title

  	# When is right now?
  	right_now = Time.parse(params[:local_delivery_time])

  	# Is it a weekend? If so, no hilarity for you today.
  	if right_now.saturday? or right_now.sunday?
  		return 204, 'No publication today'
  		etag Digest::MD5.hexdigest('empty' + right_now.strftime('%d%m%Y'))
  	end

  	# Filter the obscenity if you're British
  	@hilarity = Obscenity.sanitize(@hilarity) if params[:we_are_british] == 'true'

  	# Output the ETag
  	etag Digest::MD5.hexdigest(@hilarity + right_now.strftime('%d%m%Y'))

  	# Render the publication
  	erb :edition
  end

end
