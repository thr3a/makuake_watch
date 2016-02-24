class ProjectProgress < ActiveRecord::Base
  belongs_to :project

  validates :project_id, presence: true
  validates :date, presence: true
  validates :money, presence: true, numericality: { only_integer: true }
  validates :supporter_num, presence: true, numericality: { only_integer: true }
end
