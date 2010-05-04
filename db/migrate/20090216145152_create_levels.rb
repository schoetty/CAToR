class CreateLevels < ActiveRecord::Migration
  def self.up
    create_table(:levels) { |t| t.integer :difficulty }
  end

  def self.down
    drop_table :levels
  end
end
