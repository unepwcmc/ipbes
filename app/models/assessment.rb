class Assessment < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :references, dependent: :destroy
  has_many :contacts, dependent: :destroy
  belongs_to :last_editor, :class_name => 'User'

  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:text_value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :references, allow_destroy: true
  accepts_nested_attributes_for :contacts, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  validates :title, presence: true, uniqueness: true
  
  def self.search(filters)
<<<<<<< HEAD
    return scoped if filters['q'].blank? && filters['geo_scale'].blank? &&
      filters['systems_assessed'].blank? && filters['ecosystem_services_functions_assessed'].blank? &&
      filters['tools_and_approaches'].blank?

    attachments = (filters['attachments'] == 't')
    cse_query(filters['q'], attachments)
      .filter_by_answer_type('geo_scale', filters['geo_scale'])
      .filter_by_answer_type('systems_assessed', filters['systems_assessed'])
      .multiple_filter_by_answer_type([['provisioning', filters['ecosystem_services_functions_assessed'], ['Food', 'Water', 'Timber/fibres', 'Genetic resources', 'Medicinal resources', 'Ornamental resources', 'Energy/fuel'], 'other_provisioning'],
        ['supporting', filters['ecosystem_services_functions_assessed'], ['Habitat maintenance', 'Nutrient cycling', 'Soil formation and fertility', 'Primary production'], 'other_supporting'],
        ['cultural_services', filters['ecosystem_services_functions_assessed'], ['Recreation and tourism', 'Spiritual, inspiration and cognitive development'], 'other_cultural'],
        ['regulating', filters['ecosystem_services_functions_assessed'], ['Air quality', 'Climate regulation', 'Moderation of extreme events', 'Regulation of water flows', 'Regulation of water quality', 'Waste treatment', 'Erosion prevention', 'Pollination', 'Pest and disease control'], 'other_regulating']])
      .filter_by_answer_type('tools_and_approaches', filters['tools_and_approaches'])
=======
    return scoped if filters['q'].blank? && filters['geo_scale'].blank? && filters['countryId'].blank?
    
    attachments = filters['attachments'] == 't'
    results = cse_query(filters['q'], attachments).
      filter_by_answer_type('geo_scale', filters['geo_scale']).
      in_country(filters['countryId'])
>>>>>>> a54957f272744754b87c7a8d995f6c96941cd334
  end

  def self.cse_query(q, attachments = false)
    return scoped if q.blank?

    require 'open-uri'
    response = Nokogiri::XML(open("http://www.google.com/search?cx=013379249883164858539:b_mvcbrgpgk&client=google-csbe&output=xml_no_dtd&q=#{q}"))

    ids_array = response.xpath('//GSP/RES/R/U').map { |u|
      id = 0
      # To get the ID from the URL, first we must work out what path it is
      case u.content
      when /.*\/assessments\/([0-9]*)/
        # Assessment show
        id = $1
      when /.*\/assessment\/([0-9]*)\/references\/files\/[0-9]*\/.*/
        # Reference show
        id = $1 if attachments
      end
      id 
    }.uniq

    where(id: ids_array)
  end

  def self.multiple_filter_by_answer_type(queries)
    mapped_queries = queries.map { |query|
      self.filter_by_answer_type_logic(query[0], query[1], query[2], query[3])
    }.compact.join(' OR ')

    joins('LEFT OUTER JOIN answers ON assessment_id=assessments.id').where(mapped_queries)
  end
  
  def self.filter_by_answer_type_logic(type, value, accepted_values = [], other_option = nil)
    # Returns if blank values
    return nil if type.blank? || value.blank?

    # Forces value to be an Array
    values = [value].flatten
    # Intersection of values and accepted_values, returns false if none
    values = (values & accepted_values)

    # Returns if there are no valid values
    return nil if values.empty? && other_option.nil?

    clause = values.map { |v| sanitize_sql_array(["',' || answers.text_value || ',' ILIKE ?", "%,#{v},%"]) }.join(' OR ')
    unless clause.empty?
      clause = "#{sanitize_sql_array(["answers.answer_type = ?", type])} AND #{clause}"
    end

    if [value].flatten.include?(other_option)
      other_clause = "#{sanitize_sql_array(["answers.answer_type = ?", "#{type}_other"])}"
      if clause.empty?
        clause = other_clause
      else
        clause = "(#{clause}) OR #{other_clause}"
      end
    end

    if clause.empty?
      return nil
    else
      clause
    end
  end

  def self.filter_by_answer_type(type, value, accepted_values = [], other_option = nil)
    clause = self.filter_by_answer_type_logic(type, value, accepted_values, other_option)

    if clause.nil?
      scoped
    else
      joins('LEFT OUTER JOIN answers ON assessment_id=assessments.id').where(clause)
    end
  end

  def self.in_country(country_id)
    return scoped if country_id.blank?
    assessment_ids = []
    Answer.where(answer_type: 'geo_countries').each do |answer|
      assessment_ids << answer.assessment_id if answer.try(:text_value).split(',').include?(country_id)
    end
    where(id: assessment_ids.uniq)
  end

  # Gets all the countries associated through the geo_countries answers. Bit slow, sorry
  def countries
    countries_ids = self.answers.where(answer_type: 'geo_countries').first.try(:text_value).split(',')
    Country.where(:id => countries_ids)
  end
end
