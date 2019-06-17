require "application_system_test_case"

class ChoiceConfirmTest < ApplicationSystemTestCase
  setup do
    @choice = create_full_choice
    @choice.save!
    @alternative = @choice.alternatives.first
    visit choice_path(@choice.read_token)
    radio = find(:xpath,
      "//form/dl[@class='alternatives']//input[@value='#{@alternative.id}']")
    radio.click
    click_on "Submit preference"
  end

  test "confirm shows choice" do
    assert_text("You selected: #{@alternative.title}")
  end

  test "confirm shows results link" do
    assert_xpath(<<~PATH.gsub("\n",'')
      //div[@class="content"]
      //a[@href="#{result_choice_path(@choice.read_token)}"]
      PATH
    )
  end
end
