# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "grit"
  config.gem "RedCloth"

  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_gwiki_session',
    :secret      => 'aeb0f60430aeda02d9dbed26224752f35ac522f0546e0699aaa8f1b389a782a3d7d1b949c5f6c520fee4b616ff65f44a8ebd7cc127a1380c6d4e09c1f7f9b775'
  }
end
