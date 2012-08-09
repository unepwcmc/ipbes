class AddLastEditorToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :last_editor_id, :integer
  end
end
