class Exam < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :items
  has_many :solutions

  # calculate the difficulty level of an item by a given theta
  def self.dif(theta)
    diff = (theta*2).round / 2.0
    unless diff.between?(-3,3)
      if diff < -3 then diff = -3 end
      if diff > 3 then diff = 3 end
    end
    return diff
  end
end