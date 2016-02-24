class Project < ActiveRecord::Base
  self.primary_key = :id
  validates :id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :genre, presence: true
  validates :owner_id, presence: true
  validates :content, presence: true
  validates :goal_money, presence: true, numericality: { only_integer: true }
  validates :deadline, presence: true
  validates :flag, presence: true
end
