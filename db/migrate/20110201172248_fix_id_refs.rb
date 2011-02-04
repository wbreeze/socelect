class FixIdRefs < ActiveRecord::Migration
  def self.up
    rename_column :expressions, :alternative, :alternative_id
    rename_column :expressions, :preference, :preference_id
    rename_column :preferences, :person, :person_id
    rename_column :preferences, :choice, :choice_id
  end

  def self.down
    rename_column :expressions, :alternative_id, :alternative
    rename_column :expressions, :preference_id, :preference
    rename_column :preferences, :person_id, :person
    rename_column :preferences, :choice_id, :choice
  end
end
