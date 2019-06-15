class AddTokenzToChoice < ActiveRecord::Migration[5.2]
  def change
    change_table(:choices) do |t|
      t.string :read_token, :edit_token, limit: 32
      t.index :read_token, unique: true
      t.index :edit_token, unique: true
    end
  end
end
