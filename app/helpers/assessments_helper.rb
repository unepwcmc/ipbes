module AssessmentsHelper
  def answer_object assessment, type
    assessment.answers.where(answer_type: type).first || @assessment.answers.build(answer_type: type)
  end

  def answer_objects assessment, type
    assessment.answers.where(answer_type: type) + [@assessment.answers.build(answer_type: type)]
  end
end
