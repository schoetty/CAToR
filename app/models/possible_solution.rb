class PossibleSolution < ActiveRecord::Base
  belongs_to :item

  def self.correct?(id)
    if self.find(id).correct == 1
      return true
    else
      return false
    end
  end

end
