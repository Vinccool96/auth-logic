# frozen_string_literal: true

module Authentication
  module Logic
    module ActsAsAuthentic
      # Provides the base functionality for acts_as_authentic
      module Base
        def self.included(klass)
          klass.class_eval do
            class_attribute :acts_as_authentic_modules
            self.acts_as_authentic_modules ||= []
            extend Authentication::Logic::Config
            extend Config
          end
        end

        # The primary configuration of a model (often, `User`) for use with
        # auth-logic. These methods become class methods of ::ActiveRecord::Base.
        module Config
          # This includes a lot of helpful methods for authenticating records
          # which the Authentication::Logic::Session module relies on. To use it just do:
          #
          #   class User < ApplicationRecord
          #     acts_as_authentic
          #   end
          #
          # Configuration is easy:
          #
          #   acts_as_authentic do |c|
          #     c.my_configuration_option = my_value
          #   end
          #
          # See the various sub modules for the configuration they provide.
          def acts_as_authentic
            yield self if block_given?
            return unless db_setup?

            acts_as_authentic_modules.each { |mod| include mod }
          end

          # Since this part of Authentication::Logic deals with another class, ActiveRecord,
          # we can't just start including things in ActiveRecord itself. A lot of
          # these module includes need to be triggered by the acts_as_authentic
          # method call. For example, you don't want to start adding in email
          # validations and what not into a model that has nothing to do with
          # Authentication::Logic.
          #
          # That being said, this is your tool for extending Authentication::Logic and
          # "hooking" into the acts_as_authentic call.
          def add_acts_as_authentic_module(mod, action = :append)
            modules = acts_as_authentic_modules.clone
            case action
            when :append
              modules << mod
            when :prepend
              modules = [mod] + modules
            end
            modules.uniq!
            self.acts_as_authentic_modules = modules
          end

          # This is the same as add_acts_as_authentic_module, except that it
          # removes the module from the list.
          def remove_acts_as_authentic_module(mod)
            modules = acts_as_authentic_modules.clone
            modules.delete(mod)
            self.acts_as_authentic_modules = modules
          end

          # Some Authentication::Logic modules requires a database connection with a existing
          # users table by the moment when you call the `acts_as_authentic`
          # method. If you try to call `acts_as_authentic` without a database
          # connection, it will raise a `Authentication::Logic::ModelSetupError`.
          #
          # If you rely on the User model before the database is setup correctly,
          # set this field to false.
          # * <tt>Default:</tt> false
          # * <tt>Accepts:</tt> Boolean
          def raise_on_model_setup_error(value = nil)
            rw_config(:raise_on_model_setup_error, value, false)
          end
          alias raise_on_model_setup_error= raise_on_model_setup_error

          private

          def db_setup?
            column_names
            true
          rescue StandardError
            raise ModelSetupError if raise_on_model_setup_error

            false
          end

          def first_column_to_exist(*columns_to_check)
            if db_setup?
              columns_to_check.each do |column_name|
                return column_name.to_sym if column_names.include?(column_name.to_s)
              end
            end
            columns_to_check.first&.to_sym
          end
        end
      end
    end
  end
end

::ActiveRecord::Base.include Authentication::Logic::ActsAsAuthentic::Base
::ActiveRecord::Base.include Authentication::Logic::ActsAsAuthentic::Email
::ActiveRecord::Base.include Authentication::Logic::ActsAsAuthentic::LoggedInStatus
::ActiveRecord::Base.include Authentication::Logic::ActsAsAuthentic::Login
::ActiveRecord::Base.include Authentication::Logic::ActsAsAuthentic::MagicColumns
::ActiveRecord::Base.include Authentication::Logic::ActsAsAuthentic::Password
::ActiveRecord::Base.include Authentication::Logic::ActsAsAuthentic::PerishableToken
::ActiveRecord::Base.include Authentication::Logic::ActsAsAuthentic::PersistenceToken
::ActiveRecord::Base.include Authentication::Logic::ActsAsAuthentic::SessionMaintenance
::ActiveRecord::Base.include Authentication::Logic::ActsAsAuthentic::SingleAccessToken
