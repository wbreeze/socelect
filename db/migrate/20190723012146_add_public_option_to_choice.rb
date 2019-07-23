class AddPublicOptionToChoice < ActiveRecord::Migration[5.2]
  def change
    add_column :choices, :public, :boolean, default: false, null: false
    add_index :choices, :public
    add_index :choices, :deadline
  end
end
