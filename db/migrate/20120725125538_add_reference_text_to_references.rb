class AddReferenceTextToReferences < ActiveRecord::Migration
  def change
    add_column :references, :reference_text, :text
  end
end
