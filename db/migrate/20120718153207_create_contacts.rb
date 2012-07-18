class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :title
      t.string :email
      t.string :phone
      t.string :organisation
      t.text :organisation_address
      t.integer :assessment_id

      t.timestamps
    end
  end
end
