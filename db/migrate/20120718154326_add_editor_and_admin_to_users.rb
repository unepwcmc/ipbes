class AddEditorAndAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :editor, :boolean
    add_column :users, :admin, :boolean
  end
end
