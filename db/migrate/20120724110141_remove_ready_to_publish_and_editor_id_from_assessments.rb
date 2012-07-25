class RemoveReadyToPublishAndEditorIdFromAssessments < ActiveRecord::Migration
  def up
    remove_column :assessments, :ready_to_publish
    remove_column :assessments, :editor_id
  end

  def down
    add_column :assessments, :editor_id, :integer
    add_column :assessments, :ready_to_publish, :boolean
  end
end
