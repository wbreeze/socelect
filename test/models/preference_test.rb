require 'test_helper'

class PreferenceTest < ActiveSupport::TestCase
  include PreferenceHelper

  test "converts preference to ranks" do
    choice = create_full_choice({}, 12)
    ranks = [1, 2, 3, 3, 5, 6, 6, 6, 9, 10, 11, 12].shuffle
    preference = create_preference_parto(choice, ranks)
    preference.extend(Preference::RankCoding)
    assert_equal(ranks, preference.rank_encoding)
  end
end
