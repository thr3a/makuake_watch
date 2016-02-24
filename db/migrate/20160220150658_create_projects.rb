class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects, id: false do |t|
      t.string :id, null: false
      t.string :title
      t.string :genre
      t.string :owner_id
      t.text :content
      t.integer :goal_money
      t.integer :money
      t.date :deadline
      t.integer :supporter_num

      t.timestamps null: false
    end
    add_index :projects, :id, unique: true
  end
end
