class AddComputationStateToChoices < ActiveRecord::Migration[5.2]
  def change
    add_column :choices, :result_state, :integer
    add_column :choices, :result_parto, :text

    add_index :choices, :result_state
  end
end
