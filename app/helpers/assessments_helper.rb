module AssessmentsHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, 'remove_fields(this)', class: 'btn')
  end

  def link_to_add_fields(name, f, association, type)
    new_object = f.object.class.reflect_on_association(association).klass.new
    new_object[:answer_type] = type
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render("#{type}_fields", f: builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", class: 'btn')
  end

  def answer_object assessment, type
    assessment.answers.where(answer_type: type).first || @assessment.answers.build(answer_type: type)
  end

  def answer_objects assessment, type
    assessment.answers.where(answer_type: type) + [@assessment.answers.build(answer_type: type)]
  end
end
