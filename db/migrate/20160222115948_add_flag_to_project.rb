class AddFlagToProject < ActiveRecord::Migration
  def change
    add_column :projects, :flag, :integer
  end
end
