require 'yaml'

class NoContext < Sinatra::Base

  set :public_folder => "public", :static => true

  get "/" do
    redirect 'http://remote.bergcloud.com/publications/347'
  end

  get "/edition/" do

    # Do param checking
    return 400, 'Error: No local_delivery_time was provided' if params[:local_delivery_time].nil?

  	# Initialize Reddit Client
  	client = Snooby::Client.new

  	# Make a totes random number
  	totes_random = (1..6).to_a.sample

  	# Grab the hilarity
  	@hilarity = client.r('nocontext').posts[totes_random].title

  	# When is right now?
  	right_now = Time.parse(params[:local_delivery_time])

  	# Is it a weekend? If so, no hilarity for you today.
  	if right_now.saturday? or right_now.sunday?
  		
      # Tell BERGCloud that nothing's happening
      return 204, 'No hilarity for you today'

      # Make sure they really know it
  		etag Digest::MD5.hexdigest('nope.' + right_now.strftime('%d%m%Y'))
  	end

  	# Filter the obscenity if you're British
  	@hilarity = Obscenity.sanitize(@hilarity) if params[:we_are_british] == 'true'

  	# Output the ETag
  	etag Digest::MD5.hexdigest(@hilarity + right_now.strftime('%d%m%Y'))

  	# Render the publication
  	erb :edition
  end

  get "/sample/" do

    # Preset some hilarity
    @hilarity = "In the criminal justice system, YOLO-based offenses are considered especially LOL."

    # Render the publication
    erb :edition
  end

  post "/validate_config/" do

    # This bit is all stolen from the example
    # which can be found here:
    # http://remote.bergcloud.com/developers/examples/

    response = {}
    response[:errors] = []
    response[:valid] = true
    
    if params[:config].nil?
      return 400, "You did not post any config to validate"
    end

    # Extract config from POST
    user_settings = JSON.parse(params[:config])

    if user_settings['we_are_british']
      unless user_settings['we_are_british'] == 'true' or user_settings['we_are_british'] == 'false'
        response[:valid] = false
        response[:errors].push('The profanity filter must be set to on or off.')
      end
    end

    content_type :json
    response.to_json

  end

end
