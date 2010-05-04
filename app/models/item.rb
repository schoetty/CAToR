class Item < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :level
  belongs_to :category
  has_many :possible_solutions

  validates_presence_of :level_id, :category_id, :creator_id, :content

  # categorize with pagination
  def self.categorize(category, page)
    if category
      paginate :page => page, :order => 'level_id',
               :conditions => ['category_id = ?', category['id']]
    else
      paginate :page => page, :order => 'level_id'
    end
  end

  # method to get a random item from database with given category and difficulty
  # items with their id in the presented_items array were ignored
  def self.random(category_id, difficulty, presented_items)
    items = self.find(:all, :joins => 'INNER JOIN levels ON levels.id = level_id',
                      :conditions => ['difficulty = ? AND category_id = ?', difficulty, category_id])
    possible_items = Array.new
    items.each { |i| unless presented_items.include? i.id then possible_items << i end } rescue nil
    item = possible_items[rand(possible_items.count)]
    return item
  end
end