require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
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

  test 'visit' do
    get root_path
    assert_response :success
  end

  test 'shows public choices' do
    get root_path

    assert_select('ul#public-choices')
    assert_select('body', /Some publicly shared choices/)
    @public_choices.each do |choice|
      assert_select("a[href='#{choice_url(id: choice.read_token)}']")
    end
  end

  test 'does not show private choices' do
    get root_path

    @private_choices.each do |choice|
      sels = css_select("a[href='#{choice_url(id: choice.read_token)}']")
      assert_equal(0, sels.count)
    end
  end

  test 'does not offer list when no open, public choices' do
    Choice.update_all(public: false)
    get root_path

    sels = css_select('ul#public-choices')
    assert_equal(0, sels.count)

    sels = css_select(/Some publicly shared choices/)
    assert_equal(0, sels.count)
  end

  test 'shows result link on open choice with intermediate set' do
    choice = @public_choices.first
    choice.intermediate = true
    choice.save!
    get root_path

    assert_select("a[href='#{result_choice_url(id: choice.read_token)}']")
  end

  test 'does not show result link on open choice unless intermediate set' do
    get root_path

    choice = @public_choices.first
    assert_select('ul#public-choices') do |elements|
      elements.each do |el|
        query = (".//a[@href='#{result_choice_url(id: choice.read_token)}']")
        sels = el.xpath(query)
        assert_equal(0, sels.count)
      end
    end
  end

  test 'does not include closed choices in public choices' do
    choice = @public_choices.first
    choice.deadline = Time.now - 1.minute
    choice.save!
    get root_path

    assert_select('ul#public-choices') do |elements|
      elements.each do |el|
        query = (".//a[@href='#{result_choice_url(id: choice.read_token)}']")
        sels = el.xpath(query)
        assert_equal(0, sels.count)
      end
    end
  end
end
