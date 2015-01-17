# spec/spec_helper.rb
require 'rack/test'
require 'rspec'
require File.expand_path('../../app.rb', __FILE__)
Dir.glob('./{models helpers}/*.rb').each { |file| require file }

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

# For RSpec 2.x
RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.syntax = [:expect, :should]
  end
  config.include RSpecMixin
end

# to get the sesssion
def session
  last_request.env['rack.session']
end
