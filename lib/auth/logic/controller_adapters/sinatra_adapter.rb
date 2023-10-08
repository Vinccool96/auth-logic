# frozen_string_literal: true

# Auth::Logic bridge for Sinatra
module Auth
  module Logic
    module ControllerAdapters
      module SinatraAdapter
        # Cookie management functions
        class Cookies
          attr_reader :request, :response

          def initialize(request, response)
            @request = request
            @response = response
          end

          def delete(key, options = {})
            @response.delete_cookie(key, options)
          end

          def []=(key, options)
            @response.set_cookie(key, options)
          end

          def method_missing(meth, *args, &block)
            @request.cookies.send(meth, *args, &block)
          end
        end

        # Thin wrapper around request and response.
        class Controller
          attr_reader :request, :response, :cookies

          def initialize(request, response)
            @request = request
            @cookies = Cookies.new(request, response)
          end

          def session
            env["rack.session"]
          end

          def method_missing(meth, *args, &block)
            @request.send meth, *args, &block
          end
        end

        # Sinatra controller adapter
        class Adapter < AbstractAdapter
          def cookie_domain
            env["SERVER_NAME"]
          end

          # Mixed into `Sinatra::Base`
          module Implementation
            def self.included(klass)
              klass.send :before do
                controller = Controller.new(request, response)
                Auth::Logic::Session::Base.controller = Adapter.new(controller)
              end
            end
          end
        end
      end
    end
  end
end

Sinatra::Base.include Auth::Logic::ControllerAdapters::SinatraAdapter::Adapter::Implementation
