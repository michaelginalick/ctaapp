# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!



# Some helper constants for path-centric logic
# APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

# APP_NAME = APP_ROOT.basename.to_s

# configure do
#   set :root, APP_ROOT.to_path
#   enable :sessions
#   set :session_secret, ENV['SESSION_SECRET'] || 'this is a secret shhhhh'
#   set :views, File.join(Sinatra::Application.root, "app", "views")

#   require 'redis'
#   uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/" )
# 	REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
# end


# Set up the controllers, helpers, and workers
# Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
# Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }
# Dir[APP_ROOT.join('app', 'workers', '*.rb')].each { |file| require file }

# # Set up the database and models
# require APP_ROOT.join('config', 'database')
# require APP_ROOT.join('config', 'keys') if development?

# also_reload 'app/models/*' if development?
