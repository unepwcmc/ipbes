class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.text :title
      t.string :short_title
      t.text :note
      t.boolean :ready_to_publish
      t.boolean :published
      t.integer :editor_id

      t.timestamps
    end
  end
end
