class CreateAlternatives < ActiveRecord::Migration
  def self.up
    create_table :alternatives do |t|
      t.string :title, :limit=>256, :null=>false
      t.text :description
      t.integer :choice_id

      t.timestamps
    end
  end

  def self.down
    drop_table :alternatives
  end
end
