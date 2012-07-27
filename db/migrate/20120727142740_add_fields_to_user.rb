class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :institution, :string
    add_column :users, :description, :text
  end
end
