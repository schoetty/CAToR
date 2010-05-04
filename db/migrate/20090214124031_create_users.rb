class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name, :surname, :email, :login, :password
      t.integer :creator_id, :matriculation_number
      t.boolean :is_admin
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
