class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :assessment_id
      t.string :attachment_type
      

      t.timestamps
    end
  end
end
