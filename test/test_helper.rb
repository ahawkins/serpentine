# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'simplecov'
SimpleCov.start

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Dummy::Application.routes.draw do
  match ':controller(/:action(/:id))(.:format)'
end

class ApplicationController
  def render_results
    render :json => collection.map(&:key)
  end
end
