class RemoveEditorFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :editor
    add_column :users, :approved, :boolean, default: false
    add_index  :users, :approved
  end

  def down
    add_column :users, :editor, :boolean
    remove_index  :users, :approved
    remove_column :users, :approved
  end
end
