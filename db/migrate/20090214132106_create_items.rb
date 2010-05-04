class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :level_id, :category_id, :creator_id
      t.text :content, :description
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
