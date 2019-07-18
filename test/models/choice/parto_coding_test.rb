require 'test_helper'
require 'choice/parto_coding'

class PartoCodingTest < ActiveSupport::TestCase
  setup do
    @choice = create_full_choice
    @choice.save!
    @choice.extend(Choice::PartoCoding)
    @parto = @choice.parto_items_encoding
  end

  test "encodes choice alternatives" do
    assert(@parto.kind_of?(String))
    encoded_items = JSON.parse(@parto)
    assert(encoded_items.kind_of?(Array))
    assert_equal(@choice.alternatives.count, encoded_items.length)
    @choice.alternatives.each do |alt|
      item = { "key" => alt.id.to_s, "description" => alt.title }
      assert(encoded_items.include?(item))
    end
  end
end
