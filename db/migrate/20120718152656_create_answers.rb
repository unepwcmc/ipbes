class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :answer_type
      t.text :text_value
      t.integer :integer_value
      t.integer :assessment_id

      t.timestamps
    end
  end
end
