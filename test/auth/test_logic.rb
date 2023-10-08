# frozen_string_literal: true

require "test_helper"

module Auth
  class TestLogic < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Auth::Logic::VERSION
    end

    def test_it_does_something_useful
      assert false
    end
  end
end
