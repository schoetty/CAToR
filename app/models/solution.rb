class Solution < ActiveRecord::Base
  belongs_to :item
  belongs_to :exam
end
