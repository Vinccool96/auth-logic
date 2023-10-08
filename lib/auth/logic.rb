# frozen_string_literal: true

require_relative "logic/version"
require "active_support/all"

require "active_record"

path = "#{File.dirname(__FILE__)}/auth/logic/"

[
  "errors",
  "i18n",
  "random",
  "config",

  "controller_adapters/abstract_adapter",
  "cookie_credentials",

  "crypto_providers",

  "acts_as_authentic/email",
  "acts_as_authentic/logged_in_status",
  "acts_as_authentic/login",
  "acts_as_authentic/magic_columns",
  "acts_as_authentic/password",
  "acts_as_authentic/perishable_token",
  "acts_as_authentic/persistence_token",
  "acts_as_authentic/session_maintenance",
  "acts_as_authentic/single_access_token",
  "acts_as_authentic/base",

  "session/magic_column/assigns_last_request_at",
  "session/base"
].each do |library|
  require path + library
end

require "#{path}controller_adapters/rails_adapter"   if defined?(Rails)
require "#{path}controller_adapters/sinatra_adapter" if defined?(Sinatra)

module Authentication
  module Logic
    class Error < StandardError; end
    # Your code goes here...
  end
end
