class RenameAttachmentToReference < ActiveRecord::Migration
  def up
    rename_table :attachments, :references
    rename_column :references, :attachment_type, :reference_type
  end

  def down
    rename_table :references, :attachments
    rename_column :references, :reference_type, :attachment_type
  end
end
