ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
Dir.glob(
  File.join(File.expand_path('../helpers', __FILE__), '*_helper.rb')
).each do |helper|
  require helper
end
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def assert_invalid_record(record, reason)
    refute(record.save)
    assert_raises(ActiveRecord::RecordInvalid) do
      begin
        record.save!
      rescue ActiveRecord::RecordInvalid => e
        assert_match(reason, e.message)
        raise
      end
    end
  end
end
