class Category < ActiveRecord::Base

  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  has_many :items
  has_many :exams

  validates_presence_of :content
  validates_uniqueness_of :content
end
