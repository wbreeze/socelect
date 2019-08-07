# Used  by ChoicesController#edit to set-up edit token

module Choice::Edit
  def id
    edit_token
  end
end
