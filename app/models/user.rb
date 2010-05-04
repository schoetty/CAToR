class User < ActiveRecord::Base

  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  has_many :exams
  has_many :solutions, :through => :exams

  #set_table_name 'user'  # legacy db table names
  #set_primary_key 'ID'   # legacy db table names

  validates_presence_of :first_name, :surname, :password, :login
  validates_uniqueness_of :login, :case_sensitive => false

  def self.authenticate(login, password)
    if u = find_by_login(login)
      if u.password == password
        return true
      else
        return false
      end
    else
      return false
    end
  end
end
