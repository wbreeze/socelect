require 'test_helper'

class BrowsingTest < ActionDispatch::IntegrationTest
    PUBLIC_COUNT = 7
    PRIVATE_COUNT = 4

  setup do
    @public_choices = []
    PUBLIC_COUNT.times do
      choice = create_full_choice(public: true)
      choice.save!
      @public_choices << choice
    end

    @private_choices = []
    PRIVATE_COUNT.times do
      choice = create_full_choice(public: false)
      choice.save!
      @private_choices << choice
    end
  end

  test 'visit home page' do
    get root_path
    assert_response :success
  end

  test 'home page shows public choices' do
    get root_path

    assert_select('ul#public-choices')
    assert_select('body', /Some publicly shared choices/)
    @public_choices.each do |choice|
      assert_select('li', /#{choice.title}/)
      assert_select("a[href='#{choice_url(id: choice.read_token)}']")
    end
  end

  test 'home page does not show private choices' do
    get root_path

    @private_choices.each do |choice|
      sels = css_select(/#{choice.title}/)
      assert_equal(0, sels.count)
      sels = css_select("a[href='#{choice_url(id: choice.read_token)}']")
      assert_equal(0, sels.count)
    end
  end

  test 'home page does not offer list when no open, public choices' do
    Choice.update_all(public: false)
    get root_path

    sels = css_select('ul#public-choices')
    assert_equal(0, sels.count)

    sels = css_select(/Some publicly shared choices/)
    assert_equal(0, sels.count)
  end
end
