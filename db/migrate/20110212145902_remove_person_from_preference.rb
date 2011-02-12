class RemovePersonFromPreference < ActiveRecord::Migration
  def self.up
    remove_column(:preferences, :person_id)
  end

  def self.down
    add_column(:preferences, :person_id, :integer)
  end
end
