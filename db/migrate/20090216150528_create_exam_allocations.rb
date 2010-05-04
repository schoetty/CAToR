class CreateExamAllocations < ActiveRecord::Migration
  def self.up
    create_table :exam_allocations do |t|
      t.integer :creator_id, :student_id, :category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :exam_allocations
  end
end
