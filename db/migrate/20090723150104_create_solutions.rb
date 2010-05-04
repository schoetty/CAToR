class CreateSolutions < ActiveRecord::Migration
  def self.up
    create_table :solutions do |t|
      t.integer :item_id, :exam_id, :correctness, :latency, :sequence
      t.float :p
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :solutions
  end
end
