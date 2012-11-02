class AddAssessmentIdIndexToAnswers < ActiveRecord::Migration
  def change
    add_index :answers, :assessment_id
  end
end
