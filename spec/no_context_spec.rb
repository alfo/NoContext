require_relative "spec_helper"
require_relative "../no_context.rb"

def app
  NoContext
end

describe NoContext do
  it "responds with a welcome message" do
    get '/'

    last_response.body.must_include 'Welcome to the Sinatra Template!'
  end
end
