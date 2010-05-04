class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams do |t|
      t.integer :user_id, :category_id, :variance
      t.float :theta
      t.text :thetas
      t.datetime :end
      t.timestamps
    end
  end

  def self.down
    drop_table :exams
  end
end
