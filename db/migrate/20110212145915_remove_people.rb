class RemovePeople < ActiveRecord::Migration
  def self.up
    drop_table :people
  end

  def self.down
    create_table :people do |t|
      t.string :email
    end
  end
end
