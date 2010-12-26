class CreateChoices < ActiveRecord::Migration
  def self.up
    create_table :choices do |t|
      t.string :title, :limit=>256, :null=>false
      t.text :description
      t.datetime :opening
      t.datetime :deadline

      t.timestamps
    end
  end

  def self.down
    drop_table :choices
  end
end
