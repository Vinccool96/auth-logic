# frozen_string_literal: true

module Authentication
  module Logic
    module ControllerAdapters
      # Adapts auth-logic to work with rails. The point is to close the gap between
      # what auth-logic expects and what the rails controller object provides.
      # Similar to how ActiveRecord has an adapter for MySQL, PostgreSQL, SQLite,
      # etc.
      class RailsAdapter < AbstractAdapter
        def authenticate_with_http_basic(&block)
          controller.authenticate_with_http_basic(&block)
        end

        # Returns a `ActionDispatch::Cookies::CookieJar`. See the AC guide
        # http://guides.rubyonrails.org/action_controller_overview.html#cookies
        def cookies
          controller.respond_to?(:cookies, true) ? controller.send(:cookies) : nil
        end

        def cookie_domain
          controller.request.session_options[:domain]
        end

        def request_content_type
          request.format.to_s
        end

        # Lets Authentication::Logic know about the controller object via a before filter, AKA
        # "activates" auth-logic.
        module RailsImplementation
          def self.included(klass) # :nodoc:
            klass.prepend_before_action :activate_auth_logic
          end

          private

          def activate_auth_logic
            Authentication::Logic::Session::Base.controller = RailsAdapter.new(self)
          end
        end
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  include Authentication::Logic::ControllerAdapters::RailsAdapter::RailsImplementation
end
