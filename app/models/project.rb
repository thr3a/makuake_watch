class Project < ActiveRecord::Base
  self.primary_key = :id

  has_many :project_progresses, foreign_key: :project_id

  validates :id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :genre, presence: true
  validates :owner_id, presence: true
  validates :content, presence: true
  validates :goal_money, presence: true, numericality: { only_integer: true }
  validates :deadline, presence: true
  validates :flag, presence: true

  scope :s_title, ->(q) { where("title like ?", "%#{q}%") }
  scope :s_order, ->(q) { order("created_at #{q}") }
  # scope :s_flag, ->(q) { order("price #{q}") }
  # scope :s_onsale, ->(q) { where(onsale: !q.to_i.zero?) }
end
