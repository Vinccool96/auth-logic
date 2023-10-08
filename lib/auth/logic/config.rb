# frozen_string_literal: true

module Authentication
  module Logic
    # Mixed into `Authentication::Logic::ActsAsAuthentic::Base` and
    # `Authentication::Logic::Session::Base`.
    module Config
      E_USE_NORMAL_RAILS_VALIDATION = <<~EOS
        This Authentication::Logic configuration option (%s) is deprecated. Use normal
        ActiveRecord validation instead. Detailed instructions:
        https://github.com/vinccool96/auth-logic/blob/master/doc/use_normal_rails_validation.md
      EOS

      def self.extended(klass)
        klass.class_eval do
          class_attribute :acts_as_authentic_config
          self.acts_as_authentic_config ||= {}
        end
      end

      private

      def deprecate_auth_logic_config(method_name)
        ::ActiveSupport::Deprecation.warn(
          format(E_USE_NORMAL_RAILS_VALIDATION, method_name)
        )
      end

      # This is a one-liner method to write a config setting, read the config
      # setting, and also set a default value for the setting.
      def rw_config(key, value, default_value = nil)
        if value.nil?
          acts_as_authentic_config.include?(key) ? acts_as_authentic_config[key] : default_value
        else
          self.acts_as_authentic_config = acts_as_authentic_config.merge(key => value)
          value
        end
      end
    end
  end
end
