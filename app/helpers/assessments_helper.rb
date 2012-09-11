module AssessmentsHelper
  def link_to_remove_fields(name, f, class_names = '')
    f.hidden_field(:_destroy) + link_to_function(name, 'remove_fields(this)', class: 'btn btn-danger ' + class_names)
  end

  def link_to_add_fields(name, f, association, type)
    new_object = f.object.class.reflect_on_association(association).klass.new
    new_object["#{association.to_s.singularize}_type".to_sym] = type
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render("#{association.to_s.singularize}_fields", f: builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", class: 'btn btn-green')
  end

  def answer_object assessment, type
    assessment.answers.where(answer_type: type).first || @assessment.answers.build(answer_type: type)
  end

  def answer_objects assessment, type
    assessment.answers.where(answer_type: type) # + [@assessment.answers.build(answer_type: type)]
  end

  # Builds an reference object for the given type, used for form building
  def reference_object assessment, type
    assessment.references.where(reference_type: type).first || @assessment.references.build(reference_type: type)
  end

  # Get all the current references
  def reference_objects assessment, type
    assessment.references.where(reference_type: type)
  end

  def list_countries assessment
    countries_ids = assessment.answers.where(answer_type: 'geo_countries').first.try(:text_value)
    if countries_ids
      countries_ids = countries_ids.split(',')
      if countries_ids.empty?
        '-'
      elsif countries_ids.size > 1
        'Multiple'
      else
        Country.find(countries_ids[0]).name
      end
    else
      '-'
    end
  end
  
  def list_countries_without_multiple assessment
    countries_ids = assessment.answers.where(answer_type: 'geo_countries').first.try(:text_value)
    Country.find(countries_ids.split(',')).map(&:name).join(', ')
  end

  # Converts an array of countries to point JSON
  def countries_to_point_json countries
    json = '['
    points = []
    countries.each do |c|
      if c.latitude.present? && c.longitude.present?
        str = "{id:#{c.id},name:'#{c.name}',lat:#{c.latitude},lng:#{c.longitude}"
        str << ", assessment_count: #{c.assessment_count}" if c.assessment_count.present?
        str << "}"
        points << str
      end
    end
    json << points.join(',')
    json << ']'
  end

  def assessment_to_csv assessment
    CSV.generate do |csv|
      csv << ['Section', 'Question', 'Answer', 'Notes']
      csv << ['Title', 'Full Name', assessment.title]
      assessment.answers.where(answer_type: 'geo_scale').each do |answer|
        csv <<['Geographical coverage','Geographical scale of the assessment', answer.text_value]
      end
      assessment.answers.where(answer_type: 'geo_countries').each do |answer|
        csv <<['Geographical coverage','Countries covered', list_countries_without_multiple(assessment)]
      end
      assessment.answers.where(answer_type: 'geo_info').each do |answer|
        csv <<['Geographical coverage',"Any other necessary information or explanation for identifying the location of the assessment, including site or region name", answer.text_value]
      end

      # Conceptual framework, methodology and scope
      assessment.answers.where(answer_type: 'objectives').each do |answer|
        csv << ['Conceptual framework, methodology and scope', 'Assessment objectives', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'mandate').each do |answer|
        csv << ['Conceptual framework, methodology and scope', 'Mandate for the assessment', answer.text_value ]
      end
      
      multi_answer = []
      assessment.answers.where(answer_type: 'conceptual_framework_other').each do |answer|
        multi_answer << answer.text_value
      end
      assessment.answers.where(answer_type: 'conceptual_framework').each do |answer|
        csv << ['Conceptual framework, methodology and scope', 'Conceptual framework and/or methodology used for the assessment', "#{answer.text_value}, #{multi_answer.join(',')}" ]
      end

      references = []
      assessment.references.where(reference_type: 'conceptual_framework_url').each do |reference|
        references << [reference.reference_text, APP_CONFIG['url']+reference.file.url]
      end
      assessment.answers.where(answer_type: 'conceptual_framework_url').each do |answer|
        csv << ['Conceptual framework, methodology and scope', 'URL or copy of conceptual framework developed or adapted', answer.text_value, references.join(',') ]
      end

      multi_answer = []
      assessment.answers.where(answer_type: 'systems_assessed_other').each do |answer|
        multi_answer << answer.text_value
      end
      assessment.answers.where(answer_type: 'systems_assessed').each do |answer|
        csv << ['Conceptual framework, methodology and scope', 'System(s) assessed', "#{answer.text_value}, #{multi_answer.join(',')}" ]
      end

      assessment.answers.where(answer_type: 'species_groups_assessed').each do |answer|
        csv << ['Conceptual framework, methodology and scope', 'Species groups assessed', answer.text_value ]
      end

      # Ecosystem services/functions assessed
      multi_answer = []    
      assessment.answers.where(answer_type: 'provisioning_other').each do |answer|
        multi_answer << answer.text_value
      end
      assessment.answers.where(answer_type: 'provisioning').each do |answer|
        csv << ['Ecosystem services/functions assessed', 'Provisioning', "#{answer.text_value}, #{multi_answer.join(',')}" ]
      end

      multi_answer = []
      assessment.answers.where(answer_type: 'regulating_other').each do |answer|
        multi_answer << answer.text_value
      end
      assessment.answers.where(answer_type: 'regulating').each do |answer|
        csv << ['Ecosystem services/functions assessed', 'Regulating', "#{answer.text_value}, #{multi_answer.join(',')}" ]
      end

      multi_answer = []
      assessment.answers.where(answer_type: 'supporting_other').each do |answer|
        multi_answer << answer.text_value
      end
      assessment.answers.where(answer_type: 'supporting').each do |answer|
        csv << ['Ecosystem services/functions assessed', 'Supporting Services/Functions', "#{answer.text_value}, #{multi_answer.join(',')}" ]
      end

      multi_answer = []
      assessment.answers.where(answer_type: 'cultural_services_other').each do |answer|
        multi_answer << answer.text_value
      end
      assessment.answers.where(answer_type: 'cultural_services').each do |answer|
        csv << ['Ecosystem services/functions assessed', 'Cultural Services', "#{answer.text_value}, #{multi_answer.join(',')}" ]
      end

      # Scope of assessment includes
      assessment.answers.where(answer_type: 'scope_drivers_of_change').each do |answer|
        csv << ['Scope of assessment includes', 'Drivers of change in systems and services', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'scope_impacts_of_change').each do |answer|
        csv << ['Scope of assessment includes', 'Impacts of change in services on human well-being', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'scope_options_for_responding').each do |answer|
        csv << ['Scope of assessment includes', 'Options for responding/interventions to the trends observed', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'scope_explicit_consideration').each do |answer|
        csv << ['Scope of assessment includes', 'Explicit consideration of the role of biodiversity in the systems and services covered by the assessment', answer.text_value ]
      end

      # Timing of the assessment
      assessment.answers.where(answer_type: 'year_started').each do |answer|
        csv << ['Timing of the assessment', 'Year assessment started', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'year_finished').each do |answer|
        csv << ['Timing of the assessment', 'Year assessment finished', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'anticipated_to_finish').each do |answer|
        csv << ['Timing of the assessment', 'If ongoing, year assessment is anticipated to finish', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'periodicity').each do |answer|
        csv << ['Timing of the assessment', 'Periodicity of assessment', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'how_frequently').each do |answer|
        csv << ['Timing of the assessment', 'If repeated, how frequently', answer.text_value ]
      end

      # Assessment outputs
      assessment.answers.where(answer_type: 'websites').each do |answer|
        csv << ['Assessment outputs', 'Website(s)', answer.text_value ]
      end
      assessment.references.where(reference_type: 'reports').each do |reference|
        csv << ['Assessment outputs', 'Report(s)', "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"]
      end
      assessment.references.where(reference_type: 'communication_materials').each do |reference|
        csv << ['Assessment outputs', 'Communication materials (e.g. brochure, presentations, posters, audio-visual media)', "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"]
      end
      assessment.references.where(reference_type: 'journal_publications').each do |reference|
        csv << ['Assessment outputs', 'Journal publications', "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"]
      end
      assessment.references.where(reference_type: 'training_materials').each do |reference|
        csv << ['Assessment outputs', 'Training materials', "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"]
      end
      assessment.references.where(reference_type: 'other_documents').each do |reference|
        csv << ['Assessment outputs', 'Other documents/outputs', "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"]
      end

      #Tools and processes
      multi_answer = []
      assessment.answers.where(answer_type: 'tools_and_approaches_other').each do |answer|
        multi_answer << answer.text_value
      end
      references = []
      assessment.references.where(reference_type: 'tools_and_approaches_other').each do |reference|
        references << [reference.reference_text, APP_CONFIG['url']+reference.file.url]
      end
      assessment.answers.where(answer_type: 'tools_and_approaches').each do |answer|
        csv << ['Tools and processes', 'Tools and approaches used in the assessment', "#{answer.text_value}, #{multi_answer.join(',')}" , references.join(',')]
      end

      assessment.answers.where(answer_type: 'process_used_for_stakeholder').each do |answer|
        csv << ['Tools and processes', 'Process used for stakeholder engagement in the assessment process and which component', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'key_stakeholder').each do |answer|
        csv << ['Tools and processes', 'Key stakeholder groups engaged', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'number_of_people').each do |answer|
        csv << ['Tools and processes', 'The number of people directly involved in the assessment process', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'incorporation_of_knowledge').each do |answer|
        csv << ['Tools and processes', 'Incorporation of scientific and other types of knowledge', answer.text_value ]
      end
      assessment.references.where(reference_type: 'supporting_documentation').each do |reference|
        csv << ['Tools and processes', 'Supporting documentation for specific approaches, methodology or criteria developed and/or used to integrate knowledge systems into the assessment', "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"]
      end
      assessment.answers.where(answer_type: 'reports_peer').each do |answer|
        csv << ['Tools and processes', 'Assessment reports peer reviewed', answer.text_value ]
      end

      # Data
      assessment.answers.where(answer_type: 'accessibility_of_data').each do |answer|
        csv << ['Section', 'Accessibility of data used in assessment', answer.text_value ]
      end

      # Policy Impact
      assessment.references.where(reference_type: 'impacts').each do |reference|
        csv << ['Policy Impact', 'Impacts the assessment has had on policy and/or decision making, as evidenced through policy references and actions', "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"]
      end

      references = []
      assessment.references.where(reference_type: 'review_on_policy').each do |reference|
        references << [reference.reference_text, APP_CONFIG['url']+reference.file.url]
      end
      assessment.answers.where(answer_type: 'review_on_policy').each do |answer|
        csv << ['Policy Impact', 'Independent or other review on policy impact of the assessment', answer.text_value, references.join(',') ]
      end

      assessment.answers.where(answer_type: 'lessons_learnt').each do |answer|
        csv << ['Policy Impact', 'Lessons learnt for future assessments from these reviews', answer.text_value ]
      end

      # Capacity-building
      assessment.answers.where(answer_type: 'capacity_building_needs').each do |answer|
        csv << ['Capacity-building', 'Capacity building needs idenfified during the assessment', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'actions_taken_build_capacity').each do |answer|
        csv << ['Capacity-building', 'Actions taken by the assessment to build capacity', answer.text_value ]
      end
      assessment.answers.where(answer_type: 'gaps_in_capacity').each do |answer|
        csv << ['Capacity-building', 'How have gaps in capacity been communicated to the different stakeholders', answer.text_value ]
      end

      # Knowledge generation
      assessment.answers.where(answer_type: 'gaps_in_knowledge').each do |answer|
        csv << ['Knowledge generation', 'Gaps in knowledge identified from the assessment', answer.text_value ]
      end
      references = []
      assessment.references.where(reference_type: 'gaps_in_knowledge_communicated').each do |reference|
        references << [reference.reference_text, APP_CONFIG['url']+reference.file.url]
      end
      assessment.answers.where(answer_type: 'gaps_in_knowledge_communicated').each do |answer|
        csv << ['Knowledge generation', 'How gaps in knowledge have been communicated to the different stakeholders', answer.text_value , references.join(',')]
      end

      # Additional information
      assessment.answers.where(answer_type: 'additional_information').each do |answer|
        csv << ['Additional information', 'Additional relevant information', answer.text_value ]
      end
    end
  end

  def horizontal_assessment_to_csv assessment
    csv = []

    # Title

    ## Full name of the assessment
    csv << assessment.title

    ## Short name of the assessment (if applicable)
    csv << assessment.short_title

    # Geographical coverage

    ## Geographical scale of the assessment
    assessment.answers.where(answer_type: 'geo_scale').each do |answer|
      csv << answer.text_value
    end

    ## Countries covered
    assessment.answers.where(answer_type: 'geo_countries').each do |answer|
      csv << list_countries_without_multiple(assessment)
    end

    ## Any other necessary information or explanation for identifying the location of the assessment, including site or region name
    assessment.answers.where(answer_type: 'geo_info').each do |answer|
      csv << answer.text_value
    end

    # Conceptual framework, methodology and scope

    ## Assessment objectives
    assessment.answers.where(answer_type: 'objectives').each do |answer|
      csv << answer.text_value
    end

    ## Mandate for the assessment
    assessment.answers.where(answer_type: 'mandate').each do |answer|
      csv << answer.text_value
    end

    ## Conceptual framework and/or methodology used for the assessment
    multi_answer = []
    assessment.answers.where(answer_type: 'conceptual_framework_other').each do |answer|
      multi_answer << answer.text_value
    end
    assessment.answers.where(answer_type: 'conceptual_framework').each do |answer|
      csv << (multi_answer << answer.text_value).join(', ')
    end

    ## URL or copy of conceptual framework developed or adapted
    references = []
    assessment.references.where(reference_type: 'conceptual_framework_url').each do |reference|
      references << [reference.reference_text, APP_CONFIG['url']+reference.file.url]
    end
    assessment.answers.where(answer_type: 'conceptual_framework_url').each do |answer|
      csv << "#{answer.text_value}\n\n#{references.join("\n")}"
    end

    ## System(s) assessed
    multi_answer = []
    assessment.answers.where(answer_type: 'systems_assessed_other').each do |answer|
      multi_answer << answer.text_value
    end
    assessment.answers.where(answer_type: 'systems_assessed').each do |answer|
      csv << (multi_answer << answer.text_value).join(', ')
    end

    ## Species groups assessed
    assessment.answers.where(answer_type: 'species_groups_assessed').each do |answer|
      csv << answer.text_value
    end

    # Ecosystem services/functions assessed

    ## Provisioning
    multi_answer = []    
    assessment.answers.where(answer_type: 'provisioning_other').each do |answer|
      multi_answer << answer.text_value
    end
    assessment.answers.where(answer_type: 'provisioning').each do |answer|
      csv << (multi_answer << answer.text_value).join(', ')
    end

    ## Regulating
    multi_answer = []
    assessment.answers.where(answer_type: 'regulating_other').each do |answer|
      multi_answer << answer.text_value
    end
    assessment.answers.where(answer_type: 'regulating').each do |answer|
      csv << (multi_answer << answer.text_value).join(', ')
    end

    ## Supporting Services/Functions
    multi_answer = []
    assessment.answers.where(answer_type: 'supporting_other').each do |answer|
      multi_answer << answer.text_value
    end
    assessment.answers.where(answer_type: 'supporting').each do |answer|
      csv << (multi_answer << answer.text_value).join(', ')
    end

    ## Cultural Services
    multi_answer = []
    assessment.answers.where(answer_type: 'cultural_services_other').each do |answer|
      multi_answer << answer.text_value
    end
    assessment.answers.where(answer_type: 'cultural_services').each do |answer|
      csv << (multi_answer << answer.text_value).join(', ')
    end

    # Scope of assessment includes

    ## Drivers of change in systems and services
    assessment.answers.where(answer_type: 'scope_drivers_of_change').each do |answer|
      csv << answer.text_value
    end

    ## Impacts of change in services on human well-being
    assessment.answers.where(answer_type: 'scope_impacts_of_change').each do |answer|
      csv << answer.text_value
    end

    ## Options for responding/interventions to the trends observed
    assessment.answers.where(answer_type: 'scope_options_for_responding').each do |answer|
      csv << answer.text_value
    end

    ## Explicit consideration of the role of biodiversity in the systems and services covered by the assessment
    assessment.answers.where(answer_type: 'scope_explicit_consideration').each do |answer|
      csv << answer.text_value
    end

    # Timing of the assessment

    ## Year assessment started
    assessment.answers.where(answer_type: 'year_started').each do |answer|
      csv << answer.text_value
    end

    ## Year assessment finished
    assessment.answers.where(answer_type: 'year_finished').each do |answer|
      csv << answer.text_value
    end

    ## If ongoing, year assessment is anticipated to finish
    assessment.answers.where(answer_type: 'anticipated_to_finish').each do |answer|
      csv << answer.text_value
    end

    ## Periodicity of assessment
    assessment.answers.where(answer_type: 'periodicity').each do |answer|
      csv << answer.text_value
    end

    ## If repeated, how frequently
    assessment.answers.where(answer_type: 'how_frequently').each do |answer|
      csv << answer.text_value
    end

    # Assessment outputs

    ## Website(s)
    assessment.answers.where(answer_type: 'websites').each do |answer|
      csv << answer.text_value
    end

    ## Report(s)
    assessment.references.where(reference_type: 'reports').each do |reference|
      csv << "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"
    end

    ## Communication materials (e.g. brochure, presentations, posters, audio-visual media)
    assessment.references.where(reference_type: 'communication_materials').each do |reference|
      csv << "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"
    end

    ## Journal publications
    assessment.references.where(reference_type: 'journal_publications').each do |reference|
      csv << "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"
    end

    ## Training materials
    assessment.references.where(reference_type: 'training_materials').each do |reference|
      csv << "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"
    end

    ## Other documents/outputs
    assessment.references.where(reference_type: 'other_documents').each do |reference|
      csv << "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"
    end

    # Tools and processes

    ## Tools and approaches used in the assessment
    multi_answer = []
    assessment.answers.where(answer_type: 'tools_and_approaches_other').each do |answer|
      multi_answer << answer.text_value
    end
    references = []
    assessment.references.where(reference_type: 'tools_and_approaches_other').each do |reference|
      references << [reference.reference_text, APP_CONFIG['url']+reference.file.url]
    end
    assessment.answers.where(answer_type: 'tools_and_approaches').each do |answer|
      csv << "#{answer.text_value}, #{multi_answer.join(',')}\n\n#{references.join("\n")}"
    end

    ## Process used for stakeholder engagement in the assessment process and which component
    assessment.answers.where(answer_type: 'process_used_for_stakeholder').each do |answer|
      csv << answer.text_value
    end

    ## Key stakeholder groups engaged
    assessment.answers.where(answer_type: 'key_stakeholder').each do |answer|
      csv << answer.text_value
    end

    ## The number of people directly involved in the assessment process
    assessment.answers.where(answer_type: 'number_of_people').each do |answer|
      csv << answer.text_value
    end

    ## Incorporation of scientific and other types of knowledge
    assessment.answers.where(answer_type: 'incorporation_of_knowledge').each do |answer|
      csv << answer.text_value
    end

    ## Supporting documentation for specific approaches, methodology or criteria developed and/or used to integrate knowledge systems into the assessment
    assessment.references.where(reference_type: 'supporting_documentation').each do |reference|
      csv << "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"
    end

    ## Assessment reports peer reviewed
    assessment.answers.where(answer_type: 'reports_peer').each do |answer|
      csv << answer.text_value
    end

    # Data

    ## Accessibility of data used in assessment
    assessment.answers.where(answer_type: 'accessibility_of_data').each do |answer|
      csv << answer.text_value
    end

    # Policy Impact

    ## Impacts the assessment has had on policy and/or decision making, as evidenced through policy references and actions
    assessment.references.where(reference_type: 'impacts').each do |reference|
      csv << "#{reference.reference_text}, #{APP_CONFIG['url']+reference.file.url}"
    end

    ## Independent or other review on policy impact of the assessment
    references = []
    assessment.references.where(reference_type: 'review_on_policy').each do |reference|
      references << [reference.reference_text, APP_CONFIG['url']+reference.file.url]
    end
    assessment.answers.where(answer_type: 'review_on_policy').each do |answer|
      csv << "#{answer.text_value}\n\n#{references.join("\n")}"
    end

    ## Lessons learnt for future assessments from these reviews
    assessment.answers.where(answer_type: 'lessons_learnt').each do |answer|
      csv << answer.text_value
    end

    # Capacity-building

    ## Capacity building needs idenfified during the assessment
    assessment.answers.where(answer_type: 'capacity_building_needs').each do |answer|
      csv << answer.text_value
    end

    ## Actions taken by the assessment to build capacity
    assessment.answers.where(answer_type: 'actions_taken_build_capacity').each do |answer|
      csv << answer.text_value
    end

    ## How have gaps in capacity been communicated to the different stakeholders
    assessment.answers.where(answer_type: 'gaps_in_capacity').each do |answer|
      csv << answer.text_value
    end

    # Knowledge generation

    ## Gaps in knowledge identified from the assessment
    assessment.answers.where(answer_type: 'gaps_in_knowledge').each do |answer|
      csv << answer.text_value
    end

    ## How gaps in knowledge have been communicated to the different stakeholders
    references = []
    assessment.references.where(reference_type: 'gaps_in_knowledge_communicated').each do |reference|
      references << [reference.reference_text, APP_CONFIG['url']+reference.file.url]
    end
    assessment.answers.where(answer_type: 'gaps_in_knowledge_communicated').each do |answer|
      csv << "#{answer.text_value}\n\n#{references.join("\n")}"
    end

    # Additional information

    ## Additional relevant information
    assessment.answers.where(answer_type: 'additional_information').each do |answer|
      csv << answer.text_value
    end

    csv
  end
end
