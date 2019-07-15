require 'test_helper'
require 'choice/parto_coding'

class PartoCodingTest < ActiveSupport::TestCase
  setup do
    @choice = create_full_choice
    @choice.save!
    @choice.extend(Choice::PartoCoding)
    @parto = @choice.parto_encoding
  end

  test "encodes choice alternatives" do
    assert(@parto.kind_of?(Array))
    assert_equal(@choice.alternatives.count, @parto.length)
    @choice.alternatives.each do |alt|
      assert(@parto.include?({ key: alt.id.to_s, description: alt.title }))
    end
  end
end
