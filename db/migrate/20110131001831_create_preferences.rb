class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table 'preferences' do |t|
      t.string 'host', :limit=>256
      t.string 'ip', :limit=>32
      t.string 'chef', :limit=>256
      t.integer 'person'
      t.integer 'choice'
    end
  end

  def self.down
    drop_table 'preferences'
  end
end
