class AddRelationsToExpressions < ActiveRecord::Migration
  def self.up
    add_column :expressions, :alternative, :integer
    add_column :expressions, :preference, :integer
  end

  def self.down
    remove_column :expressions, :alternative
    remove_column :expressions, :preference
  end
end
