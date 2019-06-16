class AddTokenToPreference < ActiveRecord::Migration[5.2]
  def change
    add_column(:preferences, :token, :string, limit: 32)
    add_index(:preferences, :token, unique: true)
  end
end
