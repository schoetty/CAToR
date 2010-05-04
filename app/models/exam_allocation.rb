class ExamAllocation < ActiveRecord::Base

  belongs_to :category
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :student, :class_name => 'User', :foreign_key => 'student_id'
  
  validates_presence_of :category_id, :creator_id, :student_id

  protected

  def self.existing?(allocation)
    if ExamAllocation.all(:conditions => { :student_id => allocation.student_id, :category_id => allocation.category_id }).empty?
      return false
    else
      return true
    end
  end

end
