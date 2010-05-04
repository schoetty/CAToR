class CreatePossibleSolutions < ActiveRecord::Migration
  def self.up
    create_table :possible_solutions do |t|
      t.integer :item_id, :correct
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :possible_solutions
  end
end
