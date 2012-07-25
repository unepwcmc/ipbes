module AssessmentsHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, 'remove_fields(this)', class: 'btn')
  end

  def link_to_add_fields(name, f, association, type, form_type='field')
    new_object = f.object.class.reflect_on_association(association).klass.new
    new_object["#{association.to_s.singularize}_type".to_sym] = type
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render("nested_#{form_type}_form", f: builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", class: 'btn')
  end

  def answer_object assessment, type
    assessment.answers.where(answer_type: type).first || @assessment.answers.build(answer_type: type)
  end

  def answer_objects assessment, type
    assessment.answers.where(answer_type: type) + [@assessment.answers.build(answer_type: type)]
  end

  # Builds an attachment object for the given type, used for form building
  def attachment_object assessment, type
    assessment.attachments.where(attachment_type: type).first || @assessment.attachments.build(attachment_type: type)
  end

  # Get all the current attachments
  def attachment_objects assessment, type
    assessment.attachments.where(attachment_type: type)
  end
end
