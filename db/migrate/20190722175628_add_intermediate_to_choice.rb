class AddIntermediateToChoice < ActiveRecord::Migration[5.2]
  def change
    add_column(:choices, :intermediate, :boolean, default: false, null: false)
  end
end
