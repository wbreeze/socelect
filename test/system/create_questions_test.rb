require "application_system_test_case"

class CreateQuestionsTest < ApplicationSystemTestCase
  def setup
    @create_question_xpath =
      '//form/input[@type="submit" and contains(@value, "Create")]'
  end

  test "visiting the index" do
    visit root_path
    button = find(:xpath, @create_question_xpath)
  end

  test "create a question" do
    title = Faker::Book.title
    description = Faker::Quote.yoda
    alt_ct = 2
    alt_titles = alt_ct.times.collect { Faker::Book.unique.title }
    alt_descriptions = alt_ct.times.collect do
      Faker::Quote.most_interesting_man_in_the_world
    end

    visit new_choice_path
    within('form.new_choice') do
      fill_in(id: 'choice_title', with: title)
      fill_in(id: 'choice_description', with: description)
    end
    alt_title_inputs = all(:xpath,
      '//div[contains(@class,"alternative")]//input[@type="text"]')
    assert_equal(alt_titles.length, alt_title_inputs.length);
    alt_title_inputs.each_with_index do |input, i|
      input.fill_in(with: alt_titles[i])
    end
    alt_description_inputs = all(:xpath,
      '//div[contains(@class,"alternative")]//textarea')
    assert_equal(alt_descriptions.length, alt_description_inputs.length);
    alt_description_inputs.each_with_index do |ta, i|
      ta.fill_in(with: alt_descriptions[i])
    end
    find(:xpath, '//input[@type="submit" and @name="commit"]').click

    text = find('div.choiceTitle').text()
    assert_equal(title, text);
    text = find('div.choiceDescription').text()
    assert_equal(description, text);
    alt_divs = all('div.alternative')
    assert_equal(alt_titles.length, alt_divs.length);
    alt_divs.each_with_index do |div, i|
      within div do
        text = find('div.alternativeTitle').text()
        assert_equal(alt_titles[i], text)
        text = find('div.alternativeDescription').text()
        assert_equal(alt_descriptions[i], text)
      end
    end
  end
end
