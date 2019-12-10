class InitializeResultStateForExistingChoices < ActiveRecord::Migration[5.2]
  def up
    Choice.update_all(result_state: Choice.result_states[:dirty])
  end
end
