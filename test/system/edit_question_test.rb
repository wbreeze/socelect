require "application_system_test_case"

class EditQuestionsTest < ApplicationSystemTestCase
  def setup
    @choice = create_full_choice
    @choice.save
    @original_title = @choice.title
    visit edit_choice_path(@choice.edit_token)
  end

  test "can edit and republish" do
    title = 'And now, this?'
    fill_in(id: 'choice_title', with: title)
    find(:xpath, '//input[@type="submit" and @name="commit"]').click

    text = find('div.choiceTitle').text()
    assert_equal(title, text);
  end

  test "can edit and cancel" do
    title = 'And now, this?'
    fill_in(id: 'choice_title', with: title)
    click_on 'Cancel'

    text = find('div.choiceTitle').text()
    assert_equal(@original_title, text);
  end
end
