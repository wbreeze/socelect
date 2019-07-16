require "application_system_test_case"

class ChoiceConfirmTest < ApplicationSystemTestCase
  setup do
    @choice = create_full_choice
    @choice.save!
    visit choice_path(@choice.read_token)
    click_on "Submit preference"
  end

  test "confirm shows choice" do
    assert_text("You selected:")
    @choice.alternatives.each do |alt|
      assert_text(alt.title)
    end
  end

  test "confirm shows results link" do
    assert_xpath(<<~PATH.gsub("\n",'')
      //div[@class="content"]
      //a[@href="#{result_choice_path(@choice.read_token)}"]
      PATH
    )
  end
end
