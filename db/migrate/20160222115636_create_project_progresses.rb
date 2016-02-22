class CreateProjectProgresses < ActiveRecord::Migration
  def change
    create_table :project_progresses do |t|
      t.string :project_id
      t.integer :money
      t.integer :supporter_num
      t.date :date

      t.timestamps null: false
    end
  end
end
