require 'test_helper'

class TokenzTest < ActiveSupport::TestCase
  setup do
    @choice = create_full_choice
    @choice.save!
  end

  test 'generates read token on first save' do
    refute_nil(@choice.id)
    refute_nil(@choice.read_token)
  end

  test 'generates edit token on first save' do
    refute_nil(@choice.id)
    refute_nil(@choice.edit_token)
  end

  test 'does not alter token on subsequent save' do
    edit_token = @choice.edit_token
    refute_nil(edit_token)
    read_token = @choice.read_token
    refute_nil(read_token)
    @choice.title = 'And when you write, do you change?'
    @choice.save!
    assert_equal(edit_token, @choice.edit_token)
    assert_equal(read_token, @choice.read_token)
  end
end
